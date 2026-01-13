#!/usr/bin/env bash

#═══════════════════════════════════════════════════════════════════════════════
#  𓅃 FALCON RECON - Tool Installation Manager v2.0
#═══════════════════════════════════════════════════════════════════════════════

# Colors
GOLD='\033[38;5;220m'
GREEN='\033[0;32m'
RED='\033[0;31m'
DIM='\033[2m'
NC='\033[0m'

echo -e "${GOLD}"
cat << 'EOF'
    ╔════════════════════════════════════════════════════════════════╗
    ║  𓅃 FALCON RECON - Tool Setup                                  ║
    ╠════════════════════════════════════════════════════════════════╣
EOF
echo -e "${NC}"

# Tools with sizes
TOOLS=(
    "subfinder:~10MB:Subdomain discovery"
    "httpx:~15MB:HTTP probing"
    "gowitness:~25MB:Screenshot capture"
    "nmap:~30MB:Port scanning"
    "gobuster:~8MB:Directory bruteforce"
    "katana:~12MB:Web crawling"
    "nuclei:~50MB:Vulnerability scanning"
    "jq:~1MB:JSON processing"
    "wget:~1MB:File downloading"
    "dig:~2MB:DNS queries"
    "whois:~1MB:WHOIS lookups"
)

GO_TOOLS=(
    "subfinder:github.com/projectdiscovery/subfinder/v2/cmd/subfinder"
    "httpx:github.com/projectdiscovery/httpx/cmd/httpx"
    "gowitness:github.com/sensepost/gowitness"
    "katana:github.com/projectdiscovery/katana/cmd/katana"
    "nuclei:github.com/projectdiscovery/nuclei/v3/cmd/nuclei"
)

# Expanded wordlist paths for different distros
WORDLISTS=(
    "/usr/share/wordlists/dirb/common.txt"
    "/usr/share/wordlists/dirbuster/directory-list-2.3-small.txt"
    "/usr/share/seclists/Discovery/Web-Content/common.txt"
    "/usr/share/wordlists/common.txt"
    "/usr/share/dirb/wordlists/common.txt"
    "$HOME/.falconrecon/wordlists/common.txt"
)

#───────────────────────────────────────────────────────────────────────────────
# Sudo Keepalive - prevents timeout during long installations
#───────────────────────────────────────────────────────────────────────────────

SUDO_PID=""

start_sudo_keepalive() {
    # Only if we need sudo
    if [ "$EUID" -ne 0 ]; then
        # Validate sudo upfront
        echo -e "${DIM}    Authenticating...${NC}"
        sudo -v || { echo -e "${RED}    Sudo required for installation${NC}"; exit 1; }
        
        # Background process to refresh sudo every 50 seconds
        (while true; do sudo -n true; sleep 50; done) 2>/dev/null &
        SUDO_PID=$!
    fi
}

stop_sudo_keepalive() {
    [ -n "$SUDO_PID" ] && kill "$SUDO_PID" 2>/dev/null
}

# Cleanup on exit
trap stop_sudo_keepalive EXIT



#───────────────────────────────────────────────────────────────────────────────
# Check Mode (for --check flag)
#───────────────────────────────────────────────────────────────────────────────

if [ "$1" = "--check" ]; then
    missing=0
    for tool_info in "${TOOLS[@]}"; do
        tool="${tool_info%%:*}"
        command -v "$tool" &> /dev/null || ((missing++))
    done
    [ $missing -eq 0 ] && exit 0 || exit 1
fi

#───────────────────────────────────────────────────────────────────────────────
# Tool Check
#───────────────────────────────────────────────────────────────────────────────

echo -e "${GOLD}    𓆲 Checking installed tools...${NC}"
echo ""

MISSING=()
for tool_info in "${TOOLS[@]}"; do
    tool="${tool_info%%:*}"
    rest="${tool_info#*:}"
    size="${rest%%:*}"
    desc="${rest#*:}"
    
    if command -v "$tool" &> /dev/null; then
        echo -e "    ${GREEN}𖤍${NC} $tool ${DIM}($desc)${NC}"
    else
        echo -e "    ${RED}✗${NC} $tool ${DIM}($size - $desc)${NC}"
        MISSING+=("$tool")
    fi
done

echo ""
echo -e "${GOLD}    𓆲 Checking wordlists...${NC}"

