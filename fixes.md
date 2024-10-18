# Fixes

The sections below indicate how to fix encountered issues.

## Screen Going Blank After 30 Seconds

[Source](https://www.reddit.com/r/pop_os/comments/eln8bp/screen_going_black_after_30_seconds/)

```bash
xset -dpms
```

## Clean Firefox

```bash
sudo rm -rf /usr/lib/firefox/
rm -rf ~/.var/app/org.mozilla.firefox/
```