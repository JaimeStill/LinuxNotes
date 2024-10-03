# Fixes

The sections below indicate how to fix encountered issues.

## Screen Going Blank After 30 Seconds

[Source](https://www.reddit.com/r/pop_os/comments/eln8bp/screen_going_black_after_30_seconds/)

```bash
xset -dpms
```

## Broken Suspend

[Source](https://github.com/pop-os/pop/issues/449#issuecomment-502746351)

```bash
sudo kernelstub -a mem_sleep_default=deep
```