WORDLIST_FOUND=false
for wl in "${WORDLISTS[@]}"; do
    if [ -f "$wl" ]; then
        echo -e "    ${GREEN}𖤍${NC} Wordlist: ${DIM}$wl${NC}"
        WORDLIST_FOUND=true
        break
    fi
done

[ "$WORDLIST_FOUND" = false ] && echo -e "    ${RED}✗${NC} No wordlist found ${DIM}(needed for directory scanning)${NC}"

echo ""

#───────────────────────────────────────────────────────────────────────────────
# All Good Check
#───────────────────────────────────────────────────────────────────────────────

if [ ${#MISSING[@]} -eq 0 ] && [ "$WORDLIST_FOUND" = true ]; then
    echo -e "${GOLD}    ╔════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${GOLD}    ║  ${GREEN}𖤍 All tools are installed and ready!${GOLD}                         ║${NC}"
    echo -e "${GOLD}    ╚════════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    exit 0
fi

#───────────────────────────────────────────────────────────────────────────────
# Installation Prompt
#───────────────────────────────────────────────────────────────────────────────

echo -e "${GOLD}    ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
[ ${#MISSING[@]} -gt 0 ] && echo -e "    ${RED}${#MISSING[@]} tool(s) missing${NC}"
[ "$WORDLIST_FOUND" = false ] && echo -e "    ${RED}Wordlists missing${NC}"
echo -e "${GOLD}    ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

read -p "    Install missing items? [y/N]: " choice

if [[ ! "$choice" =~ ^[Yy]$ ]]; then
    echo -e "${GOLD}    Skipping installation.${NC}"
    exit 1
fi

#───────────────────────────────────────────────────────────────────────────────
# OS Detection
#───────────────────────────────────────────────────────────────────────────────

detect_os() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        OS=$ID
    elif [ "$(uname)" = "Darwin" ]; then
        OS="macos"
    else
        echo -e "${RED}    Cannot detect OS.${NC}"
        exit 1
    fi
}

# Start sudo keepalive before installation
start_sudo_keepalive

detect_os
echo ""
echo -e "${GOLD}    𓆲 Installing for: ${NC}$OS"
echo ""

#───────────────────────────────────────────────────────────────────────────────
# Installation Functions
#───────────────────────────────────────────────────────────────────────────────

install_go_tool() {
    local tool=$1
    local repo=$2
    
    if ! command -v "$tool" &> /dev/null; then
        echo -e "    ${GOLD}[*]${NC} Installing $tool..."
        if go install -v "$repo@latest" 2>&1 | grep -v "go: downloading" | head -n 3; then
            if command -v "$tool" &> /dev/null; then
                echo -e "        ${GREEN}𖤍 $tool installed${NC}"
            else
                # Try adding GOPATH to path
                export PATH=$PATH:$(go env GOPATH)/bin
                if command -v "$tool" &> /dev/null; then
                    echo -e "        ${GREEN}𖤍 $tool installed${NC}"
                else
                    echo -e "        ${RED}✗ $tool installation may have failed${NC}"
                fi
            fi
        fi
    fi
}

install_apt_package() {
    local pkg=$1
    if ! dpkg -l "$pkg" &> /dev/null; then
        echo -e "    ${GOLD}[*]${NC} Installing $pkg..."
        sudo apt install -y "$pkg" -qq 2>/dev/null && \
            echo -e "        ${GREEN}𖤍 $pkg installed${NC}" || \
            echo -e "        ${RED}✗ Failed to install $pkg${NC}"
    fi
}

download_wordlist_fallback() {
    local wordlist_dir="$HOME/.falconrecon/wordlists"
    echo -e "    ${GOLD}[*]${NC} Downloading wordlist from SecLists..."
    mkdir -p "$wordlist_dir"
    
    if curl -sL "https://raw.githubusercontent.com/danielmiessler/SecLists/master/Discovery/Web-Content/common.txt" \
        -o "$wordlist_dir/common.txt" 2>/dev/null; then
        echo -e "        ${GREEN}𖤍 Wordlist downloaded to $wordlist_dir/common.txt${NC}"
        WORDLIST_FOUND=true
    else
        echo -e "        ${RED}✗ Failed to download wordlist${NC}"
    fi
}

#───────────────────────────────────────────────────────────────────────────────
# OS-Specific Installation
#───────────────────────────────────────────────────────────────────────────────

case $OS in
    ubuntu|debian|kali|parrot)
        echo -e "    ${GOLD}[*]${NC} Updating package list..."
        sudo apt update -y -qq 2>/dev/null
        
        # Core packages
        for pkg in nmap jq wget dnsutils whois golang gobuster; do
            install_apt_package "$pkg"
        done
        
        # Wordlists
        if [ "$WORDLIST_FOUND" = false ]; then
            echo -e "    ${GOLD}[*]${NC} Installing wordlists..."
            sudo apt install -y wordlists seclists -qq 2>/dev/null
        fi
        ;;
        
    fedora|rhel|centos|rocky|alma)
        for pkg in nmap jq wget bind-utils whois golang gobuster; do
            echo -e "    ${GOLD}[*]${NC} Installing $pkg..."
            sudo dnf install -y "$pkg" -q 2>/dev/null || sudo yum install -y "$pkg" -q 2>/dev/null
        done
        
        # Fedora/RHEL don't package wordlists - download from SecLists
        [ "$WORDLIST_FOUND" = false ] && download_wordlist_fallback
        ;;
        
    arch|manjaro)
        for pkg in nmap jq wget bind whois go gobuster; do
            echo -e "    ${GOLD}[*]${NC} Installing $pkg..."
            sudo pacman -S --noconfirm "$pkg" 2>/dev/null
        done
        
        # Arch may not have wordlists package - try then fallback to download
        if [ "$WORDLIST_FOUND" = false ]; then
            if ! sudo pacman -S --noconfirm wordlists 2>/dev/null; then
                download_wordlist_fallback
            fi
        fi
        ;;
        
    macos)
        if ! command -v brew &> /dev/null; then
            echo -e "${RED}    Homebrew not found. Install from https://brew.sh${NC}"
            exit 1
        fi
        
        for pkg in nmap jq wget whois go gobuster; do
            echo -e "    ${GOLD}[*]${NC} Installing $pkg..."
            brew install "$pkg" 2>/dev/null
        done
        
        # macOS doesn't have packaged wordlists - download from SecLists
        [ "$WORDLIST_FOUND" = false ] && download_wordlist_fallback
        ;;
        
    *)
        echo -e "${RED}    Unsupported distro. Install manually.${NC}"
        exit 1
        ;;
