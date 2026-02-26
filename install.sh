#!/data/data/com.termux/files/usr/bin/bash

# OpenClaw Android Installer
# One-line install: curl -fsSL https://raw.githubusercontent.com/Pi-Swarm/openclaw-android-sovereign/main/install.sh | bash

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}"
echo "╔══════════════════════════════════════════╗"
echo "║     🛡️ OpenClaw Android Installer       ║"
echo "║     Sovereign AI on Your Phone          ║"
echo "╚══════════════════════════════════════════╝"
echo -e "${NC}"

# Check if running in Termux
if [ -z "$TERMUX_VERSION" ] && [ -z "$TERMUX_API_VERSION" ]; then
    echo -e "${YELLOW}⚠️  Warning: Not running in Termux${NC}"
    echo "This installer is designed for Termux on Android."
    echo "Continue anyway? (y/n)"
    read -r response
    if [ "$response" != "y" ]; then
        exit 1
    fi
fi

# Update packages
echo -e "${BLUE}📦 Updating packages...${NC}"
apt-get update -y || true
apt-get upgrade -y || true

# Install required packages
echo -e "${BLUE}📦 Installing dependencies...${NC}"
pkg install -y nodejs git curl wget python build-essential || {
    echo -e "${RED}❌ Failed to install packages${NC}"
    exit 1
}

# Install OpenClaw
echo -e "${BLUE}🚀 Installing OpenClaw...${NC}"
npm install -g openclaw@latest || {
    echo -e "${RED}❌ Failed to install OpenClaw${NC}"
    exit 1
}

# Create workspace directory
echo -e "${BLUE}📁 Creating workspace...${NC}"
mkdir -p ~/OpenClaw/workspace
cd ~/OpenClaw/workspace

# Install Ollama (optional)
echo -e "${YELLOW}🤖 Install Ollama for local AI? (requires 2GB+) (y/n)${NC}"
read -r install_ollama
if [ "$install_ollama" = "y" ]; then
    echo -e "${BLUE}🤖 Installing Ollama...${NC}"
    curl -fsSL https://ollama.com/install.sh | sh || {
        echo -e "${YELLOW}⚠️ Ollama installation failed. You can install manually later.${NC}"
    }
    
    if command -v ollama &> /dev/null; then
        echo -e "${BLUE}📥 Pulling qwen2.5:1.5b model...${NC}"
        ollama pull qwen2.5:1.5b || echo -e "${YELLOW}⚠️ Model download failed${NC}"
    fi
fi

# Setup storage access
echo -e "${BLUE}🔓 Setting up storage access...${NC}"
termux-setup-storage || true

# Create config
echo -e "${BLUE}⚙️  Creating default config...${NC}"
mkdir -p ~/.openclaw
cat > ~/.openclaw/config.json << 'EOF'
{
  "version": "1.0.0",
  "workspace": "/data/data/com.termux/files/home/OpenClaw/workspace",
  "model": "qwen2.5:1.5b",
  "ollamaUrl": "http://localhost:11434",
  "channels": {
    "terminal": true,
    "telegram": false
  },
  "security": {
    "autoScan": false,
    "deepAnalysis": true
  }
}
EOF

# Create launcher script
echo -e "${BLUE}📝 Creating launcher...${NC}"
cat > $PREFIX/bin/pi << 'EOF'
#!/bin/bash
# Pi Swarm Android Launcher
openclaw "$@"
EOF
chmod +x $PREFIX/bin/pi

# Create shortcuts
echo -e "${BLUE}📱 Creating shortcuts...${NC}"
mkdir -p ~/.shortcuts
cat > ~/.shortcuts/openclaw-status << 'EOF'
#!/data/data/com.termux/files/usr/bin/bash
termux-toast "Checking OpenClaw..."
openclaw status
termux-dialog confirm -t "OpenClaw Status" -i "Check terminal for details"
EOF
chmod +x ~/.shortcuts/openclaw-status

cat > ~/.shortcuts/openclaw-gateway << 'EOF'
#!/data/data/com.termux/files/usr/bin/bash
termux-wake-lock
termux-toast "Starting OpenClaw Gateway..."
openclaw gateway &
sleep 2
termux-notification -t "OpenClaw" -c "Gateway running on port 18789"
EOF
chmod +x ~/.shortcuts/openclaw-gateway

# Add aliases to bashrc
echo -e "${BLUE}🔧 Adding shell aliases...${NC}"
if ! grep -q "# OpenClaw Aliases" ~/.bashrc; then
    cat >> ~/.bashrc << 'EOF'

# OpenClaw Aliases
alias oc='openclaw'
alias oc-status='openclaw status'
alias oc-agent='openclaw agent -m'
alias oc-gateway='openclaw gateway'
alias oc-audit='openclaw security audit'
alias oc-scan='openclaw security scan'

# Android specific
alias sdcard='cd /sdcard'
alias workspace='cd ~/OpenClaw/workspace'
EOF
fi

# Create uninstall script
cat > ~/OpenClaw/uninstall.sh << 'EOF'
#!/bin/bash
echo "Uninstalling OpenClaw Android..."
npm uninstall -g openclaw
rm -rf ~/OpenClaw
rm -f ~/.openclaw/config.json
rm -f $PREFIX/bin/pi
echo "Uninstall complete!"
EOF
chmod +x ~/OpenClaw/uninstall.sh

# Test installation
echo -e "${BLUE}🧪 Testing installation...${NC}"
if openclaw --version &> /dev/null; then
    VERSION=$(openclaw --version)
    echo -e "${GREEN}✅ OpenClaw installed: $VERSION${NC}"
else
    echo -e "${YELLOW}⚠️ Installation may need restart${NC}"
fi

# Final message
echo ""
echo -e "${GREEN}╔══════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║     ✅ Installation Complete!            ║${NC}"
echo -e "${GREEN}╚══════════════════════════════════════════╝${NC}"
echo ""
echo -e "${BLUE}🎮 Quick Start:${NC}"
echo "  openclaw status         - Check system status"
echo "  openclaw agent -m 'hi'   - Talk to AI"
echo "  pi --help               - Show all commands"
echo ""
echo -e "${BLUE}📱 Android Shortcuts:${NC}"
echo "  Long-press Termux → Shortcuts → openclaw-status"
echo "  Long-press Termux → Shortcuts → openclaw-gateway"
echo ""
echo -e "${BLUE}📂 Workspace:${NC} ~/OpenClaw/workspace"
echo -e "${BLUE}⚙️  Config:${NC} ~/.openclaw/config.json"
echo ""
echo -e "${YELLOW}📝 Note: Restart Termux or run 'source ~/.bashrc' to load aliases${NC}"
echo ""
echo -e "${GREEN}🛡️ Sovereign AI is ready in your pocket!${NC}"
