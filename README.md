
<p align="center">
  <img src="https://raw.githubusercontent.com/Pi-Swarm/openclaw-android-sovereign/main/assets/logo.png" alt="OpenClaw Android" width="120">
</p>

<h1 align="center">📱 OpenClaw Android</h1>

<p align="center">
  <b>Full-Featured AI Agent System for Android</b>
</p>

<p align="center">
  <a href="#-installation"><b>Install</b></a> •
  <a href="#-quick-start"><b>Quick Start</b></a> •
  <a href="#-features"><b>Features</b></a> •
  <a href="#-documentation"><b>Docs</b></a>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Platform-Android-success?style=for-the-badge&logo=android&logoColor=white" alt="Android">
  <img src="https://img.shields.io/badge/Runtime-Termux-informational?style=for-the-badge&logo=linux&logoColor=white" alt="Termux">
  <img src="https://img.shields.io/badge/AI-Claude%20%C2%B7%20OpenAI%20%C2%B7%20Gemini%20%C2%B7%20Ollama-blueviolet?style=for-the-badge" alt="AI">
  <br>
  <a href="https://github.com/Pi-Swarm/openclaw-android-sovereign/actions/workflows/android_build.yml">
    <img src="https://github.com/Pi-Swarm/openclaw-android-sovereign/workflows/%F0%9F%93%B1%20Build%20OpenClaw%20Android%20Binaries/badge.svg" alt="Build Status">
  </a>
  <a href="https://github.com/Pi-Swarm/openclaw-android-sovereign/releases">
    <img src="https://img.shields.io/github/v/release/Pi-Swarm/openclaw-android-sovereign?style=flat-square" alt="Release">
  </a>
  <img src="https://img.shields.io/badge/License-MIT-success?style=flat-square" alt="License">
</p>

---

## 🌟 Overview

**OpenClaw Android** brings the complete OpenClaw AI agent platform to your pocket. Run Claude, OpenAI, Gemini, or local Ollama models directly on your Android device—no desktop required.

### What You Can Do

- 🤖 **AI Conversations** — Chat with Claude, GPT-4o, Gemini on your phone
- 🛡️ **Security Tools** — Run security audits and network scans anywhere
- 📁 **File Management** — Access Android storage, edit files, analyze documents
- 🔔 **Background Operations** — Run scheduled tasks with cron
- 🌐 **Web Integration** — Search the web, fetch pages, browse via agent
- ⚡ **HTTP Gateway** — Host OpenClaw API server on your device

---

## 📋 Table of Contents

