# Configuration

## `~/.bashrc`

```sh
source <(ng completion script)
source <(kubectl completion bash)
source <(minikube completion bash)

alias help-ng='echo "ng new <app> -g --minimal --routing --directory <dir> --style css --ssr false"'
alias up='sudo apt update && sudo apt upgrade -y && sudo apt autoremove -y'
alias fwup='fwupdmgr refresh --force && fwupdmgr get-updates && fwupdmgr update'
alias xclip='xargs echo -n | xclip -selection clipboard'
alias az-cloud='az cloud set -n AzureCloud'
alias az-gov='az cloud set -n AzureUSGovernment'
alias az-gov-test='az account set -n s2va-gov-test'
alias az-gov-ss='az account set -n s2va-gov-sharedservices'
alias guid='uuidgen'

vsc() {
    code "$1"; exit
}
```

dot source the changes into any opened instances of bash:

```sh
. ~/.bashrc
```

## `~/.profile`

```sh
export DOTNET_ROOT=$HOME/.dotnet
export VOLTA_HOME="$HOME/.volta"
export XCURSOR_SIZE=16

export PATH="$PATH:/usr/local/go/bin"
export PATH="$PATH:$DOTNET_ROOT:$DOTNET_ROOT/tools"
export PATH="$PATH:$VOLTA_HOME/bin"
```

dot source hte changes into any open terminals:

```sh
. ~/.profile
```

## nushell

In order to manage [nushell configuration](https://www.nushell.sh/book/configuration.html), you must first specify a buffer editor then run the config command:

```nushell
$env.config.buffer_editor = "code"

config nu
```

Set the config as follows:

```nushell
$env.config = {
    show_banner: false,
    buffer_editor: "code"
}

$env.PATH = ($env.PATH
    | split row (char esep)
    | append '~/.volta/bin'
    | append '~/.dotnet'
    | append '/usr/local/go/bin'
    | append '~/.dotnet'
    | append '~/.dotnet/tools')

$env.DOTNET_ROOT = '~/.dotnet'

def up [] {
    sudo apt update ; sudo apt upgrade -y ; sudo apt autoremove -y ;
}

def fwup [] {
    fwupdmgr refresh --force ; fwupdmgr get-updates ; fwupdmgr update
}

def clip [] {
    |in| | xargs echo -n | xclip -selection clipboard
}

def vsc [workspace] {
    ^code ($workspace | path expand)
    exit
}

alias help-ng = echo "ng new <app> -g --minimal --routing --directory <dir> --style css --ssr false"
```

### Cosmic Terminal Profiles

Configuration for cosmic terminal is located in `~/.config/cosmic/com.system76.CosmicTerm/v1`.

Set the `profiles` value to:

```rs
{
    0: (
        name: "bash",
        command: "",
        syntax_theme_dark: "COSMIC Dark",
        syntax_theme_light: "COSMIC Light",
        tab_title: "",
        working_directory: "",
        hold: false,
    ),
    1: (
        name: "nushell",
        command: "nu",
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
