# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [2.0.0] - 2025-09-24

### 🔧 Fixed
- **Critical Database Issue**: Fixed EvilGinx2 sessions not being saved to database
  - Added `db.Flush()` calls to force BuntDB persistence
  - Sessions now properly save to `/root/evilginx2-data/data.db`
  - Data persists across service restarts

### ✨ Added
- **Advanced Session Management System**
  - Session viewing in table and detailed formats
  - Export capabilities in multiple formats (JSON, CSV, Text)
  - Real-time session statistics
  - Safe database cleanup with automatic backups

- **Enhanced Manager Interface**
  - New interactive menu options (items 13-18)
  - Direct command support for automation
  - Session management integration

- **Export Utilities**
  - `export_sessions.sh` - Comprehensive export tool
  - Multiple output formats matching EvilGinx2 interface
  - Global commands: `evilginx-sessions`, `evilginx-export`

- **Documentation**
  - `README_SESSIONS.md` - Session management guide
  - `README_SESSIONS_MANAGER.md` - Manager integration docs
  - `evilginx2_database_fix.patch` - Technical patch details

### 🎮 Enhanced
- **Interactive Menu System**
  - Organized into logical sections
  - Better user experience
  - Color-coded output

- **Command Line Interface**
  - New direct commands for session operations
  - Improved error handling
  - Better status reporting

### 📊 Session Management Features
- **View Options**:
  - Quick table view of all sessions
  - Detailed view of specific sessions
  - Comprehensive view with full details

- **Export Options**:
  - Text format (exact EvilGinx2 match)
  - JSON format (full data structure)
  - CSV format (spreadsheet compatible)

- **Statistics & Monitoring**:
  - Database size monitoring
  - Session count tracking
  - Token capture analytics

- **Database Operations**:
  - Safe cleanup with backup creation
  - Real-time statistics
  - Automatic persistence verification

### 🛠️ Technical Improvements
- **Code Quality**:
  - Better error handling
  - Comprehensive logging
  - Input validation

- **Performance**:
  - Efficient database operations
  - Optimized session retrieval
  - Faster export processing

## [1.0.0] - 2024-08-26

### ✨ Added
- **Initial Release**
  - Automated EvilGinx2 installation
  - Basic service management
  - Interactive manager interface
  - Custom phishlets integration
  - systemd service integration

### 🚀 Features
- **Installation Automation**:
  - Go language installation
  - EvilGinx2 source compilation
  - Dependency resolution
  - Service configuration

- **Management Interface**:
  - Start/stop/restart operations
  - Status monitoring
  - Log viewing
  - Interactive mode support

- **Phishlet Management**:
  - Custom phishlet loading
  - Automatic configuration
  - Community phishlets integration

### 🛠️ Technical Foundation
- **System Integration**:
  - systemd service files
  - Automatic startup configuration
  - Proper permission handling
  - Directory structure creation

- **Error Handling**:
  - Installation validation
  - Service status checking
  - User feedback system

---

## Development Notes

### Version 2.0.0 Development Process

1. **Issue Identification**: Discovered critical database persistence bug in EvilGinx2 v3.3.0
2. **Root Cause Analysis**: BuntDB required explicit `Flush()` calls for disk persistence
3. **Solution Development**: Created comprehensive patch for `core/http_proxy.go`
4. **Feature Enhancement**: Built complete session management system
5. **Integration**: Seamlessly integrated into existing manager interface
6. **Documentation**: Created comprehensive user guides and technical documentation

### Technical Implementation

- **Database Fix**: Modified EvilGinx2 source to add `db.Flush()` after all session operations
- **Export System**: Built Go-based utilities using BuntDB for direct database access
- **Manager Integration**: Enhanced existing bash-based manager with new session features
- **User Experience**: Maintained exact EvilGinx2 output format for familiarity

### Testing & Validation

- Verified session persistence across restarts
- Tested all export formats for accuracy
- Validated manager integration
- Confirmed backward compatibility

---

## Future Roadmap

### Planned for v2.1.0
- [ ] Advanced session filtering options
- [ ] Automated session analysis
- [ ] Enhanced statistics dashboard
- [ ] API endpoint for remote management

### Planned for v2.2.0
- [ ] Web-based management interface
- [ ] Real-time session monitoring
- [ ] Advanced export templates
- [ ] Integration with popular analysis tools

### Community Requests
- [ ] Docker container support
- [ ] Multi-instance management
- [ ] Enhanced phishlet templates
- [ ] Automated reporting features
