#!/data/data/com.termux/files/usr/bin/bash

# OpenClaw Android - FULL Edition Installer
# Supports: OpenAI, Claude, Gemini, Ollama, and all OpenClaw features

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

echo -e "${CYAN}"
echo "╔══════════════════════════════════════════════════╗"
echo "║       🛡️ OpenClaw Android - FULL Edition        ║"
echo "║                                                  ║"
echo "║   Claude • OpenAI • Gemini • Ollama • All APIs   ║"
echo "╚══════════════════════════════════════════════════╝"
echo -e "${NC}"

# Check Termux
if [ ! -d "/data/data/com.termux/files/usr" ]; then
    echo -e "${RED}❌ Error: Must run in Termux${NC}"
    exit 1
fi

# Update system
echo -e "${BLUE}📦 Updating Termux packages...${NC}"
apt-get update -y
apt-get upgrade -y

# Install all dependencies
echo -e "${BLUE}📦 Installing dependencies...${NC}"
pkg install -y \
    nodejs \
    git \
    curl \
    wget \
    python \
    build-essential \
    libffi \
    openssl \
    libxml2 \
    libxslt \
    2>&1 || true

# Install Node.js 20+ if needed
NODE_VERSION=$(node --version 2>/dev/null | cut -d'v' -f2 | cut -d'.' -f1)
if [ -z "$NODE_VERSION" ] || [ "$NODE_VERSION" -lt "20" ]; then
    echo -e "${YELLOW}⚠️  Installing Node.js 20+...${NC}"
    pkg install -y nodejs-20 || pkg install -y nodejs-lts
fi

echo -e "${GREEN}✅ Node.js: $(node --version)${NC}"

# Install OpenClaw FULL
echo -e "${BLUE}🚀 Installing OpenClaw FULL...${NC}"
npm install -g openclaw@latest 2>&1 || {
    echo -e "${YELLOW}⚠️  Trying alternative install...${NC}"
    npm install -g openclaw
}

if ! command -v openclaw >/dev/null 2>&1; then
    echo -e "${RED}❌ OpenClaw installation failed${NC}"
    exit 1
fi

echo -e "${GREEN}✅ OpenClaw: $(openclaw --version 2>&1 || echo 'Installed')${NC}"

# Create config directory
echo -e "${BLUE}⚙️  Setting up configuration...${NC}"
mkdir -p ~/.openclaw/workspace

# Create full config with ALL providers
cat > ~/.openclaw/config.json <> 'CONFIGEOF'
{
  "version": "2.0.0",
  "workspace": "/data/data/com.termux/files/home/.openclaw/workspace",
  "agent": {
    "verbosity": "normal",
    "streamResponses": true
  },
  "providers": {
    "anthropic": {
      "apiKey": "${ANTHROPIC_API_KEY:-}",
      "model": "claude-3-5-sonnet-20241022",
      "baseURL": "https://api.anthropic.com",
      "enabled": false
    },
    "openai": {
      "apiKey": "${OPENAI_API_KEY:-}",
      "model": "gpt-4o",
      "baseURL": "https://api.openai.com",
      "enabled": false
    },
    "google": {
      "apiKey": "${GEMINI_API_KEY:-}",
      "model": "gemini-1.5-pro",
      "enabled": false
    },
    "ollama": {
      "url": "http://localhost:11434",
      "model": "qwen2.5:1.5b",
      "enabled": true
    }
  },
  "defaultProvider": "ollama",
  "channels": {
    "terminal": {
      "enabled": true
    },
    "telegram": {
      "enabled": false,
      "token": ""
    },
    "discord": {
      "enabled": false,
      "token": ""
    }
  },
  "gateway": {
    "port": 18789,
    "host": "127.0.0.1"
  },
  "tools": {
    "allowList": ["*"],
    "denyList": []
  },
  "security": {
    "auditMode": "strict",
    "autoPatch": false
  }
}
CONFIGEOF

# Secure config
chmod 600 ~/.openclaw/config.json

# Create .env template for API keys
cat > ~/.openclaw/.env.example <> 'ENVEOF'
# OpenClaw Android - API Keys
# Copy this to .env and add your keys

# Claude (Anthropic) - Recommended
# Get key: https://console.anthropic.com/
ANTHROPIC_API_KEY=sk-ant-api03-...

# OpenAI
# Get key: https://platform.openai.com/
OPENAI_API_KEY=sk-...

# Google Gemini
# Get key: https://aistudio.google.com/
GEMINI_API_KEY=...

# Default provider (anthropic, openai, google, ollama)
OPENCLAW_DEFAULT_PROVIDER=ollama
ENVEOF

# Setup storage
echo -e "${BLUE}🔓 Setting up Android storage access...${NC}"
termux-setup-storage || true

# Create enhanced launcher
cat > $PREFIX/bin/pi-claw <> 'LAUNCHEREOF'
#!/data/data/com.termux/files/usr/bin/bash
# OpenClaw Android Launcher - Full Edition

# Source env if exists
[ -f ~/.openclaw/.env ] && source ~/.openclaw/.env

# Run openclaw with all args
openclaw "$@"
LAUNCHEREOF
chmod +x $PREFIX/bin/pi-claw

# Add aliases to bashrc
if ! grep -q "# OpenClaw Full" ~/.bashrc; then
    cat >> ~/.bashrc <> 'ALIASEOF'

# OpenClaw Full - Android
alias oc='openclaw'
alias oc-status='openclaw status'
alias oc-agent='openclaw agent -m'
alias oc-sessions='openclaw sessions list'
alias oc-gateway='openclaw gateway'
alias oc-config='nano ~/.openclaw/config.json'
alias oc-keys='nano ~/.openclaw/.env'
alias oc-test='openclaw provider test'

