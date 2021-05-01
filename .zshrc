export LANG=ja_JP.UTF-8
export EDITOR=vim
export LESS='--tabs=4 --no-init --LONG-PROMPT --ignore-case'

bindkey -e
bindkey "^[u" undo
bindkey "^[r" redo
bindkey "^[[Z" reverse-menu-complete

HISTFILE=~/.zsh_history
HISTSIZE=1000000
SAVEHIST=1000000
setopt share_history
setopt hist_ignore_all_dups
setopt hist_reduce_blanks
setopt extended_history

autoload -Uz compinit && compinit
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
zstyle ':completion:*' ignore-parents parent pwd ..

autoload smart-insert-last-word
zle -N insert-last-word smart-insert-last-word

autoload -Uz select-word-style
select-word-style default
zstyle ':zle:*' word-chars " /=;@:{},|"
zstyle ':zle:*' word-style unspecified

setopt auto_list
setopt auto_menu
setopt auto_pushd
setopt pushd_ignore_dups
setopt list_types
setopt list_packed
setopt print_eight_bit
setopt interactive_comments
setopt no_flow_control
setopt no_beep

case ${OSTYPE} in
  darwin*)
    alias ls='ls -GF'
    ;;
  linux*)
    alias ls='ls -F --color=auto'
    ;;
esac
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias mkdir='mkdir -p'
alias la='ls -aF'
alias ll='ls -laF'
alias grep='grep --color=auto'
alias qd='cd $(ghq list --full-path | fzf)'

# asdf
source ~/.asdf/asdf.sh

# zplug
source ~/.zplug/init.zsh
zplug "zsh-users/zsh-syntax-highlighting", defer:2
case ${OSTYPE} in
  darwin*)
    zplug "BurntSushi/ripgrep", from:gh-r, as:command, rename-to:rg, use:"*darwin*"
    zplug "stedolan/jq", from:gh-r, as:command, use:"*osx*"
    zplug "x-motemen/ghq", from:gh-r, as:command, use:"*darwin_amd64*"
    zplug "junegunn/fzf", on:"junegunn/fzf-bin"
    zplug "junegunn/fzf-bin", \
      from:gh-r, \
      as:command, \
      use:"*darwin_amd64*", \
      rename-to:fzf, \
      hook-load:"""
        source $ZPLUG_REPOS/junegunn/fzf/shell/key-bindings.zsh
        source $ZPLUG_REPOS/junegunn/fzf/shell/completion.zsh
      """
      export FZF_DEFAULT_COMMAND="rg --files --hidden --follow --glob '!.git'"
    ;;
  linux*)
    if [[ "$(uname -m)" == aarch64 ]]; then
      zplug "sharkdp/fd", from:gh-r, as:command, use:"*arm*musleabihf*"
      zplug "junegunn/fzf", on:"junegunn/fzf-bin"
      zplug "junegunn/fzf-bin", \
        from:gh-r, \
        as:command, \
        use:"*linux_arm7*", \
        rename-to:fzf, \
        hook-load:"""
          source $ZPLUG_REPOS/junegunn/fzf/shell/key-bindings.zsh
          source $ZPLUG_REPOS/junegunn/fzf/shell/completion.zsh
        """
      export FZF_DEFAULT_COMMAND="fd --type f --hidden --follow --exclude '.git'"
    elif [[ "$(uname -m)" == x86_64 ]]; then
      zplug "BurntSushi/ripgrep", from:gh-r, as:command, rename-to:rg
      zplug "stedolan/jq", from:gh-r, as:command, use:"*linux64*"
      zplug "x-motemen/ghq", from:gh-r, as:command, use:"*linux_amd64*"
      zplug "junegunn/fzf", on:"junegunn/fzf-bin"
      zplug "junegunn/fzf-bin", \
        from:gh-r, \
        as:command, \
        use:"*linux_amd64*", \
        rename-to:fzf, \
        hook-load:"""
          source $ZPLUG_REPOS/junegunn/fzf/shell/key-bindings.zsh
          source $ZPLUG_REPOS/junegunn/fzf/shell/completion.zsh
        """
      export FZF_DEFAULT_COMMAND="rg --files --hidden --follow --glob '!.git'"
    fi
    ;;
esac

if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi
zplug load

# fzf
export FZF_DEFAULT_OPTS='--height 40% --reverse --border'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_CTRL_T_OPTS="--preview 'head -100 {}'"

# prompt
TERM=xterm-256color
[ -f ~/.zsh_prompt ] && source ${HOME}/.zsh_prompt
