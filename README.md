# baremetal-server-init

> Baseline Linux server initialization script for bare metal and production-style deployments. 

![Linux](https://img.shields.io/badge/Platform-Linux-blue?style=for-the-badge)
![Bootstrap](https://img.shields.io/badge/Focus-Server%20Bootstrap-orange?style=for-the-badge)
![Shell](https://img.shields.io/badge/Bash-Script-green?style=for-the-badge)

---

## Overview

`baremetal-server-init` is a Bash bootstrap script for preparing Linux servers with common baseline configuration tasks.

It is designed for fresh server setup workflows and includes system updates, base package installation, hostname configuration, timezone configuration, admin user creation, SSH key setup, and a basic firewall baseline.

---

## Features

- Detect Ubuntu and Debian
- Update and upgrade system packages
- Install common admin tools
- Set server hostname
- Set server timezone
- Create an administrative user
- Add admin user to `sudo`
- Configure SSH authorized key
- Enable UFW with SSH access
- Suitable for initial bare metal setup

---

## Use Cases

- Fresh bare metal server initialization
- New VM bootstrap
- Production baseline configuration
- Lab environment setup
- Linux systems administration portfolio

---

## Supported Operating Systems

- Ubuntu
- Debian

---

## Requirements

- Root or `sudo` access
- Internet connectivity
- `apt`-based Linux distribution

---

## Installation

Clone the repository:

```bash
git clone https://github.com/I-MONDY-I/baremetal-server-init.git
cd baremetal-server-init
```
## Make the script executable:

```bash
chmod +x baremetal_server_init.sh
```
## Usage
Run with defaults:

```bash
sudo ./baremetal_server_init.sh
```

Defaults:

-Hostname: baremetal-node
-Timezone: Asia/Colombo
-Admin user: sysadmin

Run with custom hostname, timezone, and admin user:

```bash
sudo ./baremetal_server_init.sh prod-node-01 Asia/Colombo <username>
```

Arguments:

-Hostname
-Timezone
-Admin username
-SSH public key

Example Output
```
======================================================================
BARE METAL SERVER INITIALIZATION
======================================================================
[2026-03-08 18:02:15] Hostname target : prod-node-01
[2026-03-08 18:02:15] Timezone        : Asia/Colombo
[2026-03-08 18:02:15] Admin user      : ushanadmin
[2026-03-08 18:02:15] Operating system: ubuntu 24.04

======================================================================
UPDATING SYSTEM
======================================================================

======================================================================
INSTALLING BASE PACKAGES
======================================================================

======================================================================
CONFIGURING TIMEZONE
======================================================================
```
