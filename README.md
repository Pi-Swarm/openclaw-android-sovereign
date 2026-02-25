# 📱 OpenClaw Android Sovereign (Pi-Mobile)

**The first autonomous security swarm core designed for Android devices.** 🛡️

This project brings the power of OpenClaw and the Pi Swarm to mobile devices, enabling high-performance security auditing directly from your phone via **Termux**.

---

## 🚀 How to Deploy on Android

### Step 1: Install Termux
Download Termux from F-Droid or the official website.

### Step 2: Setup & Installation
Run these commands inside your Termux terminal:
```bash
# Update system
pkg update && pkg upgrade

# Install Go & Git
pkg install git golang

# Clone the Sovereign Core
git clone https://github.com/Pi-Swarm/openclaw-android-sovereign.git
cd openclaw-android-sovereign

# Build and Execute
go build -o pi-mobile pi_mobile_core.go
./pi-mobile
```

### Step 3: Run Pre-built Binaries (No Installation)
1. Go to [Actions Tab](https://github.com/Pi-Swarm/openclaw-android-sovereign/actions).
2. Download the artifact for **ARM64** or **ARMv7**.
3. Move to Termux and run: `chmod +x [filename] && ./[filename]`

---

## 🏗️ Architecture
- **Language:** Golang (Optimized for ARM architecture).
- **Security:** Local-first, privacy-focused reconnaissance.

---
*Securing the Frontier of Mobile AI Sovereignty.*
