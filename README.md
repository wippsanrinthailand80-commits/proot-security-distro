# proot-security-distro

A lightweight Alpine-based security/pentest environment for Android, running via `proot` inside Termux — no root required.

## Requirements

- [Termux](https://f-droid.org/en/packages/com.termux/) (install from F-Droid, not Play Store)

## Install

```bash
pkg install -y git
git clone https://github.com/wippsanrinthailand80-commits/proot-security-distro.git
cd proot-security-distro
bash install.sh
```

This will:
1. Install `proot-distro` and pull an Alpine Linux rootfs
2. Provision it with base tools + a comprehensive set of security tools
3. Install a beautiful TUI dashboard for easy tool access

## Usage

After install, enter the distro anytime with:

```bash
proot-distro login alpine
```

### Launch the Dashboard UI

```bash
python3 /root/dashboard.py
```

A beautiful menu will appear with all available tools. Press the number key or click to launch any tool.

### Raw Shell

```bash
proot-distro login alpine
```

Your workspace inside the distro lives at `/root/workspace`.

## What's Installed

### 🌐 Networking & Scanning
- **nmap** - Advanced port scanner & network mapper
- **masscan** - Fast mass IP port scanner  
- **tcpdump** - Packet capture & analysis
- **tshark** - Command-line Wireshark
- **whois** - Domain/IP information lookup
- **dig/nslookup** - DNS tools
- **net-tools** - Network utilities

### 🔓 Password & Cryptography
- **hydra** - Brute force password cracking
- **john** - Hash cracking (John the Ripper)
- **hashcat** - GPU-accelerated password recovery
- **openssl** - SSL/TLS encryption tools

### 🌐 Web & Exploitation
- **nikto** - Web server vulnerability scanner
- **sqlmap** - SQL injection testing
- **gobuster** - Directory & DNS brute force
- **burp-suite** - (Manual install: https://portswigger.net)

### 📡 Wireless & WiFi
- **aircrack-ng** - WiFi security assessment suite

### 🐍 Python Libraries
- **scapy** - Packet crafting & network programming
- **requests** - HTTP library
- **paramiko** - SSH library
- **beautifulsoup4** - Web scraping
- **pycryptodome** - Cryptography functions

### 🎨 UI Framework
- **Textual + Rich** - Beautiful TUI dashboard

## Roadmap

- [x] TUI dashboard (Textual) to launch tools from a menu
- [x] Comprehensive security tool set
- [ ] Expand tool set / test coverage under proot
- [ ] Custom ptrace engine backend (in place of Termux's proot)
- [ ] Tool configuration presets
- [ ] Built-in scanning templates

## Limitations

Some tools that require raw sockets or kernel modules may not work fully under `proot` depending on your device's kernel — this is an Android/proot limitation, not a bug in the scripts.

## License

MIT
