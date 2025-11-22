# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

if which rbenv > /dev/null; then
  eval "$(rbenv init -)"
fi


# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
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
plugins=(git zsh-autosuggestions fzf-tab)
source $ZSH/oh-my-zsh.sh
# fzf-tab: render in a popup and stay put
# zstyle ':fzf-tab:*' fzf-command ftb-tmux-popup   # uses a tmux popup when in tmux
# zstyle ':fzf-tab:*' popup-border rounded
# zstyle ':fzf-tab:*' switch-group '<' '>'         # jump groups with < and >


# --- fzf-tab (Zsh completion) ----------------------------------------------
# Use a tmux popup when inside tmux; otherwise a normal fzf window
# Use a tmux popup for completion (falls back to inline when not in tmux)
# zstyle ':fzf-tab:*' fzf-command ftb-tmux-popup
# zstyle ':fzf-tab:*' popup-border rounded
# zstyle ':fzf-tab:*' popup-pad 1 2
# zstyle ':fzf-tab:*' switch-group '<' '>'          # cycle completion groups
# zstyle ':fzf-tab:*' fzf-flags --height=70% --reverse --info=inline --border
# zstyle ':completion:*' menu yes select            # enable menu selection


# --- fzf-tab (no tmux popup; full-screen fzf) -----------------------------
zstyle ':fzf-tab:*' fzf-command fzf
zstyle ':fzf-tab:*' fzf-flags --height=100% --reverse --info=inline --border \
  --preview-window=right:60%:wrap
zstyle ':fzf-tab:*' popup-border rounded
zstyle ':fzf-tab:*' popup-pad 1 2
zstyle ':fzf-tab:*' switch-group '<' '>'
zstyle ':completion:*' menu yes select

# --------------------------------------------------------------------------
# Generic preview: dirs list, files show first 300 lines with bat, else fallback
_ft_preview() {
  local target="$1"
  if [ -d "$target" ]; then
    if command -v eza >/dev/null 2>&1; then eza -1 --group-directories-first --icons=always "$target"
    else ls -1 "$target"; fi
  else
    command -v bat >/dev/null 2>&1 \
      && bat --style=numbers --color=always --line-range :300 "$target" \
      || head -300 "$target" 2>/dev/null
  fi
}

# Files/dirs everywhere
zstyle ':fzf-tab:complete:*:*' fzf-preview '_ft_preview {}'

# cd: preview target dir contents
zstyle ':fzf-tab:complete:cd:*' fzf-preview '_ft_preview {}'

# kill: preview process details
zstyle ':fzf-tab:complete:kill:*' fzf-preview 'ps -o pid,ppid,uid,%cpu,%mem,etime,command -p {1}'

# git checkout/switch: show recent commits for the branch
zstyle ':fzf-tab:complete:git-(checkout|switch):*' \
  fzf-preview 'git log --oneline --decorate --graph -n 30 --color=always {1}'

# git checkout file: show diff for the file being checked out
zstyle ':fzf-tab:complete:git-checkout:*' \
  fzf-preview 'git diff --color=always -- {1} | sed -n "1,400p"'

# SSH/SCP: show host keys if known
zstyle ':fzf-tab:complete:(ssh|scp):*' \
  fzf-preview 'grep -m1 "^{1}[ ,]" ~/.ssh/known_hosts 2>/dev/null || echo "no host key cached"'

# Optional: nicer group headers
zstyle ':fzf-tab:*' group-colors 'fg=blue'

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
#source ~/powerlevel10k/powerlevel10k.zsh-theme

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

export PATH="$HOME/.pyenv/bin:$PATH"
eval "$(pyenv init --path)"
#eval "$(pyenv virtualenv-init -)"
export PATH="/opt/homebrew/bin:$PATH"

# allows me to hit a key, pick a repo, and open a tmux sesh there
# Where to look
SESH_ROOTS=( "$HOME/projects" )
SESH_DEPTH=4   # how deep to search under each root
# Create or attach to a tmux session for a dir, with editor/dev/tests windows
tm() {
  local dir="${1:-$PWD}"
  local name="${2:-$(basename "$dir" | tr ' .:/\\' '-')}"
  if tmux has-session -t "$name" 2>/dev/null; then
    tmux switch-client -t "$name" 2>/dev/null || tmux attach -t "$name"
    return
  fi
  TMUX='' tmux new-session -ds "$name" -c "$dir" -n editor
  tmux new-window  -t "$name:2" -n dev   -c "$dir"
  tmux split-window -v         -t "$name:2" -c "$dir"
  tmux new-window  -t "$name:3" -n tests -c "$dir"
  tmux select-window -t "$name:2"
  tmux attach -t "$name"
}

# fzf picker: find repos, pick one, call tm()
sesh() {
  local cands
  cands=$(
    find "${SESH_ROOTS[@]}" -maxdepth 5 -type f \
      \( -name package.json -o -name '*.sln' -o -name '*.csproj' \) \
      -exec dirname {} \; 2>/dev/null | sort -u
  ) || return
  local choice
  choice=$(printf '%s\n' "$cands" | fzf --prompt='repo> ' --height=40% --reverse \
    --exit-0 --select-1 \
    --preview 'git -C {} status -sb 2>/dev/null || ls -1 {} | head -100' \
    --preview-window=right:60%) || return
  tm "$choice"
}

# cdf: fuzzy cd to a directory under your SESH_ROOTS (depth 5)
cdf() {
  local choice
  choice=$(
    command -v fd >/dev/null 2>&1 \
      && fd -t d . "${SESH_ROOTS[@]}" -d ${SESH_DEPTH:-5} 2>/dev/null \
      || find "${SESH_ROOTS[@]}" -maxdepth ${SESH_DEPTH:-5} -type d 2>/dev/null
  ) || return
  choice=$(printf '%s\n' "$choice" | fzf --prompt='cd> ' --height=40% --reverse \
    --preview '_ft_preview {}' --preview-window=right:60%) || return
  builtin cd "$choice"
}
# optional hotkey: Ctrl-g to invoke cdf
bindkey -s '^G' 'cdf\n'

export ANDROID_HOME=~/Library/Android/sdk
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/platform-tools
export PATH="$HOME/.local/share/nvim/mason/bin:$PATH"
export JAVA_HOME=/Library/Java/JavaVirtualMachines/temurin-21.jdk/Contents/Home
export PATH=$PATH:$ANDROID_HOME/cmdline-tools/10.0/bin
#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
export PATH="./node_modules/.bin:$PATH"

[[ "$TERM_PROGRAM" == "kiro" ]] && . "$(kiro --locate-shell-integration-path zsh)"
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#8cb6ff'

# Only in interactive TTYs: free Ctrl-S and disable XON/XOFF quietly
if [[ $- == *i* ]] && [[ -t 0 ]]; then
  bindkey -r '^S'
  stty -ixon 2>/dev/null
fi

# Accept zsh-autosuggestion with Ctrl-Space
bindkey '^ ' autosuggest-accept

eval "$(zoxide init zsh)"
