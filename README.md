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
2. Provision it with base tools + a starter set of security tools (nmap, tcpdump, hydra, john, sqlmap, etc.)

## Usage

After install, enter the distro anytime with:

```bash
proot-distro login alpine
```

Your workspace inside the distro lives at `/root/workspace`.

## What's installed

- **Base:** bash, python3, git, build-base, vim, ssh client
- **Security tools:** nmap, tcpdump, hydra, john, netcat, whois, dig/nslookup, nikto, sqlmap

Note: some tools that require raw sockets or kernel modules may not work fully under `proot` depending on your device's kernel — this is an Android/proot limitation, not a bug in the scripts.

## Roadmap

- [ ] TUI dashboard (Textual) to launch tools from a menu instead of raw shell
- [ ] Expand tool set / test coverage under proot
- [ ] Optional custom ptrace engine backend (in place of Termux's proot)

## License

MIT