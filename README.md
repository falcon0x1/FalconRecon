# FalconRecon

**FalconRecon** is a lightweight Bash reconnaissance automation script for penetration testing.
It chains common recon tools (subdomain enumeration, port scanning, HTTP probing) into a simple workflow
and produces structured output.

## Features
- Subdomain enumeration (assetfinder / subfinder / crt.sh)
- Port scanning with `nmap`
- HTTP/HTTPS probing and live host detection (httpx)
- Structured output into `results/<target>/`
- Modular and easy to extend

## Requirements
- Bash (Linux / WSL / macOS)
- nmap
- subfinder or assetfinder
- httpx
- jq (optional)
- curl / wget

Use `setup_tools.sh` to install common dependencies.

## Installation (quick)
```bash
# Download raw scripts from GitHub (replace YOUR_USERNAME)
curl -L https://raw.githubusercontent.com/Mahmoud9421/FalconRecon/main/FalconRecon.sh -o FalconRecon.sh
curl -L https://raw.githubusercontent.com/Mahmoud9421/FalconRecon/main/setup_tools.sh -o setup_tools.sh
chmod +x FalconRecon.sh setup_tools.sh
