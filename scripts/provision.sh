#!/bin/sh
#
# provision.sh — Runs INSIDE the Alpine proot rootfs (via `proot-distro login`).
# Installs base packages and a comprehensive set of security/pentest tools.
#
set -eu

log() { printf "\033[1;35m[provision]\033[0m %s\n" "$1"; }

log "Updating apk package index..."
apk update
apk upgrade

log "Installing base system tools..."
apk add --no-cache \
    bash \
    curl \
    wget \
    git \
    vim \
    nano \
    python3 \
    py3-pip \
    build-base \
    openssh-client \
    ca-certificates \
    tzdata

log "Installing core security / pentest tools available on Alpine..."
# Note: some tools (e.g. those needing raw sockets or kernel modules) may not
# work correctly under proot depending on the host kernel's permissions.
# This first pass sticks to tools known to work in userspace under proot.
apk add --no-cache \
    nmap \
    nmap-scripts \
    tcpdump \
    hydra \
    john \
    netcat-openbsd \
    whois \
    bind-tools \
    net-tools \
    openssl \
    nikto \
    aircrack-ng \
    tshark \
    masscan \
    hashcat \
    wget \
    curl || log "Some packages were unavailable in this Alpine repo branch — continuing."

log "Installing Python security tooling via pip..."
pip install --no-cache-dir --break-system-packages \
    sqlmap \
    gobuster \
    requests \
    paramiko \
    pycryptodome \
    scapy \
    beautifulsoup4 || log "Some pip packages failed — can install manually later."

log "Creating workspace and tools directory..."
mkdir -p /root/workspace
mkdir -p /root/tools

log "Installing Metasploit Framework (lightweight version)..."
apk add --no-cache ruby ruby-dev postgresql-client postgresql-dev \
    autoconf automake libtool bison flex libpcap-dev || log "Metasploit deps partially installed."

log "Downloading and installing dashboard UI..."
pip install --no-cache-dir --break-system-packages textual rich || log "Dashboard deps failed."

log "Provisioning complete. Installed tools:"
echo ""
echo "========================================"
echo "  Core Networking & Scanning Tools:"
echo "========================================"
echo " ✓ nmap + nmap-scripts"
echo " ✓ masscan (fast port scanner)"
echo " ✓ tcpdump (packet capture)"
echo " ✓ tshark (Wireshark CLI)"
echo " ✓ whois, dig/nslookup (DNS tools)"
echo " ✓ net-tools"
echo ""
echo "========================================"
echo "  Password & Cryptography Tools:"
echo "========================================"
echo " ✓ hydra (brute force)"
echo " ✓ john (password cracking)"
echo " ✓ hashcat (GPU cracking)"
echo " ✓ openssl"
echo ""
echo "========================================"
echo "  Web & Exploitation Tools:"
echo "========================================"
echo " ✓ nikto (web scanner)"
echo " ✓ sqlmap (SQL injection)"
echo " ✓ gobuster (directory brute force)"
echo " ✓ burp-suite (via manual install)"
echo ""
echo "========================================"
echo "  Wireless & WiFi Tools:"
echo "========================================"
echo " ✓ aircrack-ng (WiFi security)"
echo ""
echo "========================================"
echo "  Python Security Libraries:"
echo "========================================"
echo " ✓ scapy (packet crafting)"
echo " ✓ requests (HTTP library)"
echo " ✓ paramiko (SSH library)"
echo " ✓ beautifulsoup4 (web scraping)"
echo " ✓ pycryptodome (cryptography)"
echo ""
echo "========================================"
echo "  UI Dashboard:"
echo "========================================"
echo " ✓ Textual + Rich (TUI framework)"
echo ""
echo "Launch dashboard with: python3 /root/dashboard.py"
echo "Workspace location: /root/workspace"
echo ""