esac

#───────────────────────────────────────────────────────────────────────────────
# Go Tools Installation
#───────────────────────────────────────────────────────────────────────────────

if ! command -v go &> /dev/null; then
    echo ""
    echo -e "${RED}    Go not found. Install Go for these tools:${NC}"
    echo -e "${DIM}    subfinder, httpx, gowitness, katana, nuclei${NC}"
    echo -e "${DIM}    Visit: https://go.dev/doc/install${NC}"
else
    export PATH=$PATH:$(go env GOPATH)/bin
    echo ""
    echo -e "${GOLD}    𓆲 Installing Go-based tools...${NC}"
    echo ""
    
    for tool_info in "${GO_TOOLS[@]}"; do
        tool="${tool_info%%:*}"
        repo="${tool_info#*:}"
        install_go_tool "$tool" "$repo"
    done
    
    # Update nuclei templates
    if command -v nuclei &> /dev/null; then
        echo -e "    ${GOLD}[*]${NC} Updating nuclei templates..."
        nuclei -ut -silent 2>/dev/null && \
            echo -e "        ${GREEN}𖤍 Templates updated${NC}"
    fi
fi

#───────────────────────────────────────────────────────────────────────────────
# Final Summary
#───────────────────────────────────────────────────────────────────────────────

echo ""
echo -e "${GOLD}    ╔════════════════════════════════════════════════════════════════╗${NC}"
echo -e "${GOLD}    ║  ${GREEN}𖤍 Installation Complete!${GOLD}                                      ║${NC}"
echo -e "${GOLD}    ╚════════════════════════════════════════════════════════════════╝${NC}"
echo ""

# PATH reminder
if command -v go &> /dev/null; then
    GOPATH=$(go env GOPATH)
    echo -e "${DIM}    Add Go binaries to PATH (if not already):${NC}"
    echo -e "${DIM}    echo 'export PATH=\$PATH:$GOPATH/bin' >> ~/.bashrc${NC}"
    echo -e "${DIM}    source ~/.bashrc${NC}"
    echo ""
fi

echo -e "${GOLD}    𓅃 Ready to fly! Run: ${NC}./FalconRecon.sh"
echo ""

exit 0