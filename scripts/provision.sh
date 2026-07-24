#!/bin/sh
#
# provision.sh — Runs INSIDE the Alpine proot rootfs (via `proot-distro login`).
# Installs base packages and a starter set of security/pentest tools.
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
    nikto || log "Some packages were unavailable in this Alpine repo branch — continuing."

log "Setting up Python security tooling (sqlmap via pip)..."
pip install --no-cache-dir --break-system-packages sqlmap || log "sqlmap pip install failed — can install manually later."

log "Creating a workspace directory..."
mkdir -p /root/workspace

log "Provisioning complete. Installed tools:"
echo " - nmap, tcpdump, hydra, john, netcat, whois, dig/nslookup, nikto"
echo " - sqlmap (via pip)"
echo ""
echo "Next step: build the TUI dashboard (Textual) to tie these together."