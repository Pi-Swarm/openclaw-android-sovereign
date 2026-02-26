package main

import (
	"fmt"
	"os"
	"os/exec"
	"strings"
)

// OpenClaw Android - Go Native Implementation
// This provides a lightweight native wrapper for OpenClaw on Android

func main() {
	if len(os.Args) < 2 {
		printUsage()
		os.Exit(0)
	}

	command := os.Args[1]

	switch command {
	case "install":
		install()
	case "status":
		status()
	case "run":
		runTermuxCommand(strings.Join(os.Args[2:], " "))
	case "bootstrap":
		bootstrap()
	default:
		fmt.Println("Unknown command:", command)
		printUsage()
	}
}

func printUsage() {
	fmt.Println("🛡️ OpenClaw Android - Native Go Core")
	fmt.Println("")
	fmt.Println("Usage: pi-android <command>")
	fmt.Println("")
	fmt.Println("Commands:")
	fmt.Println("  install    - Install OpenClaw in Termux")
	fmt.Println("  status     - Check OpenClaw status")
	fmt.Println("  run <cmd>  - Run OpenClaw command")
	fmt.Println("  bootstrap  - Create bootstrap package")
	fmt.Println("")
}

func install() {
	fmt.Println("📦 Installing OpenClaw Android...")
	
	// Check if running in Termux
	if _, err := os.Stat("/data/data/com.termux/files/usr"); os.IsNotExist(err) {
		fmt.Println("❌ Not running in Termux environment")
		fmt.Println("Please run this from Termux app")
		os.Exit(1)
	}

	// Run install script
	cmd := exec.Command("bash", "-c", "curl -fsSL https://raw.githubusercontent.com/Pi-Swarm/openclaw-android-sovereign/main/install.sh | bash")
	cmd.Stdout = os.Stdout
	cmd.Stderr = os.Stderr
	if err := cmd.Run(); err != nil {
		fmt.Println("❌ Installation failed:", err)
		os.Exit(1)
	}
}

func status() {
	fmt.Println("🛡️ OpenClaw Android Status")
	fmt.Println("==========================")
	
	// Check Termux
	if _, err := os.Stat("/data/data/com.termux/files/usr/bin/openclaw"); err == nil {
		fmt.Println("✅ OpenClaw: Installed")
	} else {
		fmt.Println("❌ OpenClaw: Not installed")
		fmt.Println("   Run: pi-android install")
	}
	
	// Check storage
	if _, err := os.Stat("/sdcard"); err == nil {
		fmt.Println("✅ Storage: Accessible")
	} else {
		fmt.Println("⚠️  Storage: Not accessible")
		fmt.Println("   Run: termux-setup-storage")
	}
	
	// Check Ollama
	if _, err := os.Stat("/data/data/com.termux/files/usr/bin/ollama"); err == nil {
		fmt.Println("✅ Ollama: Installed")
	} else {
		fmt.Println("⚠️  Ollama: Not installed (optional)")
	}
}

func runTermuxCommand(command string) {
	fmt.Println("🚀 Running:", command)
	
	cmd := exec.Command("/data/data/com.termux/files/usr/bin/openclaw", strings.Fields(command)...)
	cmd.Stdout = os.Stdout
	cmd.Stderr = os.Stderr
	cmd.Stdin = os.Stdin
	
	if err := cmd.Run(); err != nil {
		fmt.Println("❌ Command failed:", err)
		os.Exit(1)
	}
}

func bootstrap() {
	fmt.Println("📦 Creating bootstrap package...")
	fmt.Println("This will create a Termux bootstrap with OpenClaw pre-installed")
	// Implementation for creating bootstrap
}