- [📦 Installation](#-installation)
- [🚀 Quick Start](#-quick-start)
- [✨ Features](#-features)
- [⚙️ Configuration](#️-configuration)
- [🎮 Usage](#-usage)
- [🔧 Advanced](#-advanced)
- [🐛 Troubleshooting](#-troubleshooting)
- [📞 Support](#-support)

---

## 📦 Installation

### Requirements

| Requirement | Version | Notes |
|-------------|---------|-------|
| **Android** | 7.0+ | ARM64 or ARMv7 |
| **Termux** | 0.118+ | From F-Droid |
| **Storage** | 500MB+ | For OpenClaw + models |
| **RAM** | 2GB+ | 4GB recommended |

### ⚡ One-Line Installer

Copy and paste this command in Termux:

```bash
curl -fsSL https://raw.githubusercontent.com/Pi-Swarm/openclaw-android-sovereign/main/install-full.sh | bash
```

This will:
1. Install all dependencies
2. Install OpenClaw globally
3. Configure your workspace
4. Set up shell aliases

### 📲 Manual Installation

If you prefer manual control:

```bash
# 1. Install Termux from F-Droid (NOT Play Store)
#    https://f-droid.org/packages/com.termux/

# 2. Update packages
pkg update && pkg upgrade -y

# 3. Install Node.js
pkg install -y nodejs git curl python

# 4. Install OpenClaw
npm install -g openclaw

# 5. Setup storage access
termux-setup-storage
```

---

## 🚀 Quick Start

### 1. Configure API Keys (2 minutes)

```bash
# Run the setup wizard
oc-setup

# Or manually edit:
nano ~/.openclaw/.env
```

Example `.env`:
```bash
# Claude (Recommended)
ANTHROPIC_API_KEY="sk-ant-api03-YOUR-KEY-HERE"
export OPENCLAW_DEFAULT_PROVIDER="anthropic"

# Or OpenAI
OPENAI_API_KEY="sk-YOUR-KEY-HERE"
export OPENCLAW_DEFAULT_PROVIDER="openai"

# Load the config
source ~/.bashrc
```

### 2. Verify Installation

```bash
# Check status
openclaw status

# Test AI connection
openclaw agent -m "Hello from Android!"
```

### 3. Try Commands

```bash
# Switch providers quickly
oc-claude    # Use Claude
oc-openai    # Use OpenAI
oc-gemini    # Use Gemini
oc-local     # Use Ollama

# Security scan
openclaw agent -m "Scan 192.168.1.1"

# Analyze a file
openclaw agent -m "Read /sdcard/Download/report.pdf and summarize"
```

---

## ✨ Features

### 🤖 Multi-Provider AI

| Provider | Best For | Cost | Offline |
|----------|----------|------|---------|
| **Claude (Anthropic)** | Complex analysis, coding | $$$ | ❌ |
| **OpenAI (GPT-4o)** | General tasks, speed | $$ | ❌ |
| **Gemini** | Long documents (1M ctx) | $ | ❌ |
| **Ollama (Local)** | Privacy, offline use | Free | ✅ |

### 🛡️ Security Tools

- **Port Scanning** — `openclaw security scan <ip>`
- **Code Audit** — `openclaw security audit <file>`
- **Vulnerability Detection** — Automated CVE checks
- **Network Mapping** — Discover devices on your network

### 📱 Android Integration

- **Storage Access** — Read/write `/sdcard` files
- **Notifications** — Termux API integration
- **Shortcuts** — Home screen widgets
- **Background** — Daemon mode with wake lock

### ⚡ Gateway Server

```bash
# Start HTTP API server
openclaw gateway --port 18789

# Access endpoints:
# GET  http://localhost:18789/status
# POST http://localhost:18789/agent
# GET  http://localhost:18789/sessions
```

### 📅 Scheduled Tasks

```bash
# Daily security scan at 9 AM
openclaw cron add \
  --name "daily-security" \
  --schedule "0 9 * * *" \
  --command "agent -m 'Scan local network'"
```

---

## ⚙️ Configuration

### Configuration Files

| File | Purpose |
|------|---------|
| `~/.openclaw/config.json` | Main configuration |
| `~/.openclaw/.env` | API keys (recommended) |
| `~/.openclaw/workspace/` | Default workspace |

### Full Config Example

```json
{
  "version": "2.0.0",
  "providers": {
    "anthropic": {
      "apiKey": "${ANTHROPIC_API_KEY}",
      "model": "claude-3-5-sonnet-20241022",
      "enabled": true
    },
    "openai": {
      "apiKey": "${OPENAI_API_KEY}",
      "model": "gpt-4o",
      "enabled": true
    },
    "ollama": {
      "url": "http://localhost:11434",
      "model": "qwen2.5:1.5b",
      "enabled": true
    }
  },
  "defaultProvider": "anthropic",
  "channels": {
    "telegram": {
      "enabled": false,
      "token": ""
    }
  },
  "gateway": {
    "port": 18789,
    "host": "127.0.0.1"
  }
}
```

---

## 🎮 Usage

### Core Commands

```bash
# AI Chat
openclaw agent -m "your message here"

# With file attachment
openclaw agent -m "analyze this" --file /sdcard/Download/code.js

# With specific provider
openclaw agent -m "hello" --provider openai
```

### Session Management

```bash
# List all sessions
openclaw sessions list

# Create new session
openclaw sessions new my-project

# Send message to session
openclaw sessions send my-project "Hello"

# View history
openclaw sessions history my-project
```

### File Operations

```bash
# Read file
openclaw agent -m "Read /sdcard/Downloads/report.pdf"

# Edit file
openclaw agent -m "Update /sdcard/Documents/notes.txt with shopping list"

# Analyze code
openclaw agent -m "Find bugs in /sdcard/Projects/app.js"
```

### Web & Search

```bash
# Web search
openclaw agent -m "Search web for latest Android security patches"

# Fetch page
openclaw agent -m "Fetch https://example.com and summarize"
```

---

## 🔧 Advanced

### Background Operation

```bash
# Start gateway as daemon
openclaw gateway --daemon

# Check if running
pgrep -f "openclaw gateway"

# View logs
logcat -s "OpenClaw" &
```

### Auto-Start on Boot

```bash
# Requires Termux:Boot app
mkdir -p ~/.termux/boot
cat > ~/.termux/boot/openclaw-start << 'EOF'
#!/data/data/com.termux/files/usr/bin/bash
termux-wake-lock
source ~/.openclaw/.env
openclaw gateway --daemon
EOF
chmod +x ~/.termux/boot/openclaw-start
```

### Home Screen Shortcuts

```bash
# Create shortcuts
mkdir -p ~/.shortcuts
cat > ~/.shortcuts/oc-status << 'EOF'
#!/bin/bash
termux-toast "Checking status..."
openclaw status
EOF
chmod +x ~/.shortcuts/oc-status

# Now long-press Termux → Shortcuts → oc-status
```

### Telegram Bot

```bash
# Configure
export TELEGRAM_TOKEN="your-bot-token"

# Run
openclaw telegram --token $TELEGRAM_TOKEN

# Or enable in config
openclaw config set channels.telegram.enabled true
openclaw config set channels.telegram.token "$TELEGRAM_TOKEN"
```

---

## 🐛 Troubleshooting

### Common Issues

<details>
<summary><b>❌ "command not found: openclaw"</b></summary>

```bash
# Reload shell
source ~/.bashrc

# Or reinstall
npm install -g openclaw
```
</details>

<details>
<summary><b>❌ "Invalid API key"</b></summary>

```bash
# Check key is set
echo $ANTHROPIC_API_KEY

# Verify in config
openclaw config get providers.anthropic.apiKey

# Test connection
openclaw provider test anthropic
```
</details>

<details>
<summary><b>⚠️ Out of memory on 4GB device</b></summary>

```bash
# Use smaller model
openclaw config set defaultProvider ollama
openclaw config set ollama.model qwen2.5:0.5b

# Limit Node.js memory
export NODE_OPTIONS="--max-old-space-size=512"

# Close background apps
```
</details>

<details>
<summary><b>🔓 Storage permission denied</b></summary>

```bash
termux-setup-storage

# Or manually grant in Android Settings
```
</details>

### Debug Mode

```bash
# Run with debug output
openclaw --verbose agent -m "test"

# Check logs
cat ~/.openclaw/logs/app.log
```

---

## 📊 Performance

### Memory Usage by Provider

| Provider | RAM Usage | Speed |
|----------|-----------|-------|
| Ollama (1.5B) | ~500MB | ⭐⭐ |
| Claude API | ~100MB | ⭐⭐⭐⭐⭐ |
| OpenAI API | ~100MB | ⭐⭐⭐⭐⭐ |
| Gemini API | ~100MB | ⭐⭐⭐⭐ |

### Battery Optimization

```bash
# Run only when charging
if [ $(cat /sys/class/power_supply/battery/status) = "Charging" ]; then
    openclaw gateway --daemon
fi
```

---

## 📞 Support

| Resource | Link |
|----------|------|
| **Documentation** | [Full Docs](https://docs.openclaw.ai) |
| **Issues** | [GitHub Issues](https://github.com/Pi-Swarm/openclaw-android-sovereign/issues) |
| **Releases** | [Download](https://github.com/Pi-Swarm/openclaw-android-sovereign/releases) |
| **OpenClaw** | [Main Project](https://github.com/openclaw/openclaw) |

---

## 🙏 Credits

- [OpenClaw](https://github.com/openclaw/openclaw) — The original project
- [Termux](https://termux.com) — Android terminal emulator
- [Ollama](https://ollama.ai) — Local AI models
- [Pi-Swarm](https://github.com/Pi-Swarm) — Android port

---

<p align="center">
  <b>🛡️ Full OpenClaw. Full Power. In Your Pocket.</b>
</p>

<p align="center">
  Made with ❤️ by the Pi-Swarm team
</p>
