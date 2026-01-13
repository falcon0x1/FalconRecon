<p align="center">
  <img src="assets/banner.png" alt="FalconRecon Banner" width="800"/>
</p>

<h1 align="center">𓅃 FalconRecon</h1>

<p align="center">
  <strong>Reconnaissance Framework</strong><br>
  <em>🐦‍🔥 Flying low, scanning high 🐦‍🔥</em>
</p>

<p align="center">
  <a href="#features"><img src="https://img.shields.io/badge/Version-2.0-gold?style=for-the-badge" alt="Version"></a>
  <a href="LICENSE"><img src="https://img.shields.io/badge/License-MIT-green?style=for-the-badge" alt="License"></a>
  <a href="#installation"><img src="https://img.shields.io/badge/Platform-Linux%20%7C%20macOS-blue?style=for-the-badge" alt="Platform"></a>
  <a href="https://github.com/falcon0x1"><img src="https://img.shields.io/badge/Author-falcon0x1-orange?style=for-the-badge" alt="Author"></a>
</p>

<p align="center">
  <a href="#-quick-start">Quick Start</a> •
  <a href="#-features">Features</a> •
  <a href="#-modules">Modules</a> •
  <a href="#-installation">Installation</a> •
  <a href="#-usage">Usage</a> •
  <a href="#-contributing">Contributing</a>
</p>

---

## 👁️ Overview

**FalconRecon** is a powerful, lightweight Bash-based reconnaissance automation framework designed for penetration testers and security researchers. It chains together industry-standard tools into an elegant workflow with a distinctive Egyptian falcon theme.

```
╔══════════════════════════════════════════════════════════════════╗
║     𓅃  ███████╗ █████╗ ██╗      ██████╗  █████╗ ███╗   ██╗      ║
║        ██╔════╝██╔══██╗██║     ██╔════╝██╔══██╗████╗  ██║       ║
║        █████╗  ███████║██║     ██║     ██║  ██║██╔██╗ ██║       ║
║        ██╔══╝  ██╔══██║██║     ██║     ██║  ██║██║╚██╗██║       ║
║        ██║     ██║  ██║███████╗╚██████╗╚█████╔╝██║ ╚████║  𓅃   ║
║        ╚═╝     ╚═╝  ╚═╝╚══════╝ ╚═════╝ ╚════╝ ╚═╝  ╚═══╝       ║
║       𓆲  R E C O N N A I S S A N C E   F R A M E W O R K  𓆲    ║
╚══════════════════════════════════════════════════════════════════╝
```

---

## ✨ Features

| Feature | Description |
|---------|-------------|
| 𓅈 **Subdomain Discovery** | Enumerate subdomains using subfinder |
| 🪽 **Live Host Detection** | Probe HTTP/HTTPS with httpx + tech detection |
| 📸 **Screenshot Capture** | Visual recon with gowitness |
| 👁️ **Port Scanning** | Top 1000 ports with nmap + service detection |
| 𓅂 **Directory Bruteforce** | Find hidden paths with gobuster |
| 𓅆 **Technology Detection** | Identify tech stacks automatically |
| 𓅇 **URL Crawling** | Deep crawl with katana |
| 📡 **DNS Reconnaissance** | Full DNS record enumeration + WHOIS |
| 🔐 **Vulnerability Scanning** | Automated vuln detection with nuclei |
| 📊 **HTML Reports** | Beautiful, shareable reports |
| ⚙️ **Config File Support** | Customizable settings |

---

## 🚀 Quick Start

```bash
# Clone the repository
git clone https://github.com/falcon0x1/FalconRecon.git
cd FalconRecon

# Make scripts executable
chmod +x FalconRecon.sh setup_tools.sh

# Install dependencies
./setup_tools.sh

# Run FalconRecon
./FalconRecon.sh
```

---

## 📦 Installation

### Prerequisites

- **OS**: Linux (Debian/Ubuntu/Kali/Arch) or macOS
- **Bash**: Version 4.0+
- **Go**: 1.19+ (for go-based tools)

### Option 1: Git Clone (Recommended)

```bash
git clone https://github.com/falcon0x1/FalconRecon.git
cd FalconRecon
chmod +x *.sh
./setup_tools.sh
```

### Option 2: One-Liner

