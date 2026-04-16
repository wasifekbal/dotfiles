# ----------------------------------------
# ███████╗███████╗██╗  ██╗██████╗  ██████╗
# ╚══███╔╝██╔════╝██║  ██║██╔══██╗██╔════╝
#   ███╔╝ ███████╗███████║██████╔╝██║
#  ███╔╝  ╚════██║██╔══██║██╔══██╗██║
# ███████╗███████║██║  ██║██║  ██║╚██████╗
# ╚══════╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝
# ----------------------------------------

# PATH & ENVIRONMENT
export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$HOME/.local/bin:$HOME/bin:$PATH"
[ -d $HOME/.local/go/bin ] && export PATH="$HOME/.local/go/bin:$PATH"

# Define plugin directory
PLUGIN_DIR="$HOME/.zsh"
mkdir -p "$PLUGIN_DIR"

export XDG_CONFIG_HOME="$HOME/.config"
export LANG=en_US.UTF-8
export EDITOR=$([[ -n $SSH_CONNECTION ]] && echo "vim" || echo "nvim")
export VISUAL=$EDITOR

# PLUGIN MANAGEMENT (Manual & Lightweight)
#
# Function to fetch plugins if missing
get_plugin() {
    local repo=$1
    local name=$(basename $repo)
    local target_dir="$PLUGIN_DIR/$name"

    # 1. Clone if missing
    if [ ! -d "$target_dir" ]; then
        echo "Installing $name..."
        git clone --depth 1 "https://github.com/$repo.git" "$target_dir"
    fi

    # 2. Smart Sourcing Logic
    # Look for: name.plugin.zsh -> name.zsh -> name.sh -> any .plugin.zsh
    if [ -f "$target_dir/$name.plugin.zsh" ]; then
        source "$target_dir/$name.plugin.zsh"
    elif [ -f "$target_dir/$name.zsh" ]; then
        source "$target_dir/$name.zsh"
    elif [ -f "$target_dir/$name.sh" ]; then
        source "$target_dir/$name.sh"
    else
        # Fallback: search for any file ending in .plugin.zsh
        local fallback=$(find "$target_dir" -maxdepth 1 -name "*.plugin.zsh" | head -n 1)
        if [ -n "$fallback" ]; then
            source "$fallback"
        fi
    fi
}

get_plugin "zdharma-continuum/fast-syntax-highlighting"
get_plugin "zsh-users/zsh-autosuggestions"


# ZSH OPTIONS & COMPLETION
autoload -Uz compinit && compinit
setopt autocd # Change directory just by typing the path

zmodload zsh/complist
autoload -Uz compinit && compinit
_comp_options+=(globdots) # Include hidden files in completion

# Use arrow keys to navigate the menu
zstyle ':completion:*' menu select
# Colorize the completion menu to match 'ls'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

# History Settings
HISTFILE="$HOME/.zsh_history"
HISTSIZE=10000
SAVEHIST=10000

# History Options
setopt EXTENDED_HISTORY      # Write the history file in the ':start:elapsed;command' format.
setopt SHARE_HISTORY         # Share history between different instances of zsh
setopt APPEND_HISTORY        # Append to the history file, don't overwrite
setopt INC_APPEND_HISTORY    # Write to the history file immediately, not when the shell exits
setopt HIST_IGNORE_DUPS      # Do not write a duplicate event to the history list
setopt HIST_REDUCE_BLANKS    # Remove superfluous blanks from each command line
setopt HIST_IGNORE_SPACE

# KEYBINDS
bindkey '^ ' autosuggest-accept
bindkey '^P' up-line-or-search
bindkey '^N' down-line-or-search
bindkey -s '^f' "tmux-session-maker\n"

# ALIASES & EXTERNAL TOOLS
[ -f ~/.zsh_functions ] && source ~/.zsh_functions
[ -f ~/.zsh_aliases ] && source ~/.zsh_aliases
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
eval "$(zoxide init zsh)"
eval "$(starship init zsh)"

# LAZY-LOAD NVM (This only loads NVM when you actually type 'nvm', 'node', or 'npm')
export NVM_DIR="$HOME/.config/nvm"
nvm() {
    unset -f nvm node npm
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    nvm "$@"
}
node() { nvm; node "$@"; }
npm() { nvm; npm "$@"; }

# FINISH
ZSH_AUTOSUGGEST_COMPLETION_IGNORE="git *"
