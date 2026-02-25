<p align="center">
  <img src="https://github.com/Pi-Swarm/Pi-Swarm/raw/main/logo.png" width="100" alt="Pi Swarm Logo">
</p>

<h1 align="center">📱 OPENCLAW ANDROID SOVEREIGN</h1>

<p align="center">
  <strong>High-Performance Security Intelligence in Your Pocket.</strong>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Architecture-ARM64%20%2F%20ARMv7-darkgreen?style=for-the-badge" alt="Arch">
  <img src="https://img.shields.io/badge/Environment-Termux%20Ready-blue?style=for-the-badge" alt="Termux">
  <img src="https://img.shields.io/badge/Security-No%20Root%20Required-orange?style=for-the-badge" alt="Security">
</p>

---

## 🏗️ System Architecture
```mermaid
[ Android Device ] <---> [ Sovereign Go Core ] <---> [ Pi-Swarm Intelligence ]
       ^                         |                          |
       |--- (Local Network) -----|                          |
       |--- (Wi-Fi Auditing) -------------------------------|
```

## 🚀 Deployment (Termux Fast-Track)

### 1. Zero-Install Execution
If you don't want to compile, simply download the latest binary from our [Releases/Actions](https://github.com/Pi-Swarm/openclaw-android-sovereign/actions).

### 2. Manual Build
```bash
# Standard Toolchain setup
pkg update && pkg install git golang -y
git clone https://github.com/Pi-Swarm/openclaw-android-sovereign.git
cd openclaw-android-sovereign && go build -o pi-mobile pi_mobile_core.go
./pi-mobile
```

---

## 💎 Features & Compatibility
| Feature | Android 10+ | Android 13+ | Description |
| :--- | :---: | :---: | :--- |
| **Port Auditing** | ✅ | ✅ | Deep scan of local device services. |
| **Network Discovery** | ✅ | ✅ | Passive reconnaissance of the LAN. |
| **Encrypted Pulse** | ✅ | ✅ | Secure link to the central swarm. |
| **Root Access** | ❌ | ❌ | **Not Required** - Fully sovereign. |

---

## 📡 Roadmap
- **Q2 2026:** Integration with Android Push Notifications.
- **Q3 2026:** Real-time Wi-Fi threat visualization.

---
*Securing the Frontier of Mobile AI Sovereignty.*
