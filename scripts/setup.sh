#!/data/data/com.termux/files/usr/bin/bash
#
# setup.sh — Bootstrap an Alpine-based proot security distro on Termux (Android)
#
# What this does:
#   1. Installs proot-distro (Termux's official proot rootfs manager)
#   2. Installs an Alpine Linux rootfs
#   3. Runs first-boot provisioning inside the rootfs (apk update + base tool install)
#
# Usage:
#   bash setup.sh
#
set -euo pipefail

DISTRO_NAME="alpine"
PROJECT_NAME="proot-security-distro"

log()  { printf "\033[1;36m[%s]\033[0m %s\n" "$PROJECT_NAME" "$1"; }
err()  { printf "\033[1;31m[error]\033[0m %s\n" "$1" >&2; }

# --- 0. Sanity check: must be running inside Termux ---------------------
if [ ! -d "/data/data/com.termux/files/usr" ]; then
    err "This script must be run inside Termux on Android."
    exit 1
fi

# --- 1. Update Termux packages and install proot-distro -----------------
log "Updating Termux package lists..."
pkg update -y

log "Installing proot-distro, proot, and git..."
pkg install -y proot-distro proot git

# --- 2. Install the Alpine rootfs (skip if already installed) -----------
if proot-distro list --installed 2>/dev/null | grep -q "$DISTRO_NAME"; then
    log "Alpine rootfs already installed, skipping install step."
else
    log "Installing Alpine rootfs via proot-distro (this may take a few minutes)..."
    proot-distro install "$DISTRO_NAME"
fi

# --- 3. Copy the in-distro provisioning script into the rootfs ----------
ROOTFS_HOME="$HOME/.local/share/proot-distro/installed-rootfs/$DISTRO_NAME/root"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [ ! -f "$SCRIPT_DIR/provision.sh" ]; then
    err "provision.sh not found next to setup.sh — aborting."
    exit 1
fi

log "Copying provisioning script into the Alpine rootfs..."
mkdir -p "$ROOTFS_HOME"
cp "$SCRIPT_DIR/provision.sh" "$ROOTFS_HOME/provision.sh"

# --- 4. Run provisioning inside the rootfs -------------------------------
log "Entering Alpine rootfs to run provisioning..."
proot-distro login "$DISTRO_NAME" -- sh /root/provision.sh

log "Setup complete."
log "Launch your distro anytime with:  proot-distro login $DISTRO_NAME"