# 📱 OpenClaw Android - Quick Setup Guide

## ⚡ 5-Minute Setup

### Step 1: Install Termux (2 minutes)
1. Download **F-Droid** from https://f-droid.org
2. Open F-Droid and search for **"Termux"**
3. Install Termux (NOT from Play Store!)

### Step 2: Install OpenClaw (3 minutes)
```bash
# Copy and paste this entire command:
curl -fsSL https://raw.githubusercontent.com/Pi-Swarm/openclaw-android-sovereign/main/install.sh | bash
```

### Step 3: Verify
```bash
openclaw status
```

You should see "✅ OpenClaw: Installed"

---

## 🎮 First Command

```bash
# Talk to AI
openclaw agent -m "Hello from Android!"

# Check security
openclaw security scan 192.168.1.1
```

---

## 📁 Access Your Files

### Step 1: Grant Permission
```bash
termux-setup-storage
```

### Step 2: Navigate to Files
```bash
cd /sdcard/Download
ls
```

### Step 3: Audit a File
```bash
openclaw security audit /sdcard/Download/myapp.js
```

---

## 🤖 Install AI (Optional)

```bash
# Install Ollama
pkg install ollama

# Download model (takes 5-10 min)
ollama pull qwen2.5:1.5b

# Test
ollama run qwen2.5:1.5b "Hello"
```

---

## 🔔 Background Service

```bash
# Start gateway in background
openclaw gateway &

# Check if running
curl http://localhost:18789/status
```

---

## 📞 Issues?

- **"Command not found"** → Restart Termux, run `source ~/.bashrc`
- **"Permission denied"** → Run `termux-setup-storage`
- **"Out of memory"** → Close other apps, use smaller AI model

**Full Docs**: https://github.com/Pi-Swarm/openclaw-android-sovereign
