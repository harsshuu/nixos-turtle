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

# Set name of the theme to load.
# You can replace "robbyrussell" with "powerlevel10k/powerlevel10k" if using Powerlevel10k.
ZSH_THEME="powerlevel10k/powerlevel10k"

# Uncomment the following line to enable command auto-correction.
ENABLE_CORRECTION="true"

# Plugins to load (Oh My Zsh standard plugins can be found in $ZSH/plugins/).
plugins=(git zsh-syntax-highlighting zsh-autosuggestions)

# Source Oh My Zsh.
source $ZSH/oh-my-zsh.sh

# --- User Configuration ---

# History configuration.
HISTFILE=~/.histfile
HISTSIZE=50000
SAVEHIST=50000
setopt autocd beep extendedglob nomatch notify
bindkey -v

# Aliases
alias update='sudo nixos-rebuild switch'
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias edit='nvim'
alias cls='clear'
alias grep='grep --color=auto'
alias firefox='firefox'
alias brave='brave'
alias feh='feh --auto-zoom'
alias flameshot='flameshot gui'
alias zathura='zathura'
alias mpv='mpv'
alias redshift='redshift -O 4500K'
alias py='python3'
alias pip='python3 -m pip'
alias gcc='gcc'
alias make='make'
alias gitlog='git log --oneline --graph --decorate --all'
alias nlight='redshift -O 1300'

# Git aliases.
alias ginit='git init'
alias gclone='git clone'
alias gstatus='git status'
alias gadd='git add .'
alias gcommit='git commit -m'
alias gpush='git push'
alias gpull='git pull'
alias gbranch='git branch'
alias gmerge='git merge'
alias grebase='git rebase'
alias gdiff='git diff'
alias glog='git log --oneline --graph --decorate --all'

# --- Completion Configuration ---
zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _complete _ignored _approximate
zstyle ':completion:*' expand prefix suffix
zstyle ':completion:*' file-sort size
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' ignore-parents parent pwd
zstyle ':completion:*' insert-unambiguous true
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt '%SAt %p: Hit TAB for more, or the character to insert%s'
zstyle ':completion:*' list-suffixes true
zstyle ':completion:*' matcher-list 'm:{[:lower:]}={[:upper:]}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' menu select=0
zstyle ':completion:*' original false
zstyle ':completion:*' preserve-prefix '//[^/]##/'
zstyle ':completion:*' select-prompt '%SScrolling active: current selection at %p%s'
zstyle ':completion:*' squeeze-slashes true
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose true
zstyle :compinstall filename '/home/turtle/.zshrc'

# --- Plugins ---
source /home/turtle/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /home/turtle/.oh-my-zsh/custom/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

# --- Prompt Settings ---
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# --- Custom Functions ---
git_cleanup() {
  git branch --merged | grep -v '\*' | xargs -n 1 git branch -d
  echo "Deleted merged branches."
}

disk_usage() {
  du -h --max-depth=1 "$1" | sort -h
}

# --- Environment Variables ---
export EDITOR=nvim
export PATH="$PATH:/home/turtle/.local/bin"
export NIXPKGS_ALLOW_UNFREE=1 

# --- Recycle Bin Feature ---
# Directory for storing "deleted" files
export RECYCLE_BIN="$HOME/.recycle_bin"

# Ensure the recycle bin exists
[ ! -d "$RECYCLE_BIN" ] && mkdir -p "$RECYCLE_BIN"

# Function to move files to the recycle bin
trash() {
  for file in "$@"; do
    if [ -e "$file" ]; then
      mv -v "$file" "$RECYCLE_BIN/"
      echo "$file moved to recycle bin."
    else
      echo "File $file not found."
    fi
  done
}

# Function to list files in the recycle bin
list_bin() {
  ls -lh "$RECYCLE_BIN"
}