```bash
curl -sL https://raw.githubusercontent.com/falcon0x1/FalconRecon/main/FalconRecon.sh -o FalconRecon.sh && \
curl -sL https://raw.githubusercontent.com/falcon0x1/FalconRecon/main/setup_tools.sh -o setup_tools.sh && \
chmod +x *.sh && ./setup_tools.sh
```

### Required Tools

The `setup_tools.sh` script automatically installs:

| Tool | Purpose |
|------|---------|
| `subfinder` | Subdomain enumeration |
| `httpx` | HTTP probing & tech detection |
| `gowitness` | Screenshot capture |
| `nmap` | Port scanning |
| `gobuster` | Directory bruteforce |
| `katana` | Web crawling |
| `nuclei` | Vulnerability scanning |
| `jq` | JSON processing |
| `dig` | DNS queries |
| `whois` | WHOIS lookups |

---

## 🎯 Usage

### Interactive Mode

```bash
./FalconRecon.sh
```

You'll be prompted for a target domain, then presented with an interactive menu:

```
╔══════════════════════════════════════════════════════════════════╗
║  𓅃  F A L C O N   R E C O N                                      ║
╠══════════════════════════════════════════════════════════════════╣
║  𓆲 RECONNAISSANCE MODULES                                       ║
║   [1] 🐦‍🔥 Full Auto Scan      [6] 𓅂 Directory Brute            ║
║   [2] 𓅈 Subdomain Hunter     [7] 𓅆 Tech Detection             ║
║   [3] 🪽 Live Host Probe      [8] 𓅇 URL Crawler                ║
║   [4] 📸 Screenshot Capture   [9] 🔐 Vuln Scan                  ║
║   [5] 👁️ Port Scanner         [10] 📡 DNS Recon                 ║
║  𓆲 UTILITIES                                                    ║
║  [11] 📊 Generate Report     [12] 𖤍 View Summary               ║
║  [13] ⚙️  Settings            [0] 🚪 Exit                       ║
╚══════════════════════════════════════════════════════════════════╝
```

### Full Auto Scan

Select option `[1]` for comprehensive reconnaissance:

1. DNS reconnaissance
2. Subdomain enumeration
3. Live host detection
4. Screenshot capture
5. Port scanning
6. Directory bruteforce
7. Technology detection
8. Vulnerability scanning
9. HTML report generation

### Output Structure

```
results/
└── target.com/
    ├── subdomains.txt      # Discovered subdomains
    ├── live.txt            # Live hosts
    ├── live_details.json   # Detailed host info
    ├── ports.txt           # Port scan results
    ├── ports.xml           # Nmap XML output
    ├── dns_recon.txt       # DNS records
    ├── tech_summary.txt    # Technology stack
    ├── vulnerabilities.txt # Found vulnerabilities
    ├── dirs_*.txt          # Directory listings
    ├── urls_*.txt          # Crawled URLs
    ├── report.html         # HTML report
    ├── falconrecon.log     # Session log
    └── screens/            # Screenshots
```

---

## ⚙️ Configuration

Create a config file at `~/.falconrecon.conf`:

```bash
# 𓅃 FalconRecon Configuration

# Thread count for parallel operations
THREADS=50

# Enable verbose logging
VERBOSE=false

# Log file path (empty = default)
LOG_FILE=""

# Custom wordlist path
CUSTOM_WORDLIST="/path/to/wordlist.txt"
```

Or use the in-app settings menu (option `[13]`).

---

## 📸 Screenshots

<details>
<summary>Click to expand</summary>

### Main Menu
![Main Menu](assets/menu.png)

### Full Scan Progress
![Scan Progress](assets/scan.png)

### HTML Report
![Report](assets/report.png)

</details>

---

## 🤝 Contributing

Contributions are welcome! See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

---

## 📜 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 🙏 Acknowledgments

- [ProjectDiscovery](https://projectdiscovery.io/) for subfinder, httpx, katana, nuclei
- [Sensepost](https://github.com/sensepost) for gowitness
- [OJ Reeves](https://github.com/OJ) for gobuster
- The security community for inspiration

---

## 📞 Contact

**Mahmoud Elshorbagy**

- GitHub: [@falcon0x1](https://github.com/falcon0x1)

---

<p align="center">
  <strong>𓅃 FalconRecon v2.0</strong><br>
  <em>🐦‍🔥 Flying low, scanning high 🐦‍🔥</em>
</p>
