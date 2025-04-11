# SourceGuardian Auto Installer

A Bash script to automatically download and configure SourceGuardian loaders for multiple PHP versions on **DirectAdmin** servers.

---

## 📜 Features

- Automatically detects installed PHP versions via DirectAdmin's CustomBuild.
- Downloads and installs the latest SourceGuardian loaders for Linux x86_64.
- Installs missing dependencies (`wget`, `unzip`) if needed.
- Appends loader extension paths to `php.ini` files.
- Restarts corresponding `php-fpm` services after configuration.

---

## ⚙️ Requirements

- Root privileges
- DirectAdmin installed with CustomBuild
- Supported operating systems:
  - RHEL/CentOS/AlmaLinux/Rocky Linux
  - Debian/Ubuntu

---

## 🧪 Tested On

- AlmaLinux 8
- CentOS 7
- Debian 11
- Ubuntu 22.04

---

## 🚀 Usage

```bash
wget https://raw.githubusercontent.com/MohammadParhoun/sourceguardian-installer/main/sourceguardian-installer.sh
chmod +x sourceguardian-installer.sh
sudo ./sourceguardian-installer.sh

