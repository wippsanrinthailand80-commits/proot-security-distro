#!/data/data/com.termux/files/usr/bin/bash
#
# install-on-termux-cmd.sh
# One-liner installer for proot-security-distro
# 
# Usage:
#   curl -fsSL https://raw.githubusercontent.com/wippsanrinthailand80-commits/proot-security-distro/main/install-on-termux-cmd.sh | bash
#
# Or download and run:
#   bash install-on-termux-cmd.sh
#

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Helper functions
echo_header() {
    echo -e "${CYAN}═══════════════════════════════════════════════════${NC}"
    echo -e "${CYAN}  $1${NC}"
    echo -e "${CYAN}═══════════════════════════════════════════════════${NC}"
}

echo_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

echo_error() {
    echo -e "${RED}✗ $1${NC}"
}

echo_info() {
    echo -e "${BLUE}ℹ $1${NC}"
}

echo_warning() {
    echo -e "${YELLOW}⚠ $1${NC}"
}

# Sanity check
echo_header "🔐 proot-security-distro Installer"

if [ ! -d "/data/data/com.termux/files/usr" ]; then
    echo_error "This script must be run inside Termux on Android."
    exit 1
fi

echo_success "Detected Termux environment"
echo ""

# Step 1: Update Termux packages
echo_header "Step 1: Updating Termux packages"
echo_info "Running: pkg update -y"
pkg update -y
echo_success "Termux packages updated"
echo ""

# Step 2: Install required packages
echo_header "Step 2: Installing required packages"
echo_info "Installing: proot-distro, proot, git, python3, python3-pip"
pkg install -y proot-distro proot git python3 python3-pip
echo_success "Required packages installed"
echo ""

# Step 3: Clone the repository
echo_header "Step 3: Cloning proot-security-distro repository"
REPO_DIR="$HOME/proot-security-distro"

if [ -d "$REPO_DIR" ]; then
    echo_warning "Repository already exists at $REPO_DIR"
    read -p "Do you want to overwrite it? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        rm -rf "$REPO_DIR"
        git clone https://github.com/wippsanrinthailand80-commits/proot-security-distro.git "$REPO_DIR"
    fi
else
    git clone https://github.com/wippsanrinthailand80-commits/proot-security-distro.git "$REPO_DIR"
fi

echo_success "Repository cloned to $REPO_DIR"
echo ""

# Step 4: Run the main setup script
echo_header "Step 4: Setting up Alpine proot distro"
echo_info "This may take a few minutes on first run..."
cd "$REPO_DIR"
bash scripts/setup.sh

echo ""
echo_success "Installation complete!"
echo ""
echo_header "📋 Next Steps"
echo_info "1. Enter the distro:"
echo "   ${CYAN}proot-distro login alpine${NC}"
echo ""
echo_info "2. Launch the dashboard UI:"
echo "   ${CYAN}python3 /root/dashboard.py${NC}"
echo ""
echo_info "3. View available tools:"
echo "   ${CYAN}nmap -h${NC}"
echo "   ${CYAN}sqlmap -h${NC}"
echo "   ${CYAN}hydra -h${NC}"
echo ""
echo_info "Workspace location: ${CYAN}/root/workspace${NC}"
echo ""
echo_header "🚀 Happy Hacking!"
echo ""
