#!/data/data/com.termux/files/usr/bin/bash
# Termux Widget shortcuts

case "$1" in
    status)
        termux-toast "Checking OpenClaw..."
        openclaw status > /sdcard/openclaw_status.txt
        termux-share -t "OpenClaw Status" /sdcard/openclaw_status.txt
        ;;
    gateway)
        termux-wake-lock
        termux-toast "Starting Gateway..."
        openclaw gateway &
        termux-notification -t "OpenClaw" -c "Gateway running"
        ;;
    audit)
        termux-toast "Select file to audit"
        FILE=$(termux-dialog -t "Select File" -i "/sdcard/Download")
        openclaw security audit "$FILE" > /sdcard/audit_result.txt
        termux-share -t "Audit Result" /sdcard/audit_result.txt
        ;;
esac
