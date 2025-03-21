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
alias xclip='xargs echo -n | xclip -selection clipboard'
alias az-cloud='az cloud set -n AzureCloud'
alias az-gov='az cloud set -n AzureUSGovernment'
```

dot source the changes into any opened instances of bash:

```sh
. ~/.bashrc
```

## `~/.profile`

```sh
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