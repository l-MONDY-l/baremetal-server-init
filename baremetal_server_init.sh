#!/usr/bin/env bash

# ==========================================================
# Bare Metal Server Init
# Author: Ushan Perera
# Description:
# Baseline Linux server initialization for bare metal systems
# Supported:
#   - Ubuntu
#   - Debian
# ==========================================================

set -euo pipefail

NEW_HOSTNAME="${1:-baremetal-node}"
TIMEZONE="${2:-Asia/Colombo}"
ADMIN_USER="${3:-sysadmin}"
SSH_PUBLIC_KEY="${4:-}"

line() {
    printf '%*s\n' "${COLUMNS:-70}" '' | tr ' ' '='
}

section() {
    echo
    line
    echo "$1"
    line
}

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1"
}

require_root() {
    if [[ "${EUID}" -ne 0 ]]; then
        echo "This script must be run as root or with sudo."
        exit 1
    fi
}

detect_os() {
    if [[ -f /etc/os-release ]]; then
        . /etc/os-release
        OS_ID="${ID:-unknown}"
        OS_VERSION="${VERSION_ID:-unknown}"
    else
        echo "Cannot detect operating system."
        exit 1
    fi
}

update_system() {
    apt-get update
    DEBIAN_FRONTEND=noninteractive apt-get upgrade -y
}

install_base_packages() {
    apt-get install -y \
        curl \
        wget \
        vim \
        git \
        ufw \
        sudo \
        ca-certificates \
        gnupg \
        lsb-release \
        unzip \
        htop \
        net-tools
}

configure_timezone() {
    timedatectl set-timezone "$TIMEZONE"
}

configure_hostname() {
    hostnamectl set-hostname "$NEW_HOSTNAME"
}

create_admin_user() {
    if id "$ADMIN_USER" >/dev/null 2>&1; then
        log "User already exists: $ADMIN_USER"
    else
        useradd -m -s /bin/bash "$ADMIN_USER"
        usermod -aG sudo "$ADMIN_USER"
        log "Created admin user: $ADMIN_USER"
    fi
}

setup_ssh_key() {
    if [[ -n "$SSH_PUBLIC_KEY" ]]; then
        local ssh_dir="/home/${ADMIN_USER}/.ssh"
        local auth_keys="${ssh_dir}/authorized_keys"

        mkdir -p "$ssh_dir"
        echo "$SSH_PUBLIC_KEY" > "$auth_keys"
        chown -R "${ADMIN_USER}:${ADMIN_USER}" "$ssh_dir"
        chmod 700 "$ssh_dir"
        chmod 600 "$auth_keys"

        log "SSH public key configured for user: $ADMIN_USER"
    else
        log "No SSH public key provided. Skipping SSH key setup."
    fi
}

configure_firewall() {
    ufw allow OpenSSH
    ufw --force enable
}

main() {
    require_root
    detect_os

    section "BARE METAL SERVER INITIALIZATION"
    log "Hostname target : ${NEW_HOSTNAME}"
    log "Timezone        : ${TIMEZONE}"
    log "Admin user      : ${ADMIN_USER}"
    log "Operating system: ${OS_ID} ${OS_VERSION}"

    case "${OS_ID}" in
        ubuntu|debian)
            section "UPDATING SYSTEM"
            update_system

            section "INSTALLING BASE PACKAGES"
            install_base_packages
            ;;
        *)
            echo "Unsupported OS: ${OS_ID}"
            echo "This script currently supports Ubuntu and Debian only."
            exit 1
            ;;
    esac

    section "CONFIGURING TIMEZONE"
    configure_timezone

    section "CONFIGURING HOSTNAME"
    configure_hostname

    section "CREATING ADMIN USER"
    create_admin_user

    section "SETTING UP SSH KEY"
    setup_ssh_key

    section "CONFIGURING FIREWALL"
    configure_firewall

    section "INITIALIZATION COMPLETE"
    log "Bare metal server initialization completed successfully."
    echo "Hostname  : ${NEW_HOSTNAME}"
    echo "Timezone  : ${TIMEZONE}"
    echo "Admin user: ${ADMIN_USER}"
}

main "$@"
