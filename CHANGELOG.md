# Changelog

All notable changes to FalconRecon will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [2.0.0] - 2026-01-13

### 🐦‍🔥 Major Release - Egyptian Falcon Edition

Complete rewrite with new branding and features.

### Added

- **𓅃 Egyptian Falcon Branding**
  - New banner with hieroglyphic symbols
  - Gold/amber color theme
  - Redesigned menu interface

- **📡 DNS Reconnaissance Module**
  - Full DNS record enumeration (A, AAAA, MX, NS, TXT, CNAME, SOA)
  - WHOIS information gathering
  - Saved to `dns_recon.txt`

- **🔐 Vulnerability Scanning**
  - Nuclei integration for automated vulnerability detection
  - Severity-based output (critical, high, medium, low)
  - Results saved to `vulnerabilities.txt`

- **📊 HTML Report Generation**
  - Beautiful, shareable HTML reports
  - Summary statistics
  - All findings in one document

- **⚙️ Configuration File Support**
  - `~/.falconrecon.conf` for custom settings
  - Configurable threads, wordlists, logging

- **🔧 Enhanced Setup Script**
  - macOS/Homebrew support
  - Nuclei installation
  - Better progress indicators
  - `--check` flag for quick validation

- **📝 Improved Logging**
  - Timestamped log files
  - Verbose mode option
  - Session tracking

### Changed

- Complete UI overhaul with Egyptian theme
- Improved progress indicators with falcon symbols
- Better error handling and validation
- Enhanced target validation (DNS check)
- Modular function organization
- XML output for nmap scans

### Fixed

- Wordlist detection across multiple paths
- Progress bar not clearing properly
- Menu display on different terminal sizes

---

## [1.0.0] - 2025-XX-XX

### Initial Release

- Subdomain enumeration (subfinder)
- Live host detection (httpx)
- Screenshot capture (gowitness)
- Port scanning (nmap)
- Directory bruteforce (gobuster)
- Technology detection
- URL crawling (katana)
- Basic setup script
