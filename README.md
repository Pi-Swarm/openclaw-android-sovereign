# 📱 OpenClaw Android - Sovereign Edition

**Complete OpenClaw Port for Android Devices**

Run the full OpenClaw agent system on your Android phone/tablet via Termux.

---

## 🎯 What You Get

| Feature | Status | Description |
|---------|--------|-------------|
| **Full OpenClaw** | ✅ | Complete Node.js runtime + OpenClaw |
| **Ollama Support** | ✅ | Local AI on Android (via Termux) |
| **Security Tools** | ✅ | Audit, scan, analyze on mobile |
| **Telegram Bot** | ✅ | Control from Telegram |
| **Git Integration** | ✅ | Clone, commit, push repos |
| **File Manager** | ✅ | Access `/sdcard` files |

---

## 📦 Installation Methods

### Method 1: One-Line Installer (Recommended)

```bash
# In Termux app
curl -fsSL https://raw.githubusercontent.com/Pi-Swarm/openclaw-android-sovereign/main/install.sh | bash
```

### Method 2: Manual Installation

#### Step 1: Install Termux
1. Download **F-Droid** app (not Play Store)
2. Install **Termux** from F-Droid
3. Open Termux

#### Step 2: Install Dependencies
```bash
# Update packages
pkg update && pkg upgrade -y

# Install Node.js
pkg install -y nodejs git curl wget

# Install Python (for some tools)
pkg install -y python

# Install build tools
pkg install -y build-essential
```

#### Step 3: Install OpenClaw
```bash
# Install OpenClaw globally
npm install -g openclaw

# Verify installation
openclaw --version
```

#### Step 4: Install Ollama (Optional - for AI)
```bash
# Install Ollama
pkg install -y ollama

# Pull lightweight model
ollama pull qwen2.5:1.5b

# Test
ollama run qwen2.5:1.5b "Hello"
```

---

## 🎮 Usage on Android

### Basic Commands

```bash
# Check OpenClaw status
openclaw status

# Run agent
openclaw agent -m "Analyze this code"

# Security audit
openclaw security audit /sdcard/Download/myapp.js

# Network scan
openclaw security scan 192.168.1.1

# Start gateway
openclaw gateway

# Git operations
openclaw git clone https://github.com/user/repo
```

### Access Android Storage
```bash
# Grant storage permission first
termux-setup-storage

# Now you can access:
# /sdcard/Download   - Downloads
# /sdcard/Documents  - Documents
# /sdcard/Pictures   - Pictures

# Audit a file
openclaw security audit /sdcard/Download/app.js
```

### Background Service
```bash
# Run OpenClaw in background
openclaw gateway &

# Check if running
curl http://localhost:18789/status

# Stop
pkill -f "openclaw"
```

---

## 🔧 Configuration

### Create Config File
```bash
mkdir -p ~/.openclaw
cat > ~/.openclaw/config.json << 'EOF'
{
  "model": "qwen2.5:1.5b",
  "ollamaUrl": "http://localhost:11434",
  "workspace": "/sdcard/OpenClaw",
  "channels": {
    "telegram": {
      "enabled": false,
      "token": ""
    }
  }
}
EOF
```

### Environment Variables
Add to `~/.bashrc`:
```bash
# OpenClaw settings
export OPENCLAW_MODEL="qwen2.5:1.5b"
export OPENCLAW_WORKSPACE="/sdcard/OpenClaw"
export PATH="$PATH:$HOME/.openclaw/bin"

# Aliases for easy use
alias oc='openclaw'
alias oc-status='openclaw status'
alias oc-agent='openclaw agent'
alias oc-audit='openclaw security audit'
```

---

## 🤖 Advanced: Telegram Control

### Setup Telegram Bot
```bash
# 1. Get token from @BotFather
# 2. Set it
export TELEGRAM_TOKEN="your_bot_token"

# 3. Start Telegram gateway
openclaw telegram --token $TELEGRAM_TOKEN
```

