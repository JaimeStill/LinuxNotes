# [Steam](https://store.steampowered.com/about/)

Setup and troubleshooting for running Steam games on Omarchy / Arch with Hyprland on NVIDIA.

## Packages

Install via the Omarchy installer (<kbd>Super+Alt+Space</kbd> -> Install -> Package):

```sh
gamemode
lib32-gamemode
mangohud
lib32-mangohud
cpupower
```

The `lib32-` versions are required for 32-bit games. Many native Linux titles and most Proton games are 64-bit, but install the lib32 packages anyway so older titles work without surprises.

## Hyprland Configuration

All edits go in `~/.config/hypr/looknfeel.conf`. After saving, reload with `hyprctl reload` and check for errors with `hyprctl configerrors`.

### Variable Refresh Rate (VRR)

Use mode `2` (fullscreen-only) globally. This avoids desktop flicker that `vrr = 1` (always on) can cause when content refresh rates change between windows.

```conf
misc {
    vrr = 2
}
```

> [!NOTE]
> `hyprctl monitors` will show `vrr: false` when no fullscreen window is present. That is correct — mode 2 only activates VRR when a game goes fullscreen.

### Allow Tearing / Direct Scanout

Lets fullscreen games bypass the compositor for lower latency.

```conf
general {
    allow_tearing = true
}

windowrule = immediate 1, match:fullscreen 1
```

> [!IMPORTANT]
> In Hyprland 0.53+, the `immediate` rule must be written as `immediate 1` (with a value), not bare `immediate`. The bare form throws `invalid field immediate: missing a value`. The matcher uses `match:fullscreen 1` (with the `match:` prefix).
>
> The `immediate` rule only grants permission to tear; the app must request `IMMEDIATE` present mode to actually use it. Only games do this, so videos and other fullscreen apps are unaffected.

## CPU Governor

The default `powersave` governor causes stuttering during games — the CPU stays at low frequency and only ramps up reactively to demand spikes.

Two options:

**Option A — Always-on `performance` (simple, slightly higher idle power):**

```sh
sudo sed -i "s|^#GOVERNOR='ondemand'|GOVERNOR='performance'|" /etc/default/cpupower-service.conf
sudo systemctl enable --now cpupower.service
cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor   # should print: performance
```

**Option B — Let `gamemoderun` flip the governor only while a game is running (cleaner):**

Skip the cpupower service. GameMode will switch to `performance` per-game, then restore on exit. This requires wrapping Steam (see next section) so all game launches go through it.

## Wrap Steam with GameMode

Override the system `.desktop` file so every Steam launch — and every game spawned from Steam — runs under `gamemoderun` automatically. This avoids having to set per-game launch options.

```sh
mkdir -p ~/.local/share/applications
cp /usr/share/applications/steam.desktop ~/.local/share/applications/steam.desktop
sed -i 's|^Exec=/usr/bin/steam |Exec=/usr/bin/gamemoderun /usr/bin/steam |' ~/.local/share/applications/steam.desktop
```

The user-local `.desktop` overrides the system one, survives package updates, and works with all action entries (Library, Big Picture, etc.).

## Per-Game Launch Options

Right-click a game in Steam -> Properties -> Launch Options. Common combinations:

| Launch option | What it does |
|---|---|
| `gamemoderun %command%` | Run under GameMode (redundant if Steam is already wrapped) |
| `mangohud %command%` | Show FPS, frametime, CPU/GPU usage overlay |
| `gamemoderun mangohud %command%` | Both |
| `PROTON_ENABLE_NVAPI=1 %command%` | NVIDIA NVAPI for DLSS/Reflex on Proton games |
| `PROTON_LOG=1 %command%` | Write a Proton log to `~/steam-<appid>.log` for debugging |

> [!TIP]
> Toggle the MangoHud overlay in-game with <kbd>Right-Shift</kbd>+<kbd>F12</kbd>.

## Verification

Run while a game is launched:

```sh
gamemoded -s                                                 # "gamemode is active"
cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor    # performance
hyprctl monitors | grep -E "vrr|tearing"                     # vrr: true, activelyTearing: true
nvidia-smi                                                   # check GPU power state, utilization, temps
sensors                                                      # check CPU temps
```

## Troubleshooting

### Hyprland config errors appear above Waybar after editing window rules

The error is shown directly above the bar (a Hyprland feature). Check what the parser is complaining about:

```sh
hyprctl configerrors
```

Common case: `invalid field immediate: missing a value` — the rule needs `immediate 1`, not bare `immediate`. See the [Allow Tearing](#allow-tearing--direct-scanout) section.

### VRR shows `false` in `hyprctl monitors` even though it's configured

Expected when using `vrr = 2` (fullscreen-only) on the desktop. Launch a fullscreen game and re-run `hyprctl monitors` — `vrr: true` should appear.

### Constant fan noise and stuttering during gameplay

Diagnostic order:

1. **CPU governor** — `cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor`. If `powersave`, that is almost always the cause. Fix with the [CPU Governor](#cpu-governor) section.
2. **Thermals** — run `sensors` and `nvidia-smi -l 1` while the game is running. CPU above ~85°C or GPU above ~83°C means thermal throttling. Check case airflow, fan curves, dust, thermal paste age.
3. **VRAM pressure** — `nvidia-smi` during gameplay. If memory usage is at the cap, lower texture pool / settings.
4. **Compositor overhead** — confirm `activelyTearing: true` in `hyprctl monitors` for the game window. If false, the compositor is still in the path.

### Game does not pick up GameMode

```sh
gamemoded -s                  # check daemon is reachable
ps -ef | grep gamemod         # confirm gamemoderun is in the process tree
```

If Steam was running before the `.desktop` change, fully quit and relaunch. Walker / launchers may also cache desktop entries — restart the launcher if it does not pick up the new entry.

### MangoHud overlay does not appear

- Confirm `mangohud` is in the launch options (or `MANGOHUD=1` env is set)
- For Proton/Steam games, both `mangohud` and `lib32-mangohud` need to be installed
- Some games use anti-cheat that blocks overlays — there is nothing to do about this

## General Guidelines for Steam on Linux

- **Proton Experimental** is the recommended default compatibility tool. Set it under Steam -> Settings -> Compatibility. Switch to a specific Proton version only if a game has known regressions on Experimental.
- **[ProtonDB](https://www.protondb.com/)** has per-game compatibility reports and recommended launch options. Check it before troubleshooting from scratch.
- **Native Vulkan vs translated DX** — games like Doom Eternal use Vulkan natively, so Proton's DXVK/VKD3D translation layers are bypassed. Most "Proton tweaks" found online apply to translated DX games, not native Vulkan ones.
- **Shader pre-caching** — let Steam finish its shader pre-cache (visible in the downloads tab) before launching a game for the first time. Skipping this causes one-off stutters as shaders compile mid-gameplay.
- **Disable the Steam Overlay** for a single game if it crashes on launch (Properties -> General -> uncheck "Enable the Steam Overlay"). Some Proton games dislike it.
- **NVIDIA + Wayland** — driver 555+ supports explicit sync, which fixed most NVIDIA Wayland stutter issues. Keep the driver current.
- **Native game first, Proton fallback** — when a game has a native Linux build, try it first. If it performs worse than Proton (common for older native ports), switch by forcing a specific Proton version under Properties -> Compatibility.
- **`gamescope` as an alternative wrapper** — useful for HDR, FSR upscaling, or running games at a different resolution than the desktop. Launch via `gamescope -- %command%`. Not necessary for the basic optimization path documented here.