# Quick provider switch
alias oc-claude='openclaw config set defaultProvider anthropic'
alias oc-openai='openclaw config set defaultProvider openai'
alias oc-gemini='openclaw config set defaultProvider google'
alias oc-local='openclaw config set defaultProvider ollama'

# Android specific
alias sdcard='cd /sdcard'
alias downloads='cd /sdcard/Download'
alias oc-workspace='cd ~/.openclaw/workspace'
ALIASEOF
fi

# Install optional: Ollama
echo -e "${YELLOW}🤖 Install Ollama for local AI? (2GB+ needed) (y/n)${NC}"
read -r install_ollama
if [ "$install_ollama" = "y" ]; then
    echo -e "${BLUE}🤖 Installing Ollama...${NC}"
    
    # Ollama for Termux
    pkg install -y ollama 2>&1 || {
        # Manual install if pkg fails
        echo -e "${YELLOW}⚠️  Installing Ollama manually...${NC}"
        curl -fsSL https://ollama.com/install.sh | sh 2>&1 || {
            echo -e "${YELLOW}⚠️  Ollama install skipped. Install later with: pkg install ollama${NC}"
        }
    }
    
    if command -v ollama >/dev/null 2>&1; then
        echo -e "${BLUE}📥 Downloading qwen2.5:1.5b...${NC}"
        ollama pull qwen2.5:1.5b &
        echo -e "${YELLOW}⏳ Model downloading in background${NC}"
    fi
fi

# Create quick setup wizard
cat > $PREFIX/bin/oc-setup <> 'SETUP_EOF'
#!/data/data/com.termux/files/usr/bin/bash
echo "🛡️ OpenClaw Android - API Setup"
echo "================================"
echo ""
echo "1. Claude (Anthropic) - Recommended"
echo "   Get API key: https://console.anthropic.com/"
echo ""
echo "2. OpenAI"
echo "   Get API key: https://platform.openai.com/"
echo ""
echo "3. Google Gemini"
echo "   Get API key: https://aistudio.google.com/"
echo ""
echo "4. Ollama (Local - Free)"
echo "   Already configured if installed"
echo ""
read -p "Enter provider (1-4): " choice

case $choice in
    1)
        read -sp "Enter Claude API key: " key
        echo "export ANTHROPIC_API_KEY=$key" >> ~/.openclaw/.env
        echo "export OPENCLAW_DEFAULT_PROVIDER=anthropic" >> ~/.openclaw/.env
        echo -e "${GREEN}✅ Claude configured!${NC}"
        ;;
    2)
        read -sp "Enter OpenAI API key: " key
        echo "export OPENAI_API_KEY=$key" >> ~/.openclaw/.env
        echo "export OPENCLAW_DEFAULT_PROVIDER=openai" >> ~/.openclaw/.env
        echo -e "${GREEN}✅ OpenAI configured!${NC}"
        ;;
    3)
        read -sp "Enter Gemini API key: " key
        echo "export GEMINI_API_KEY=$key" >> ~/.openclaw/.env
        echo "export OPENCLAW_DEFAULT_PROVIDER=google" >> ~/.openclaw/.env
        echo -e "${GREEN}✅ Gemini configured!${NC}"
        ;;
    4)
        echo "export OPENCLAW_DEFAULT_PROVIDER=ollama" >> ~/.openclaw/.env
        echo -e "${GREEN}✅ Ollama configured!${NC}"
        ;;
esac

chmod 600 ~/.openclaw/.env
source ~/.openclaw/.env
SETUP_EOF
chmod +x $PREFIX/bin/oc-setup

# Create Termux shortcuts
mkdir -p ~/.shortcuts
cat > ~/.shortcuts/oc-status <> 'SHORTEOF'
#!/data/data/com.termux/files/usr/bin/bash
termux-toast "OpenClaw Status"
source ~/.openclaw/.env 2>/dev/null
openclaw status > /sdcard/openclaw_status.txt
termux-notification -t "OpenClaw Status" -c "Tap to view" --action "termux-open /sdcard/openclaw_status.txt"
SHORTEOF
chmod +x ~/.shortcuts/oc-status

# Test installation
echo ""
echo -e "${BLUE}🧪 Testing installation...${NC}"
if openclaw --help >/dev/null 2>&1; then
    echo -e "${GREEN}✅ OpenClaw is working!${NC}"
else
    echo -e "${YELLOW}⚠️  Installation may need restart${NC}"
fi

echo ""
echo -e "${GREEN}╔══════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║        ✅ INSTALLATION COMPLETE!                 ║${NC}"
echo -e "${GREEN}╚══════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${CYAN}🎮 Quick Start:${NC}"
echo ""
echo "1. Setup API keys:   oc-setup"
echo "   OR edit:          nano ~/.openclaw/.env"
echo ""
echo "2. Test Claude:       oc-claude && oc-agent 'Hello'"
echo "   Test OpenAI:       oc-openai && oc-agent 'Hello'"
echo "   Test Local:        oc-local && oc-agent 'Hello'"
echo ""
echo "3. View status:       oc-status"
echo "   List sessions:     oc-sessions"
echo "   Start gateway:     oc-gateway"
echo ""
echo -e "${CYAN}📁 Locations:${NC}"
echo "   Config:  ~/.openclaw/config.json"
echo "   Keys:    ~/.openclaw/.env"
echo "   Workspace: ~/.openclaw/workspace"
echo ""
echo -e "${YELLOW}💡 Tip: Run 'source ~/.bashrc' or restart Termux to load aliases${NC}"
echo ""

# Prompt for setup
read -p "Run API setup now? (y/n): " setup_now
if [ "$setup_now" = "y" ]; then
    oc-setup
fi

echo ""
echo -e "${GREEN}🛡️ OpenClaw Full Edition is ready!${NC}"
