# 🎯 AKUMA EvilGinx2 AutoInstaller

**Automated EvilGinx2 installer and management scripts for penetration testing**

![Version](https://img.shields.io/badge/version-v2.0.0-blue)
![Platform](https://img.shields.io/badge/platform-linux-brightgreen)
![Shell](https://img.shields.io/badge/shell-bash-yellow)
![License](https://img.shields.io/badge/license-MIT-red)

## 🆕 What's New in v2.0.0

### ✨ Major Features Added:

- **🔧 Session Database Fix**: Fixed critical issue where EvilGinx2 sessions weren't being saved to database
- **📊 Advanced Session Management**: Full integration of session viewing, export, and management
- **🎮 Enhanced Interactive Interface**: New menu options for session operations
- **📁 Multiple Export Formats**: JSON, CSV, Text formats with exact EvilGinx2 formatting
- **📈 Session Statistics**: Real-time statistics and monitoring
- **🔒 Safe Database Operations**: Automatic backups before cleanup operations

---

## 🎯 Overview

This project provides a comprehensive automation solution for EvilGinx2 deployment, management, and session handling. Perfect for penetration testers and security researchers who need a reliable, automated setup.

## ⚡ Quick Start

### One-Line Installation
```bash
git clone https://github.com/sweetpotatohack/AKUMA-EvilGinx2-AutoInstaller.git
cd AKUMA-EvilGinx2-AutoInstaller
chmod +x install_evilginx2.sh
sudo ./install_evilginx2.sh
```

### Launch Manager
```bash
sudo ./evilginx2_manager.sh
```

---

## 🎮 Features

### 🚀 Core Installation & Management
- **Automated Installation**: One-click EvilGinx2 setup with all dependencies
- **Service Management**: systemd integration with auto-start capability
- **Configuration Management**: Automated phishlets and redirectors setup
- **Real-time Monitoring**: Live logs and status monitoring

### 📊 Advanced Session Management (NEW!)
- **Database Persistence**: Fixed session saving to `/root/evilginx2-data/data.db`
- **Interactive Viewing**: Table and detailed views exactly like EvilGinx2 interface
- **Export Capabilities**: Multiple formats (JSON, CSV, Text)
- **Session Statistics**: Real-time analytics and monitoring
- **Safe Cleanup**: Database cleanup with automatic backups

### 🛠️ Management Options

#### Interactive Menu
```bash
./evilginx2_manager.sh
```

**Service Management:**
- Status, Start, Stop, Restart
- Enable/Disable autostart
- Live log monitoring
- Interactive mode

**Session Management (NEW!):**
- **13** - Show sessions table
- **14** - View specific session details  
- **15** - Show all sessions with details
- **16** - Export sessions to file
- **17** - Session statistics
- **18** - Clean database (with backup)

#### Direct Commands
```bash
# Service operations
./evilginx2_manager.sh status
./evilginx2_manager.sh start
./evilginx2_manager.sh restart

# Session operations (NEW!)
./evilginx2_manager.sh sessions      # Quick table view
./evilginx2_manager.sh stats         # Database statistics  
./evilginx2_manager.sh export        # Interactive export
./evilginx2_manager.sh cleanup       # Safe database cleanup
```

---

## 🔧 Technical Details

### 🗂️ Project Structure
```
AKUMA-EvilGinx2-AutoInstaller/
├── install_evilginx2.sh           # Main installer
├── evilginx2_manager.sh            # Enhanced manager with session support
├── fix_phishlets.sh                # Phishlet fixing utility
├── export_sessions.sh              # Session export utility (NEW!)
├── evilginx2_database_fix.patch    # Database persistence patch (NEW!)
├── README_SESSIONS.md              # Session management documentation (NEW!)
├── README_SESSIONS_MANAGER.md      # Manager integration guide (NEW!)
└── phishlets/                      # Custom phishlets collection
```

### 🛡️ Session Database Fix

**Problem Solved**: EvilGinx2 v3.3.0 had a critical issue where sessions were displayed in the interface but not saved to the database file.

**Solution**: Added `db.Flush()` calls to force BuntDB to write data to disk:
- After session creation
- After username/password capture  
- After token updates

**Result**: 
- ✅ All sessions now persist in `/root/evilginx2-data/data.db`
- ✅ Data survives service restarts
- ✅ Export and analysis capabilities enabled

### 📊 Session Export Examples

#### Quick Table View
```bash
./evilginx2_manager.sh sessions
```
Output:
```
+-----+-----------------+---------------+-----------------+-----------+-----------------+-------------------+
| id  |    phishlet     |   username    |    password     |  tokens   |   remote ip     |       time        |
+-----+-----------------+---------------+-----------------+-----------+-----------------+-------------------+
| 2   | keydisk-portal  | vysotskiy_dv  | 80Vfk"ynRbyCtk  | captured  | 109.225.41.64   | 2025-09-24 17:05  |
+-----+-----------------+---------------+-----------------+-----------+-----------------+-------------------+
```

#### Detailed Session View
```bash
./evilginx2_manager.sh session
# Enter session ID: 2
```
Output:
```
 id           : 2
 phishlet     : keydisk-portal
 username     : vysotskiy_dv
 password     : 80Vfk"ynRbyCtk
 tokens       : captured
 landing url  : https://portal.keydlsk.ru/auth
 user-agent   : Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:143.0) Gecko/20100101 Firefox/143.0
 remote ip    : 109.225.41.64
 create time  : 2025-09-24 17:05
 update time  : 2025-09-24 17:05

[ cookies ]
[{"path":"/","domain":"portal.keydisk.ru","expirationDate":1790283677,"value":"vysotskiy_dv",...}]
```

#### Statistics
```bash
./evilginx2_manager.sh stats
```
Output:
```
Database size: 2.1K
Total sessions: 4
Sessions with tokens: 1
```

---

## 🎯 Installation Details

### Requirements
- **OS**: Ubuntu/Debian (tested on Ubuntu 20.04+)
- **Privileges**: Root access required
- **Network**: Internet connection for dependencies
- **Domain**: Valid domain name for certificates

### What Gets Installed
1. **Go** programming language (latest version)
2. **EvilGinx2** from official repository
3. **System service** with auto-start capability
4. **Custom phishlets** and redirectors
5. **Session management tools** (NEW!)
6. **Database persistence fix** (NEW!)

### Directory Structure Created
```
/root/evilginx2/                    # Source code
/root/evilginx2-data/               # Data directory
├── data.db                         # Session database (FIXED!)
├── config.json                     # Configuration
├── phishlets/                      # Phishlets
├── redirectors/                    # Redirectors  
├── crt/                           # Certificates
└── export_sessions.sh              # Export utility (NEW!)
```

---

## 🎮 Usage Examples

### Basic Setup
```bash
# 1. Install EvilGinx2
sudo ./install_evilginx2.sh

# 2. Configure domain (example)
sudo ./evilginx2_manager.sh interactive
# In EvilGinx2 console:
# config domain your-domain.com
# config ipv4 YOUR_SERVER_IP

# 3. Enable phishlet
# phishlets enable example
# lures create example
# lures get-url 0
```

### Session Management Workflow
```bash
# 1. Check current sessions
./evilginx2_manager.sh sessions

# 2. View detailed session info
./evilginx2_manager.sh session
# Enter ID when prompted

# 3. Export valuable sessions
./evilginx2_manager.sh export
# Choose format and sessions to export

# 4. Monitor statistics
./evilginx2_manager.sh stats
```

---

## 🛡️ Security & Legal Notice

### ⚠️ IMPORTANT DISCLAIMER

This tool is designed for **authorized penetration testing** and **security research** purposes only.

### ✅ Legitimate Uses
- **Authorized Penetration Testing**
- **Security Awareness Training** 
- **Red Team Exercises**
- **Academic Research**
- **Personal Lab Environment**

### ❌ Prohibited Uses
- Unauthorized access to systems
- Malicious phishing campaigns
- Identity theft or fraud
- Any illegal activities

### 🔒 Best Practices
- Always obtain **written authorization** before testing
- Use only in **controlled environments**
- Follow **responsible disclosure** practices
- Respect **privacy and data protection** laws
- Document and **report findings** properly

**By using this tool, you accept full responsibility for its use and agree to use it only for legitimate, authorized purposes.**

---

## 🤝 Contributing

### How to Contribute
1. Fork the repository
2. Create a feature branch: `git checkout -b feature/amazing-feature`
3. Make your changes
4. Test thoroughly
5. Commit: `git commit -m 'Add amazing feature'`
6. Push: `git push origin feature/amazing-feature`
7. Open a Pull Request

### Areas for Contribution
- Additional phishlets
- New export formats
- Enhanced session analysis
- Performance improvements
- Documentation updates
- Bug fixes

---

## 📞 Support & Contact

### Issues & Bugs
- **GitHub Issues**: [Report bugs or request features](https://github.com/sweetpotatohack/AKUMA-EvilGinx2-AutoInstaller/issues)
- **Discussions**: Use GitHub Discussions for questions

### Documentation
- **Session Management**: See `README_SESSIONS.md`
- **Manager Guide**: See `README_SESSIONS_MANAGER.md` 
- **Installation Issues**: Check existing issues or create new one

---

## 📋 Changelog

### v2.0.0 (2025-09-24) - Major Release
- **🔧 FIXED**: Critical database persistence issue in EvilGinx2
- **📊 NEW**: Advanced session management system
- **🎮 NEW**: Enhanced interactive manager interface
- **📁 NEW**: Multiple export formats (JSON, CSV, Text)
- **📈 NEW**: Real-time session statistics
- **🔒 NEW**: Safe database cleanup with auto-backup
- **📚 NEW**: Comprehensive documentation updates

### v1.0.0 (2024-08-26) - Initial Release
- Basic EvilGinx2 installation automation
- Service management capabilities
- Custom phishlets integration
- Interactive management interface

---

## 📜 License

This project is licensed under the **MIT License** - see the [LICENSE](LICENSE) file for details.

### MIT License Summary
- ✅ **Use** - Commercial and private use allowed
- ✅ **Modify** - Modification and derivative works allowed
- ✅ **Distribute** - Distribution allowed
- ✅ **Private Use** - Private use allowed
- ❗ **Liability** - No warranty provided
- ❗ **Responsibility** - Use at your own risk

---

## 🎯 Credits & Acknowledgments

### Original Projects
- **EvilGinx2**: [kgretzky/evilginx2](https://github.com/kgretzky/evilginx2) - The core phishing framework
- **Community Phishlets**: Various contributors from the security community

### Development
- **AKUMA Project**: Automation and enhancement layer
- **sweetpotatohack**: Primary development and maintenance
- **Community**: Bug reports, feature requests, and contributions

---

## 🔗 Related Projects

- **EvilGinx2 Official**: [kgretzky/evilginx2](https://github.com/kgretzky/evilginx2)
- **Phishlet Collections**: Various community repositories
- **Penetration Testing Tools**: OWASP, Kali Linux toolkit

---

**⭐ If this project helped you, please consider giving it a star! ⭐**

*Made with ❤️ for the security community*