### Telegram Commands
Once running, message your bot:
- `/status` - System status
- `/agent <msg>` - Talk to AI
- `/audit <file>` - Audit file
- `/scan <ip>` - Network scan

---

## 🛠️ Performance Tips

### Optimize for Low RAM (4GB devices)
```bash
# Use smaller AI model
ollama pull qwen2.5:0.5b

# Limit Node.js memory
export NODE_OPTIONS="--max-old-space-size=1024"

# Close unused apps
```

### Battery Optimization
```bash
# Run only when charging
while true; do
  if [ "$(cat /sys/class/power_supply/battery/status)" = "Charging" ]; then
    openclaw gateway
  fi
  sleep 60
done
```

---

## 📱 APK Wrapper (Optional)

For a native app experience, we provide an APK wrapper:

### Download APK
```bash
# Download latest APK
wget https://github.com/Pi-Swarm/openclaw-android-sovereign/releases/download/v1.0/openclaw-android.apk

# Install (enable "Unknown Sources")
termux-open openclaw-android.apk
```

### Features of APK
- 🎨 Material Design UI
- 🔧 Settings GUI
- 📊 Status dashboard
- 🔔 Notifications for scan completion
- 📁 File picker integration

---

## 🔄 Auto-Start on Boot

### Method 1: Termux:Boot
```bash
# Install Termux:Boot from F-Droid
# Create startup script:
mkdir -p ~/.termux/boot
cat > ~/.termux/boot/openclaw-start << 'EOF'
#!/data/data/com.termux/files/usr/bin/bash
# Start OpenClaw on boot
termux-wake-lock
sshd
openclaw gateway
EOF
chmod +x ~/.termux/boot/openclaw-start
```

### Method 2: Tasker Integration
```bash
# Use Tasker app to auto-start Termux
# Profile: Device Boot
# Action: Run Shell: am startservice -n com.termux/com.termux.app.TermuxService
```

---

## 🐛 Troubleshooting

### Issue: Command not found
```bash
# Re-install
npm install -g openclaw

# Check PATH
echo $PATH
which openclaw
```

### Issue: Permission denied
```bash
# Grant storage permission
termux-setup-storage

# Fix permissions
chmod +x $(which openclaw)
```

### Issue: Out of memory
```bash
# Clear cache
pkg clean

# Use smaller model
ollama pull tinyllama
```

### Issue: Slow AI responses
```bash
# Check if using CPU (expected on Android)
htop

# Switch to lighter model
openclaw config set model qwen2.5:0.5b
```

---

## 🚀 Development

### Build from Source
```bash
# Clone OpenClaw
git clone https://github.com/openclaw/openclaw.git
cd openclaw

# Install dependencies
npm install

# Build
npm run build

# Link globally
npm link
```

### Modify for Android
```bash
# Edit source
nano src/config.ts

# Rebuild
npm run build
```

---

## 📊 Comparison

| Feature | Desktop | Android Termux | APK Wrapper |
|---------|---------|----------------|-------------|
| Full OpenClaw | ✅ | ✅ | ✅ |
| File Access | ✅ | ✅ (via /sdcard) | ✅ (native) |
| Background | ✅ | ✅ | ✅ |
| Notifications | ❌ | ✅ (Termux API) | ✅ (native) |
| Battery | ✅ | ⚠️ drains | ✅ optimized |
| RAM Usage | 500MB-2GB | 300MB-1GB | 300MB-1GB |

---

## 🎓 Learning Resources

- [OpenClaw Docs](https://docs.openclaw.ai)
- [Termux Wiki](https://wiki.termux.com)
- [Ollama on Android](https://github.com/ollama/ollama/blob/main/docs/android.md)

---

## 📞 Support

- **Issues**: https://github.com/Pi-Swarm/openclaw-android-sovereign/issues
- **Telegram**: @PiSwarmSupport
- **Matrix**: #pi-swarm:matrix.org

---

**🛡️ Sovereign AI in Your Pocket**
