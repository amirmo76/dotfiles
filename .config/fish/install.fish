#!/usr/bin/env fish
# Bootstrap fish config from dotfiles.
# Run once on a fresh machine: fish install.fish

set -l cfg (dirname (status filename))

# ── Fisher ────────────────────────────────────────────────────────────────────
echo "==> Installing fisher plugins..."
if not functions -q fisher
    curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source
    fisher install jorgebucaran/fisher
end
fisher install < $cfg/fish_plugins

# ── Tide prompt (Tokyo Night) ─────────────────────────────────────────────────
echo "==> Configuring tide..."

# Layout / structure
set -U tide_left_prompt_items         os pwd git newline character
set -U tide_right_prompt_items        status cmd_duration context jobs direnv bun node python rustc java php pulumi ruby go gcloud kubectl distrobox toolbox terraform aws nix_shell crystal elixir zig time
set -U tide_left_prompt_frame_enabled  true
set -U tide_left_prompt_prefix         \ue0b6
set -U tide_left_prompt_suffix         \ue0b4
set -U tide_left_prompt_separator_same_color  \ue0b1
set -U tide_left_prompt_separator_diff_color  ''
set -U tide_right_prompt_frame_enabled false
set -U tide_right_prompt_prefix        \ue0b6
set -U tide_right_prompt_suffix        \ue0b4
set -U tide_right_prompt_separator_same_color \ue0b3
set -U tide_right_prompt_separator_diff_color ''
set -U tide_prompt_add_newline_before  true
set -U tide_prompt_color_frame_and_connection brblack
set -U tide_prompt_color_separator_same_color brblack
set -U tide_prompt_icon_connection     \u2500
set -U tide_prompt_min_cols            34
set -U tide_prompt_pad_items           true
set -U tide_prompt_transient_enabled   false

# OS item
set -U tide_os_bg_color  3b4261
set -U tide_os_color     c0caf5
set -U tide_os_icon      \uf303

# PWD item
set -U tide_pwd_bg_color            24283b
set -U tide_pwd_color_anchors       7dcfff
set -U tide_pwd_color_dirs          c0caf5
set -U tide_pwd_color_truncated_dirs 565f89
set -U tide_pwd_icon                \uf07c
set -U tide_pwd_icon_home           \uf015
set -U tide_pwd_icon_unwritable     \uf023
set -U tide_pwd_markers             .bzr .citc .git .hg .node-version .python-version .ruby-version .shorten_folder_marker .svn .terraform bun.lockb Cargo.toml composer.json CVS go.mod package.json build.zig

# Git item (Tokyo Night bg variants)
set -U tide_git_bg_color          1e2030
set -U tide_git_bg_color_unstable 2d2a1e
set -U tide_git_bg_color_urgent   2d1b1e
set -U tide_git_color_branch      7aa2f7
set -U tide_git_color_conflicted  f7768e
set -U tide_git_color_dirty       e0af68
set -U tide_git_color_operation   f7768e
set -U tide_git_color_staged      9ece6a
set -U tide_git_color_stash       bb9af7
set -U tide_git_color_untracked   7dcfff
set -U tide_git_color_upstream    565f89
set -U tide_git_icon              \uf1d3
set -U tide_git_truncation_length 24
set -U tide_git_truncation_strategy ''

# Character item
set -U tide_character_color          9ece6a
set -U tide_character_color_failure  f7768e
set -U tide_character_icon           \u276f
set -U tide_character_vi_icon_default \u276e
set -U tide_character_vi_icon_replace \u25b6
set -U tide_character_vi_icon_visual  V

# Status item
set -U tide_status_bg_color         black
set -U tide_status_bg_color_failure red
set -U tide_status_color            green
set -U tide_status_color_failure    bryellow
set -U tide_status_icon             \u2714
set -U tide_status_icon_failure     \u2718

# Cmd duration item
set -U tide_cmd_duration_bg_color  yellow
set -U tide_cmd_duration_color     black
set -U tide_cmd_duration_decimals  0
set -U tide_cmd_duration_icon      \uf252
set -U tide_cmd_duration_threshold 3000

# Time item
set -U tide_time_bg_color white
set -U tide_time_color    black
set -U tide_time_format   %T

# Node / runtimes
set -U tide_node_bg_color   green
set -U tide_node_color      black
set -U tide_node_icon       \ue24f

set -U tide_python_bg_color brblack
set -U tide_python_color    cyan
set -U tide_python_icon     \U000f0320

set -U tide_rustc_bg_color  red
set -U tide_rustc_color     black
set -U tide_rustc_icon      \ue7a8

set -U tide_go_bg_color brcyan
set -U tide_go_color    black
set -U tide_go_icon     \ue627

# Context / jobs
set -U tide_context_always_display  false
set -U tide_context_bg_color        brblack
set -U tide_context_color_default   yellow
set -U tide_context_color_root      yellow
set -U tide_context_color_ssh       yellow
set -U tide_context_hostname_parts  1

set -U tide_jobs_bg_color         brblack
set -U tide_jobs_color            green
set -U tide_jobs_icon             \uf013
set -U tide_jobs_number_threshold 1000

# Misc
set -U VIRTUAL_ENV_DISABLE_PROMPT true

echo "==> Done. Reload with: exec fish"
