# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time Oh My Zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="powerlevel10k/powerlevel10k"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git web-search)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='nvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch $(uname -m)"

# Set personal aliases, overriding those provided by Oh My Zsh libs,
# plugins, and themes. Aliases can be placed here, though Oh My Zsh
# users are encouraged to define aliases within a top-level file in
# the $ZSH_CUSTOM folder, with .zsh extension. Examples:
# - $ZSH_CUSTOM/aliases.zsh
# - $ZSH_CUSTOM/macos.zsh
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

alias ff='fastfetch'
alias lg='lazygit'

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

eval $(thefuck --alias)

##### Homelab & SSH #####
if [[ "$(uname)" == "Darwin" ]]; then
    alias tailscale="/Applications/Tailscale.app/Contents/MacOS/Tailscale"
fi

alias ts="tailscale"
alias pve='ssh -Y root@pve'
alias win='ssh -Y cx330@win10'
alias kali='ssh -Y cx330@kali'
alias fedora='ssh -Y cx330@fedora'
alias affine='ssh -Y cx330@affine'
alias travel='ssh -Y cx330@travel'
alias mythic='ssh -Y cx330@mythic'
tokali() {
    # Check if any file arguments were provided
    if [ "$#" -eq 0 ]; then
        echo "Usage: tokali <file1> [file2] ..."
        return 1
    fi

    # Loop through all provided file arguments
    for file in "$@"; do
        # Check if the file exists
        if [ ! -e "$file" ]; then
            echo "Error: File '$file' does not exist."
            continue
        fi

        # Use scp to send the file to the remote server's home directory
        scp -r "$file" cx330@10.1.1.15:~/

        # Check if the scp command was successful
        if [ $? -eq 0 ]; then
            echo "File '$file' was successfully transferred to cx330@kali"
        else
            echo "Error: Failed to transfer file '$file'."
        fi
    done
}
fromkali () {
    if [ "$#" -eq 0 ]
    then
        echo "Usage: fromkali <remote_file1> [remote_file2] ..."
        return 1
    fi
    for file in "$@"
    do
        scp -r cx330@kali:"$file" ./
        if [ $? -eq 0 ]
        then
            echo "File '$file' was successfully downloaded from cx330@kali"
        else
            echo "Error: Failed to download file '$file'."
        fi
    done
}
tofedora() {
    # Check if any file arguments were provided
    if [ "$#" -eq 0 ]; then
        echo "Usage: tofedora <file1> [file2] ..."
        return 1
    fi

    # Loop through all provided file arguments
    for file in "$@"; do
        # Check if the file exists
        if [ ! -e "$file" ]; then
            echo "Error: File '$file' does not exist."
            continue
        fi

        # Use scp to send the file to the remote server's home directory
        scp -r "$file" cx330@fedora:~/

        # Check if the scp command was successful
        if [ $? -eq 0 ]; then
            echo "File '$file' was successfully transferred to cx330@fedora"
        else
            echo "Error: Failed to transfer file '$file'."
        fi
    done
}
fromfedora () {
    if [ "$#" -eq 0 ]
    then
        echo "Usage: fromfedora <remote_file1> [remote_file2] ..."
        return 1
    fi
    for file in "$@"
    do
        scp -r cx330@fedora:"$file" ./
        if [ $? -eq 0 ]
        then
            echo "File '$file' was successfully downloaded from cx330@fedora"
        else
            echo "Error: Failed to download file '$file'."
        fi
    done
}


##### Flare-VM port forwarding!!! #####
# Notes:
# Set the port forwarding to PVE, 
# then remove the write permission for 
# Flare-VM RDP by using Windows App
#######################################
##!/bin/bash
#iptables -t nat -A PREROUTING -i tailscale0 -p tcp --dport 13389 -j DNAT --to-destination 192.168.77.10:3389
#iptables -A FORWARD -i tailscale0 -p tcp -d 192.168.77.10 --dport 3389 -j ACCEPT
#######################################

