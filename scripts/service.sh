#!/data/data/com.termux/files/usr/bin/bash
# OpenClaw Service Manager

PIDFILE="$HOME/.openclaw/gateway.pid"

start() {
    if [ -f "$PIDFILE" ] && kill -0 $(cat "$PIDFILE") 2>/dev/null; then
        echo "Gateway already running"
        return 1
    fi
    
    termux-wake-lock
    openclaw gateway &
    echo $! > "$PIDFILE"
    echo "Gateway started"
}

stop() {
    if [ -f "$PIDFILE" ]; then
        kill $(cat "$PIDFILE") 2>/dev/null
        rm -f "$PIDFILE"
        termux-wake-unlock
        echo "Gateway stopped"
    else
        echo "Gateway not running"
    fi
}

status() {
    if [ -f "$PIDFILE" ] && kill -0 $(cat "$PIDFILE") 2>/dev/null; then
        echo "Gateway: Running (PID: $(cat $PIDFILE))"
        curl -s http://localhost:18789/status | head -5
    else
        echo "Gateway: Stopped"
    fi
}

case "$1" in
    start) start ;;
    stop) stop ;;
    restart) stop; sleep 2; start ;;
    status) status ;;
    *) echo "Usage: $0 {start|stop|restart|status}" ;;
esac
