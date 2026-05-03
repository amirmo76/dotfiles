function proxy -d "Manage system-wide proxy settings"
    set -l usage "Usage: proxy [on|off|set <ip> <port> [user] [pass]|status]"

    if test (count $argv) -eq 0
        # Toggle: if proxy is active, turn off; otherwise turn on (or set up)
        if set -q __proxy_active; and test "$__proxy_active" = 1
            _proxy_off
        else
            _proxy_on
        end
        return
    end

    switch $argv[1]
        case on
            _proxy_on
        case off
            _proxy_off
        case set
            if test (count $argv) -lt 3
                echo $usage
                return 1
            end
            set -l ip $argv[2]
            set -l port $argv[3]
            set -l user ""
            set -l pass ""
            if test (count $argv) -ge 5
                set user $argv[4]
                set pass $argv[5]
            else if test (count $argv) -ge 4
                set user $argv[4]
                read -s -P "Password: " pass
                echo
            end

            set -U __proxy_host $ip
            set -U __proxy_port $port
            if test -n "$user" -a -n "$pass"
                set -U __proxy_url "http://$user:$pass@$ip:$port"
                set -U __proxy_auth_user $user
                set -U __proxy_auth_pass $pass
            else
                set -U __proxy_url "http://$ip:$port"
                set -Ue __proxy_auth_user 2>/dev/null; true
                set -Ue __proxy_auth_pass 2>/dev/null; true
            end
            _proxy_on
        case status
            _proxy_status
        case test
            _proxy_test
        case '*'
            echo $usage
            return 1
    end
end

function _proxy_on
    if not set -q __proxy_url; or test -z "$__proxy_url"
        echo "No proxy configured. Set one first:"
        echo "  proxy set <ip> <port> [user] [pass]"
        read -P "Or enter proxy (ip port): " -a parts
        if test (count $parts) -lt 2
            echo "Aborted."
            return 1
        end
        proxy set $parts
        return
    end

    set -l no_proxy "localhost,::1,10.0.0.0/8,172.16.0.0/12,192.168.0.0/16"

    set -Ux http_proxy "$__proxy_url"
    set -Ux https_proxy "$__proxy_url"
    set -Ux ftp_proxy "$__proxy_url"
    set -Ux all_proxy "$__proxy_url"
    set -Ux HTTP_PROXY "$__proxy_url"
    set -Ux HTTPS_PROXY "$__proxy_url"
    set -Ux FTP_PROXY "$__proxy_url"
    set -Ux ALL_PROXY "$__proxy_url"
    set -Ux no_proxy "$no_proxy"
    set -Ux NO_PROXY "$no_proxy"

    set -U __proxy_active 1

    git config --global http.proxy "$__proxy_url"
    git config --global https.proxy "$__proxy_url"

    _proxy_ssh_on

    echo "Proxy ON: $__proxy_url"
    echo "No proxy: $no_proxy"
end

function _proxy_off
    set -Ue http_proxy
    set -Ue https_proxy
    set -Ue ftp_proxy
    set -Ue all_proxy
    set -Ue HTTP_PROXY
    set -Ue HTTPS_PROXY
    set -Ue FTP_PROXY
    set -Ue ALL_PROXY
    set -Ue no_proxy
    set -Ue NO_PROXY

    set -U __proxy_active 0

    git config --global --unset http.proxy 2>/dev/null; true
    git config --global --unset https.proxy 2>/dev/null; true

    _proxy_ssh_off

    echo "Proxy OFF"
end

function _proxy_ssh_on
    mkdir -p ~/.ssh
    chmod 700 ~/.ssh

    # Determine proxy address (host:port)
    set -l proxy_addr
    if set -q __proxy_host; and set -q __proxy_port
        set proxy_addr "$__proxy_host:$__proxy_port"
    else
        # Fallback: parse from __proxy_url (http://[user:pass@]host:port)
        set -l after_scheme (string replace -r '^https?://' '' "$__proxy_url")
        set proxy_addr (string replace -r '^[^@]+@' '' "$after_scheme")
    end

    # Build ProxyCommand
    set -l proxy_cmd "ncat --proxy $proxy_addr --proxy-type http %h %p"
    if set -q __proxy_auth_user; and test -n "$__proxy_auth_user"
        set proxy_cmd "ncat --proxy $proxy_addr --proxy-type http --proxy-auth $__proxy_auth_user:$__proxy_auth_pass %h %p"
    end

    printf 'Host *\n  ProxyCommand %s\n' "$proxy_cmd" > ~/.ssh/proxy_config
    chmod 600 ~/.ssh/proxy_config

    # Ensure ~/.ssh/config includes proxy_config (prepend if missing)
    if not test -f ~/.ssh/config
        printf 'Include ~/.ssh/proxy_config\n' > ~/.ssh/config
        chmod 600 ~/.ssh/config
    else if not grep -qF 'Include ~/.ssh/proxy_config' ~/.ssh/config
        set -l tmp (mktemp)
        printf 'Include ~/.ssh/proxy_config\n\n' > $tmp
        cat ~/.ssh/config >> $tmp
        mv $tmp ~/.ssh/config
        chmod 600 ~/.ssh/config
    end
end

function _proxy_ssh_off
    if test -f ~/.ssh/proxy_config
        printf '# SSH proxy disabled\n' > ~/.ssh/proxy_config
    end
end

function _proxy_test
    if not set -q __proxy_active; or test "$__proxy_active" != 1
        echo "Proxy is not active. Run 'proxy on' first."
        return 1
    end
    echo "Testing proxy: $__proxy_url"
    echo ""
    echo -n "AUR RPC:    "
    curl -s -o /dev/null -w "%{http_code} (via %{local_ip} -> proxy)" \
        --proxy "$__proxy_url" --max-time 10 \
        "https://aur.archlinux.org/rpc/v5/info?arg=yay"
    echo ""
    echo -n "Arch Linux: "
    curl -s -o /dev/null -w "%{http_code}" \
        --proxy "$__proxy_url" --max-time 10 \
        "https://archlinux.org"
    echo ""
    echo ""
    echo -n "Outbound IP through proxy: "
    curl -s --proxy "$__proxy_url" --max-time 10 "https://api.ipify.org"
    echo ""
    echo ""
    echo -n "SSH to github.com:22 via proxy: "
    if timeout 6 ncat --proxy "$__proxy_host:$__proxy_port" --proxy-type http github.com 22 2>/dev/null | head -1 | grep -q SSH
        echo "OK"
    else
        echo "FAILED"
    end
end

function _proxy_status
    if set -q __proxy_active; and test "$__proxy_active" = 1
        echo "Proxy: ON"
        echo "URL: $__proxy_url"
        echo "http_proxy=$http_proxy"
        echo "no_proxy=$no_proxy"
        echo "SSH ProxyCommand: ncat --proxy $__proxy_host:$__proxy_port --proxy-type http %h %p"
    else
        echo "Proxy: OFF"
        if set -q __proxy_url
            echo "Last proxy: $__proxy_url"
        else
            echo "No proxy configured"
        end
    end
end