##### Pwn.college #####
alias pwnc='ssh -Y hacker@dojo.pwn.college'
alias pwnc-getchal='scp "hacker@dojo.pwn.college:/challenge/*" ./'

###### Generated for envman. Do not edit #####
[ -s "$HOME/.config/envman/load.sh" ] && source "$HOME/.config/envman/load.sh"

# Go environment
export PATH=$PATH:$HOME/.local/opt/go/bin
export PATH=$PATH:$HOME/go/bin

##### RISCV #####
export RISCV=/opt/riscv
export PATH=$PATH:$RISCV/bin
export PATH="$HOME/.cargo/bin:$PATH"

##### Python #####
alias python='python3'

##### Sudo #####
bindkey -s '\e\e' '\C-asudo \C-e'

##### Binary executables #####
export PATH="$PATH:~/.local/bin"

##### Editor env #####
export EDITOR=nvim

##### bun completions #####
[ -s "/home/cx330/.bun/_bun" ] && source "/home/cx330/.bun/_bun"

##### bun #####
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

##### Volatility #####
alias vol="python2 ~/Applications/volatility/vol.py"

##### Java #####
if [ -x /usr/libexec/java_home ]; then
  export JAVA_HOME=$(/usr/libexec/java_home)
  export PATH=$JAVA_HOME/bin:$PATH
fi

##### Path #####
export PATH="$PATH":/home/cx330/.local/bin

##### Tmux #####
hack() {
    if [ -n "$TMUX" ]; then
        tmux detach
    else
        tmux attach -t hack || tmux new -s hack
    fi
}
alias "hacke"="tmux kill-session -t hack"

##### FZF for fuzzy completion #####
source <(fzf --zsh)

##### Personal scripts and bin #####
export PATH="$HOME/bin:$PATH"

##### Binary ninja on Mac #####
alias binja='/Applications/Binary\ Ninja.app/Contents/MacOS/binaryninja'

##### Proxychains for Tor (default) #####
alias pc="proxychains -q"


##### Zig #####
alias zb="zig build"
alias zbr="zig build run"

##### Empty download folder at home #####
alias shit="rm -rf ~/Downloads/*"

##### eza, the modern ls #####
alias ls="eza --icons"

##### FlareOn Challenges #####
alias flare="cd ~/Working/Share/FlareOn/"

##### Mac borders #####
alias borderon="brew services start borders"
alias borderoff="brew services stop borders"

##### OpenMPI #####
export PATH=/usr/lib64/openmpi/bin:$PATH
export OMPI_MCA_pml=ob1
export OMPI_MCA_btl=self,tcp
export OMPI_MCA_mtl=^ofi

##### Bat #####
export BAT_THEME="ansi"

##### Onefetch #####
alias of=onefetch

##### Opencode #####
alias oc=opencode

# Added by Antigravity
export PATH="/Users/CX330/.antigravity/antigravity/bin:$PATH"

# Neovim
update_nvim_theme() {
  if defaults read -g AppleInterfaceStyle &>/dev/null; then
    export NVIM_THEME=dark
  else
    export NVIM_THEME=light
  fi
}

autoload -Uz add-zsh-hook
add-zsh-hook precmd update_nvim_theme   # 每次要顯示 prompt 前都更新一次
update_nvim_theme                       # 進 shell 先跑一次


##### Spotify Player #####
alias spotify=spotify_player

# pnpm
export PNPM_HOME="/home/cx330/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/cx330/anaconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/cx330/anaconda3/etc/profile.d/conda.sh" ]; then
        . "/home/cx330/anaconda3/etc/profile.d/conda.sh"
    else
        export PATH="/home/cx330/anaconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

##### Lazydocker #####
alias lzdocker="lazydocker"

##### Randstr #####
randstr() {
    local len="$1"
    if [[ -z "$len" || "$len" -le 0 ]]; then
        echo "Usage: randstr <length>" >&2
        return 1
    fi

    tr -dc 'a-zA-Z0-9' < /dev/urandom | head -c "$len"
    echo
}
