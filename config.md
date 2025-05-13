# Configuration

## `~/.bashrc`

```sh
export DOTNET_ROOT=$HOME/.dotnet
export PATH=$PATH:$DOTNET_ROOT:$DOTNET_ROOT/tools
export XCURSOR_SIZE=16

source <(ng completion script)
source <(kubectl completion bash)
source <(minikube completion bash)

alias up='sudo apt update && sudo apt upgrade -y && sudo apt autoremove -y'
alias fwup='fwupdmgr refresh --force && fwupdmgr get-updates && fwupdmgr update'
alias xclip='xargs echo -n | xclip -selection clipboard'
alias az-cloud='az cloud set -n AzureCloud'
alias az-gov='az cloud set -n AzureUSGovernment'
```

dot source the changes into any opened instances of bash:

```sh
. ~/.bashrc
```

## nushell

In order to manage [nushell configuration](https://www.nushell.sh/book/configuration.html), you must first specify a buffer editor then run the config command:

```nushell
$env.config.buffer_editor = "code"

config nu
```

Set the config as follows:
```
$env.config.show_banner = false
$env.config.buffer_editor = "code"
$env.PATH = ($env.PATH | split row (char esep) | prepend '~/.volta/bin')
```

### Cosmic Terminal Profiles

Configuration for cosmic terminal is located in `~/.config/cosmic/com.system76.CosmicTerm/v1`.

Set the `profiles` value to:

```rs
{
    0: (
        name: "nushell",
        command: "nu",
        syntax_theme_dark: "COSMIC Dark",
        syntax_theme_light: "COSMIC Light",
        tab_title: "",
        working_directory: "",
        hold: false,
    ),
    1: (
        name: "bash",
        command: "",
        syntax_theme_dark: "COSMIC Dark",
        syntax_theme_light: "COSMIC Light",
        tab_title: "",
        working_directory: "",
        hold: false,
    ),
}
```

Set the `default_profile` value to:

```rs
Some(0)
```

## `~/.gitconfig`

The following configuration enables you to establish `git config` settings for any git repository contained within a specific sub-directory (recursive) of the configured directory.

Any of the repositories encountered wtihin `s2va` below would receive this configuration:

* `~` (Linux) or `$env:USERPROFILE` (Windows)
    * s2va
        * testing
            * repository-a
        * repository-b

```sh
[user]
	name = Jaime Still
	email = jpstill85@gmail.com
[includeIf "gitdir:~/s2va/"]
	path = ~/s2va/.gitconfig
```

### `~/s2va/.gitconfig`

```sh
[user]
	email = jaime.p.still.ctr@army.mil
```