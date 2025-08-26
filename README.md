# 🥷 AKUMA EvilGinx2 AutoInstaller

<div align="center">

![AKUMA Logo](https://img.shields.io/badge/AKUMA-EvilGinx2-red?style=for-the-badge&logo=hackthebox&logoColor=white)
[![Version](https://img.shields.io/badge/Version-1.2.0-blue?style=for-the-badge)](https://github.com/sweetpotatohack/AKUMA-EvilGinx2-AutoInstaller)
[![License](https://img.shields.io/badge/License-MIT-green?style=for-the-badge)](LICENSE)
[![EvilGinx2](https://img.shields.io/badge/EvilGinx2-3.3.0-orange?style=for-the-badge)](https://github.com/kgretzky/evilginx2)

**Automated installation and management suite for EvilGinx2 phishing framework**

[Features](#-features) • [Installation](#-quick-installation) • [Usage](#-usage) • [Documentation](#-documentation) • [Security](#-security-notice)

</div>

---

## 🚨 **CRITICAL SECURITY NOTICE**

> **⚠️ WARNING: This tool is designed EXCLUSIVELY for authorized penetration testing and security research with explicit written permission. Unauthorized use for malicious purposes is strictly prohibited and illegal.**

**Use responsibly. Use ethically. Use legally.**

---

## 📋 **Overview**

AKUMA EvilGinx2 AutoInstaller is a comprehensive automation suite that simplifies the deployment, configuration, and management of the EvilGinx2 reverse proxy phishing framework. This toolkit is designed for cybersecurity professionals conducting authorized penetration tests and security assessments.

### What is EvilGinx2?

EvilGinx2 is a man-in-the-middle attack framework used for phishing login credentials and session cookies, enabling bypass of 2-factor authentication. It acts as a reverse proxy between the victim and the legitimate website.

---

## 🎯 **Features**

### 🔧 **Automated Installation**
- ✅ **One-click setup** - Complete EvilGinx2 installation with a single command
- ✅ **Dependency management** - Automatic installation of Go, Git, and build tools
- ✅ **Multi-distro support** - Ubuntu, Debian, CentOS, RHEL, Fedora
- ✅ **System validation** - Pre-installation system requirements check
- ✅ **Clean removal** - Remove existing installations before fresh setup

### 🎛️ **Management Interface**
- ✅ **Interactive menu** - User-friendly command-line interface
- ✅ **Service management** - systemd service integration
- ✅ **Real-time monitoring** - Live log viewing and status monitoring
- ✅ **Auto-update** - Built-in EvilGinx2 update functionality
- ✅ **Configuration display** - Easy access to all configuration paths

### 🎯 **Phishlet Collection**
- ✅ **89+ phishlets included** - Comprehensive collection bundled in repository
- ✅ **Popular services covered** - Google, Facebook, Microsoft, Amazon, PayPal, LinkedIn
- ✅ **Custom Bitrix24 phishlets** - Specialized for portal.keydisk.ru + universal version
- ✅ **Auto-installation** - Phishlets installed automatically during setup
- ✅ **Offline capability** - No internet dependency for phishlet installation

### 🔒 **Security & Reliability**
- ✅ **Root privilege validation** - Ensures proper permissions
- ✅ **Error handling** - Comprehensive error detection and reporting
- ✅ **Backup support** - Configuration and data preservation
- ✅ **Service reliability** - Auto-restart on failure

---

## 🚀 **Quick Installation**

### Prerequisites

| Requirement | Details |
|-------------|---------|
| **OS** | Ubuntu 18.04+, Debian 9+, CentOS 7+, RHEL 7+, Fedora 28+ |
| **Privileges** | Root/sudo access required |
| **Network** | Internet connection for package downloads |
| **Architecture** | x86_64/amd64 |

### One-Line Installation

```bash
# Download and run the installer
curl -sSL https://raw.githubusercontent.com/sweetpotatohack/AKUMA-EvilGinx2-AutoInstaller/main/install_evilginx2.sh | sudo bash
```

**⚠️ Note:** For the full experience with all 89+ phishlets, clone the repository instead of using one-line installation.

### Manual Installation

```bash
# Clone the repository
git clone https://github.com/sweetpotatohack/AKUMA-EvilGinx2-AutoInstaller.git
cd AKUMA-EvilGinx2-AutoInstaller

# Make scripts executable
chmod +x install_evilginx2.sh evilginx2_manager.sh

# Run the installer
sudo ./install_evilginx2.sh
```

### 🔧 **Fix Missing Phishlets (if needed)**

If you installed EvilGinx2 but phishlets are missing, use the fix script:

```bash
# Fix phishlets in existing installation
sudo ./fix_phishlets.sh
```

---

## 🎮 **Usage**

### 🎯 **Quick Start**

After installation, you have several options to run EvilGinx2:

#### Option 1: Interactive Mode (Recommended for beginners)
```bash
sudo ./evilginx2_manager.sh interactive
```

#### Option 2: Service Mode (Recommended for production)
```bash
# Start as a system service
sudo ./evilginx2_manager.sh start

# Enable auto-start on boot
sudo ./evilginx2_manager.sh enable
```

#### Option 3: Management Menu
```bash
sudo ./evilginx2_manager.sh
```

### 🎛️ **Management Commands**

| Command | Description |
|---------|-------------|
| `status` | Show service status |
| `start` | Start EvilGinx2 service |
| `stop` | Stop EvilGinx2 service |
| `restart` | Restart EvilGinx2 service |
| `enable` | Enable auto-start on boot |
| `disable` | Disable auto-start |
| `logs` | View recent logs |
| `follow` | Follow logs in real-time |
| `interactive` | Run in interactive mode |
| `config` | Show configuration paths |
| `phishlets` | List available phishlets |
| `update` | Update EvilGinx2 to latest version |

### 📁 **Directory Structure**

After installation, the following directory structure is created:

```
/root/
├── evilginx2/                    # Source code
│   ├── build/evilginx           # Compiled binary
│   ├── phishlets/               # Original phishlets
│   └── redirectors/             # Original redirectors
├── evilginx2-data/              # Working directory
│   ├── phishlets/               # Active phishlets
│   ├── redirectors/             # Active redirectors
│   └── database/                # Session database
/usr/local/bin/evilginx          # System binary
/etc/systemd/system/evilginx2.service  # systemd service
```

---

## 🎨 **Screenshots**

### Installation Process
```
==================================================
         Evilginx2 Автоматический установщик
==================================================

[INFO] Обнаружена ОС: Ubuntu 22.04
[INFO] Установка зависимостей (Git, Go)...
[SUCCESS] Go версии 1.22 установлен корректно
[INFO] Клонирование Evilginx2 в /root/evilginx2...
[SUCCESS] Репозиторий успешно склонирован
[INFO] Компиляция Evilginx2...
[SUCCESS] Evilginx2 успешно скомпилирован
[SUCCESS] Evilginx2 установлен в /usr/local/bin/evilginx
```

### Management Interface
```
==========================================
         Evilginx2 Manager
==========================================

1.  Показать статус сервиса
2.  Запустить сервис
3.  Остановить сервис
4.  Перезапустить сервис
5.  Включить автозапуск
6.  Отключить автозапуск
7.  Показать логи
8.  Следить за логами
9.  Запустить интерактивно
10. Показать конфигурацию
11. Показать phishlets
12. Обновить Evilginx2
0.  Выход

Выберите действие:
```

---

## 📚 **Documentation**

### 🔧 **Configuration**

EvilGinx2 configuration files and data are stored in:
- **Main config**: `/root/evilginx2-data/`
- **Phishlets**: `/root/evilginx2-data/phishlets/`
- **Redirectors**: `/root/evilginx2-data/redirectors/`
- **Database**: `/root/evilginx2-data/database/`

### 🎭 **Working with Phishlets**

```bash
# List available phishlets
sudo ./evilginx2_manager.sh phishlets

# Run EvilGinx2 interactively to manage phishlets
sudo ./evilginx2_manager.sh interactive
```

Inside EvilGinx2 interactive shell:
```
evilginx> phishlets                    # List all phishlets
evilginx> phishlets enable office365   # Enable a phishlet
evilginx> lures create office365       # Create a lure
evilginx> sessions                     # View captured sessions
```

### 🗂️ **Included Phishlets (89+ Total)**

<details>
<summary>🌟 Click to view complete phishlet collection</summary>

#### 🏢 **Business & Enterprise**
- **Microsoft**: microsoft, o365 (8 variants), outlook (4 variants), hotmail
- **Google**: google, google2, google-botguard-bypass, gsuite
- **AWS**: aws
- **Citrix**: citrix
- **Okta**: okta
- **OneLogin**: onelogin

#### 📧 **Email & Communication**
- **Outlook**: outlook, outlook2, outlook3, hotmail
- **AOL**: aol
- **ProtonMail**: protonmail
- **Viber**: viber

#### 💰 **Financial & E-commerce**
- **PayPal**: paypal, paypal(working2)
- **Amazon**: amazon, amazon-seller, Amazon--
- **eBay**: ebay
- **Coinspot**: coinspot
- **Fidelity**: fidelity
- **Paxful**: paxful
- **Luno**: luno
- **Vanguard**: vanguard
- **OpenBank**: openbank

#### 🌐 **Social Media**
- **Facebook**: facebook, facebook-d, facebook-d2, facebook-d3, facebook-fix
- **LinkedIn**: linkedin, linkedin2
- **Instagram**: instagram
- **Twitter**: twitter, twitter-mobile
- **TikTok**: tiktok
- **Snapchat**: snapchat
- **Reddit**: reddit

#### 🏨 **Travel & Booking**
- **Airbnb**: airbnb, airbnbfr
- **Booking**: booking
- **VRBO**: vrbo

#### 🎮 **Gaming & Entertainment**
- **PlayStation**: playstation, playstation-B
- **Steam**: steam
- **Roblox**: roblox
- **SuperSport**: supersport

#### 🛒 **Shopping & Marketplace**
- **Alibaba**: alibaba
- **Allegro**: allegro
- **CoolBlue**: coolblue
- **Mobile.de**: mobile-de
- **Autoline**: autoline

#### ☁️ **Cloud & Storage**
- **DropBox**: dropbox
- **iCloud**: icloud, icloud2

#### 🏢 **Hosting & Domains**
- **GoDaddy**: godaddy, godaddy(sso)
- **Namecheap**: namecheap
- **Rackspace**: rackspace
- **Ionos**: ionos
- **Hetzner**: hetzner

#### 🔧 **Development & Tools**
- **GitHub**: github
- **WordPress**: wordpress.org
- **Chrome Extension**: chrome_extension
- **EDD**: edd

#### 🏢 **Custom Business Solutions**
- **Bitrix24**: bitrix24-keydisk (for portal.keydisk.ru), bitrix24-universal
- **Intuit**: intuit
- **Gusto**: gusto

#### 🌏 **Regional Services**
- **Xfinity**: xfinity
- **Yahoo**: yahoo(fixed)
- **Hinet**: hinet, webhinet
- **Fudan**: fudan
- **163**: 163working

#### 🔐 **Security & Testing**
- **reCAPTCHA**: recaptcha-demo
- **hCaptcha**: hcaptcha-demo
- **Example**: example (template)

</details>

### 🔄 **Updates and Maintenance**

```bash
# Update EvilGinx2 to latest version
sudo ./evilginx2_manager.sh update

# Check service status
sudo ./evilginx2_manager.sh status

# View logs for troubleshooting
sudo ./evilginx2_manager.sh logs
```

### 🐛 **Troubleshooting**

#### Common Issues

| Issue | Solution |
|-------|----------|
| **Permission denied** | Run with `sudo` |
| **Port already in use** | Stop conflicting services (apache2, nginx) |
| **Go version too old** | Update Go to 1.19+ |
| **Service won't start** | Check logs with `sudo ./evilginx2_manager.sh logs` |

#### Service Management

```bash
# Check if service is running
sudo systemctl status evilginx2

# View detailed logs
sudo journalctl -u evilginx2 -f

# Restart service manually
sudo systemctl restart evilginx2
```

---

## 🔗 **Related Resources**

### Official Links
- 🌐 [EvilGinx2 Official Repository](https://github.com/kgretzky/evilginx2)
- 📖 [Official Documentation](https://help.evilginx.com)
- 🎓 [EvilGinx Mastery Course](https://academy.breakdev.org/evilginx-mastery)

### Community Resources
- 🔧 [Phishlets Collection](https://github.com/An0nUD4Y/Evilginx2-Phishlets)
- 💡 [Security Research Papers](https://scholar.google.com/scholar?q=evilginx2)
- 🛡️ [Defense Strategies](https://www.sans.org/blog/detecting-malicious-reverse-proxies/)

---

## 🤝 **Contributing**

We welcome contributions! Please read our contributing guidelines:

### How to Contribute
1. 🍴 Fork the repository
2. 🌿 Create a feature branch (`git checkout -b feature/awesome-feature`)
3. 💾 Commit your changes (`git commit -m 'Add awesome feature'`)
4. 📤 Push to the branch (`git push origin feature/awesome-feature`)
5. 🔄 Open a Pull Request

### What We Need
- 🐛 Bug fixes
- ✨ New features
- 📝 Documentation improvements
- 🧪 Test coverage
- 🌍 Multi-language support

---

## 📄 **License**

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

### Third-Party Licenses
- **EvilGinx2**: BSD-3-Clause License by [@kgretzky](https://github.com/kgretzky)

---

## ⚖️ **Legal Disclaimer**

> **This tool is provided for educational and authorized testing purposes only. The developers assume NO liability and are NOT responsible for any misuse or damage caused by this program. Users must comply with all applicable laws and regulations. Unauthorized access to computer systems is illegal.**

### Ethical Use Guidelines
- ✅ **Only use on systems you own or have explicit permission to test**
- ✅ **Obtain written authorization before any penetration testing**
- ✅ **Follow responsible disclosure practices**
- ✅ **Respect privacy and confidentiality**
- ❌ **Do not use for malicious purposes**
- ❌ **Do not test without permission**

---

## 👨‍💻 **Author & Support**

### Author
- **GitHub**: [@sweetpotatohack](https://github.com/sweetpotatohack)
- **Project**: AKUMA EvilGinx2 AutoInstaller

### Original EvilGinx2 Author
- **GitHub**: [@kgretzky](https://github.com/kgretzky)
- **Twitter**: [@mrgretzky](https://twitter.com/mrgretzky)

### Support
- 🐛 [Report Bugs](https://github.com/sweetpotatohack/AKUMA-EvilGinx2-AutoInstaller/issues)
- 💬 [Feature Requests](https://github.com/sweetpotatohack/AKUMA-EvilGinx2-AutoInstaller/issues)
- 📖 [Documentation](https://github.com/sweetpotatohack/AKUMA-EvilGinx2-AutoInstaller/wiki)

---

<div align="center">

### ⭐ **If this project helped you, please give it a star!** ⭐

![Star History](https://api.star-history.com/svg?repos=sweetpotatohack/AKUMA-EvilGinx2-AutoInstaller&type=Date)

---

**Made with ❤️ for the cybersecurity community**

**Remember: Use your powers for good! 🛡️**

</div>