# Function to empty the recycle bin
empty_bin() {
  rm -rf "$RECYCLE_BIN"/*
  echo "Recycle bin emptied."
}

# Aliases to use the recycle bin
alias del='trash'
alias rmbin='empty_bin'
alias lsbin='list_bin'

# --- Enhanced `bat` Alias ---
# Use `bat` with syntax highlighting, line numbers, and pager
alias cat='bat --paging=always --style=numbers,grid --theme="TwoDark"'

# --- MPV Enhancements ---

# Alias for basic MPV playback
alias mpv='mpv --hwdec=auto --no-border --force-window=immediate'

# Function to play all media files in the current directory as a playlist
mpv_playlist() {
  mpv --hwdec=auto --no-border --force-window=immediate --playlist <(find . -type f \( -iname "*.mp4" -o -iname "*.mkv" -o -iname "*.webm" -o -iname "*.mp3" \) | sort)
}

# Function to stream YouTube videos directly with MPV
mpv_youtube() {
  if [ -z "$1" ]; then
    echo "Usage: mpv_youtube <YouTube-URL>"
  else
    mpv --ytdl-format="bestvideo[height<=1080]+bestaudio/best" "$1"
  fi
}

# Function to resume playback from the last stopped position (requires the `--save-position-on-quit` option)
mpv_resume() {
  mpv --save-position-on-quit --hwdec=auto --no-border "$1"
}

# Function to create a quick playlist from a directory and shuffle
mpv_shuffle() {
  mpv --hwdec=auto --no-border --force-window=immediate --shuffle --playlist <(find "$1" -type f \( -iname "*.mp4" -o -iname "*.mkv" -o -iname "*.webm" -o -iname "*.mp3" \))
}

# Aliases for specific use cases
alias mpv-loop='mpv --loop=inf'           # Loop playback infinitely
alias mpv-stream='mpv --cache=yes'        # For streaming URLs with caching
alias mpv-audio='mpv --no-video'          # Play audio-only files
alias mpv-fast='mpv --speed=1.5'          # Speed up playback (e.g., lectures)

# Preload subtitles (assumes subtitles are in the same directory as the video)
mpv_with_subs() {
  video="$1"
  subs=$(dirname "$video")/*.srt
  mpv --sub-file="$subs" "$video"
}

# --- Bottom Enhancements ---
alias btm='btm --battery'             # Launch bottom with battery widget
alias btm-cpu='btm --default-widget-type=graph --basic' # Focus on CPU and memory graphs
alias btm-disk='btm --basic --default-time-range=60'    # Disk I/O view

# --- Enhanced Eza Aliases ---
alias ls='eza --icons --group-directories-first'      # Default listing with icons
alias ll='eza -l --icons --group-directories-first'   # Detailed listing
alias la='eza -la --icons --group-directories-first'  # Include hidden files
alias lt='eza -lT --icons --group-directories-first'  # Display with tree structure
alias lsd='eza -d --icons'                            # Only list directories
alias lsh='eza --long --header --icons'               # Long list with headers
alias lst='eza --long --icons --tree'                 # Tree view

# --- YouTube CLI Shortcuts ---
# Play videos with thumbnail preview
alias ytplay="ytfzf -n 50 -t | xargs -r mpv" # Includes default results inline

# Download videos with thumbnail preview
alias ytdl="ytfzf -t | xargs -r yt-dlp -o '/home/turtle/dl/%(title)s.%(ext)s'"

# Download a video from URL with subtitles, metadata, and thumbnail
alias ytdlurl='yt-dlp --add-metadata --embed-subs --embed-thumbnail -o "/home/turtle/dl/%(title)s.%(ext)s"'

# Download a audio as mp3 
alias ytaudiourl='yt-dlp --extract-audio --audio-format mp3 -o "/home/turtle/dl/%(title)s.%(ext)s"'

# Download limit video resolution 
alias ytdl1080='yt-dlp -f "bestvideo[height<=1080]+bestaudio/best" --merge-output-format mkv -o "/home/turtle/dl/%(title)s.%(ext)s"'

# Download simple video 
alias ytdl='yt-dlp -o "/home/turtle/dl/%(title)s.%(ext)s"'

# Search YouTube and download audio
alias ytaudio="ytfzf -t | xargs -r yt-dlp --extract-audio --audio-format mp3 -o '/home/turtle/dl/%(title)s.%(ext)s'"

# Quickly edit ytfzf and yt-dlp configurations
alias ytfzfconfig="nano ~/.config/ytfzf/conf.sh"
alias ytdlpconfig="nano ~/.config/yt-dlp/config"

# Unified fuzzy menu for commands
ytcli() {
  local opt=$(echo -e "Play Video\nDownload Video\nDownload Audio" | fzf --prompt="Select Action: ")
  case "$opt" in
    "Play Video") ytplay ;;
    "Download Video") ytdl ;;
    "Download Audio") ytaudio ;;
    *) echo "Cancelled or Invalid Option" ;;
  esac
}

