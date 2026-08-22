function herdr-layout --description "Create a herdr workspace in the current dir with my standard 4-pane layout"
    set -l dir (pwd)
    set -l label (basename $dir)
    set -l apps false

    for arg in $argv
        switch $arg
            case --apps
                set apps true
            case -h --help
                echo "usage: herdr-layout [--apps]"
                echo "  --apps  also launch claude, nvim and rmpc in the panes"
                return 0
            case '*'
                echo "herdr-layout: unknown option $arg" >&2
                return 1
        end
    end

    # Layout, left to right:
    #   p1 24% | p2 60% of the rest | p3 over p4 (60/40) in the remainder
    set -l ws (herdr workspace create --cwd $dir --label $label --focus \
        | string match -rg '"workspace_id":"([^"]+)"')
    or return 1
    set -l p1 (herdr pane list --workspace $ws | string match -rg '"pane_id":"([^"]+)"')

    set -l p2 (herdr pane split $p1 --direction right --ratio 0.244 --cwd $dir --no-focus \
        | string match -rg '"pane_id":"([^"]+)"')
    set -l p3 (herdr pane split $p2 --direction right --ratio 0.6 --cwd $dir --no-focus \
        | string match -rg '"pane_id":"([^"]+)"')
    set -l p4 (herdr pane split $p3 --direction down --ratio 0.6 --cwd $dir --no-focus \
        | string match -rg '"pane_id":"([^"]+)"')

    # Second tab, single pane, at $HOME like the original
    herdr tab create --workspace $ws --cwd $HOME --label media --no-focus >/dev/null

    if test $apps = true
        herdr agent send-keys $p1 claude Enter >/dev/null
        herdr agent send-keys $p2 v Space . Enter >/dev/null
    end

    herdr pane focus --pane $p1 >/dev/null 2>&1

    # Attach only when run from outside herdr; inside, the workspace is already focused
    if not set -q HERDR_ENV
        herdr
    end
end
