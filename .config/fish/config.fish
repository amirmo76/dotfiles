if status is-interactive
    # Commands to run in interactive sessions can go here
    set -g fish_greeting
    set -gx EDITOR nvim
    set fzf_fd_opts --hidden --max-depth 7

    fish_add_path $HOME/.cargo/bin
    fish_add_path $HOME/.local/bin

    alias v="nvim"
    alias quteconfig="nvim ~/.config/qutebrowser/config.py"

    bind \cy accept-autosuggestion
    bind \ce forward-word

    zoxide init fish | source

    # Tokyo Night colors for fzf
    set -gx FZF_DEFAULT_OPTS "\
  --color=bg+:#1a1b26,bg:#1a1b26,spinner:#7dcfff,hl:#f7768e \
  --color=fg:#c0caf5,header:#f7768e,info:#7aa2f7,pointer:#7dcfff \
  --color=marker:#9ece6a,fg+:#c0caf5,prompt:#7aa2f7,hl+:#f7768e"

    # enable vi mode persistently
    set -g fish_key_bindings fish_vi_key_bindings
    function fish_user_key_bindings
        bind -M insert \cy accept-autosuggestion
        bind -M insert \ce forward-word
        bind -M insert \cf _fzf_search_directory
    end
end

# opencode
fish_add_path /home/amir/.opencode/bin
