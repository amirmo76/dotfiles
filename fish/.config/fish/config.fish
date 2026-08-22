if status is-interactive
    # Commands to run in interactive sessions can go here
    set -g fish_greeting
    set -gx EDITOR nvim
    set fzf_fd_opts --hidden --max-depth 7

    fish_add_path $HOME/.cargo/bin
    fish_add_path $HOME/.local/bin

    # Android SDK/NDK — only on machines that have it
    if test -d $HOME/Android/Sdk
        set -gx ANDROID_SDK_ROOT $HOME/Android/Sdk
        set -gx ANDROID_NDK $ANDROID_SDK_ROOT/ndk/30.0.14904198
        fish_add_path $ANDROID_NDK/toolchains/llvm/prebuilt/linux-x86_64/bin
    end

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

    # enable farsi — X11 only, no-op elsewhere (macOS, tty, Wayland-only)
    if type -q setxkbmap; and set -q DISPLAY
        setxkbmap -layout us,ir -option 'grp:alt_shift_toggle'
    end

    # enable vi mode persistently
    set -g fish_key_bindings fish_vi_key_bindings
    function fish_user_key_bindings
        bind -M insert \cy accept-autosuggestion
        bind -M insert \ce forward-word
        bind -M insert \cf _fzf_search_directory
    end
end

# opencode
fish_add_path $HOME/.opencode/bin

# pnpm
if test -d $HOME/.local/share/pnpm
    set -gx PNPM_HOME $HOME/.local/share/pnpm
    if not string match -q -- $PNPM_HOME $PATH
        set -gx PATH "$PNPM_HOME" $PATH
    end
end
