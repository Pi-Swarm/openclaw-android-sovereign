# 📱 OpenClaw Android - Full Edition

**Complete OpenClaw Port for Android with Full API Support**

Run the FULL OpenClaw experience on Android - with support for Claude, OpenAI, Gemini, and local Ollama models.

---

## 🎯 What's Included

| Feature | Status | Description |
|---------|--------|-------------|
| **All API Providers** | ✅ | OpenAI, Claude, Gemini, Grok, Mistral |
| **Local Ollama** | ✅ | Run AI locally on device |
| **OpenClaw Core** | ✅ | 100% feature parity with desktop |
| **All Skils** | ✅ | Security, web, git, file tools |
| **Sessions** | ✅ | Full session management |
| **Gateway** | ✅ | HTTP API server on Android |
| **Channels** | ✅ | Telegram, Discord, Matrix |
| **Cron Jobs** | ✅ | Scheduled tasks on phone |

---

## 📦 Installation

### One-Line Installer

```bash
curl -fsSL https://raw.githubusercontent.com/Pi-Swarm/openclaw-android-sovereign/main/install-full.sh | bash
```

### Manual Installation

```bash
# 1. Install Termux from F-Droid

# 2. Update packages
pkg update && pkg upgrade -y

# 3. Install Node.js 20+
pkg install -y nodejs git curl

# 4. Install OpenClaw FULL
npm install -g openclaw

# 5. Verify
openclaw --version
```

---

## 🔑 API Configuration

### Option 1: Edit Config File

```bash
nano ~/.openclaw/config.json
```

Add your API keys:

```json
{
  "providers": {
    "openai": {
      "apiKey": "sk-your-key-here",
      "model": "gpt-4o"
    },
    "anthropic": {
      "apiKey": "sk-ant-your-key-here",
      "model": "claude-3-5-sonnet-20241022"
    },
    "google": {
      "apiKey": "your-gemini-key",
      "model": "gemini-1.5-pro"
    },
    "ollama": {
      "url": "http://localhost:11434",
      "model": "qwen2.5:1.5b"
    }
  },
  "defaultProvider": "anthropic",
  "channels": {
    "telegram": {
      "enabled": false,
      "token": "your-bot-token"
    }
  }
}
```

### Option 2: Environment Variables

Add to `~/.bashrc`:

```bash
# API Keys
export OPENAI_API_KEY="sk-your-key"
export ANTHROPIC_API_KEY="sk-ant-your-key"
export GEMINI_API_KEY="your-gemini-key"

# Default provider
export OPENCLAW_DEFAULT_PROVIDER="anthropic"
```

Then:
```bash
source ~/.bashrc
```

---

## 🎮 Usage Examples

### With Claude (Recommended)

```bash
# Set Claude as default
openclaw config set defaultProvider anthropic

# Chat with Claude
openclaw agent -m "Explain blockchain"

# Security audit
openclaw agent -m "Audit this code" --file ./contract.sol
```

### With OpenAI

```bash
# Quick question
openclaw agent -m "What is DeFi?" --provider openai

# Code review
openclaw agent --provider openai -m "Review this Rust code" --file ./main.rs
```

### With Gemini

```bash
# Long context (Gemini has 1M token context)
openclaw agent --provider google -m "Analyze this entire repo" --file ./src/
```

### Local Only (Ollama)

```bash
# No internet needed
openclaw agent -m "Hello" --provider ollama

# Must have ollama installed
ollama serve
```

---

## 🔧 Full Feature Usage

### Sessions (Like Desktop)

```bash
# List sessions
openclaw sessions list

# Create new session
openclaw sessions new security-audit

# Send message to session
openclaw sessions send security-audit "Audit this repo"

# View session history
openclaw sessions history security-audit
```

### Gateway Server

```bash
# Start gateway
openclaw gateway --port 18789

# Now access via HTTP:
curl http://localhost:18789/status
curl -X POST http://localhost:18789/agent -d '{"message": "Hello"}'
```

### Skills/Tools

```bash
# All tools work on Android:
openclaw agent -m "Read /sdcard/Download/file.txt"
openclaw agent -m "Scan 192.168.1.1"
openclaw agent -m "Clone github.com/user/repo"
openclaw agent -m "Search web for Rust tutorials"
```

### Cron Jobs (NEW on Android!)

```bash
# Daily security scan
openclaw cron add --name "daily-scan" --schedule "0 9 * * *" \
  --command "agent -m 'Scan 192.168.1.1'"

# List jobs
openclaw cron list
```

---

## 📱 Android-Specific Features

### Storage Access

```bash
# Allow storage
termux-setup-storage

# Access Downloads
openclaw agent -m "Read /sdcard/Download/report.pdf"

# Analyze photos
openclaw agent -m "Analyze this image" --file /sdcard/DCIM/Camera/photo.jpg
```

### Background Operation

```bash
# Run gateway in background
openclaw gateway --daemon

# Auto-start on boot (with Termux:Boot)
mkdir -p ~/.termux/boot
cat > ~/.termux/boot/openclaw << 'EOF'
#!/data/data/com.termux/files/usr/bin/bash
termux-wake-lock
openclaw gateway --daemon
EOF
chmod +x ~/.termux/boot/openclaw
```

### Quick Actions (Home Screen)

```bash
# Create Termux shortcut
echo 'openclaw agent -m "Quick status check"' > ~/.shortcuts/status
echo 'openclaw gateway' > ~/.shortcuts/gateway
```

---

## 🔐 Security

### API Key Security

Keys are stored in:
- `~/.openclaw/config.json` (chmod 600)
- Or environment variables (more secure)

### Recommended: Use .env

```bash
# Create .env file
cat > ~/.openclaw/.env << 'EOF'
OPENAI_API_KEY=sk-...
ANTHROPIC_API_KEY=sk-ant-...
EOF

# Secure it
chmod 600 ~/.openclaw/.env

# Source in .bashrc
echo 'source ~/.openclaw/.env' >> ~/.bashrc
```

---

## 🌐 Provider Comparison on Android

| Provider | Speed | Cost | Works Offline | Best For |
|----------|-------|------|---------------|----------|
| **Claude** | ⭐⭐⭐ | $$$ | ❌ | Complex analysis, coding |
| **OpenAI** | ⭐⭐⭐ | $$ | ❌ | General tasks, fast |
| **Gemini** | ⭐⭐ | $ | ❌ | Long documents, vision |
| **Ollama** | ⭐ | Free | ✅ | Privacy, offline |

### Model Recommendations

- **Fast tasks**: GPT-4o-mini, Claude Haiku
- **Code**: Claude Sonnet, GPT-4o
- **Long docs**: Gemini 1.5 Pro (1M context)
- **Offline**: qwen2.5:1.5b, llama3.2:1b

---

## 🐛 Troubleshooting

### "Invalid API Key"
```bash
# Check key is set
echo $ANTHROPIC_API_KEY

# Test connection
openclaw provider test anthropic
```

### "Out of memory"
```bash
# Use smaller model
openclaw config set defaultProvider ollama
openclaw config set ollama.model qwen2.5:0.5b

# Close other apps
```

### "Network error"
```bash
# Test connection
curl https://api.anthropic.com/v1/health

# Check proxy settings
export HTTP_PROXY=...
```

---

## 📞 Support

**Issues**: https://github.com/Pi-Swarm/openclaw-android-sovereign/issues

---

**🛡️ Full OpenClaw. Full Power. In Your Pocket.**
