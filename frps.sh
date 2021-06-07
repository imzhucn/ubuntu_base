killall -9 frps
echo '' >~/.frp/log_frps.log
~/.frp/frps -c ~/.frp/frps.ini >/dev/null 2>&1 &
sleep 4
cat ~/.frp/log_frps.log
