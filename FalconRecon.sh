#!/usr/bin/env bash

#═══════════════════════════════════════════════════════════════════════════════
#  𓅃 FALCON RECON v2.0 - Reconnaissance Framework
#═══════════════════════════════════════════════════════════════════════════════
#  Author: Mahmoud Elshorbagy
#  GitHub: https://github.com/falcon0x1
#  License: MIT
#═══════════════════════════════════════════════════════════════════════════════

VERSION="2.0.0"

#───────────────────────────────────────────────────────────────────────────────
# 𓆲 CONFIGURATION
#───────────────────────────────────────────────────────────────────────────────

# Colors - Egyptian Gold Theme
GOLD='\033[38;5;220m'
AMBER='\033[38;5;214m'
ORANGE='\033[38;5;208m'
RED='\033[0;31m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
DIM='\033[2m'
NC='\033[0m'
BOLD='\033[1m'

# Configuration file
CONFIG_FILE="$HOME/.falconrecon.conf"

# Default settings (can be overridden by config file)
THREADS=50
VERBOSE=false
LOG_FILE=""
CUSTOM_WORDLIST=""

# Load config if exists
load_config() {
    if [ -f "$CONFIG_FILE" ]; then
        source "$CONFIG_FILE"
        [ "$VERBOSE" = true ] && echo -e "${DIM}𓆲 Loaded config from $CONFIG_FILE${NC}"
    fi
}

#───────────────────────────────────────────────────────────────────────────────
# 𓅈 UTILITY FUNCTIONS
#───────────────────────────────────────────────────────────────────────────────

log() {
    local msg="[$(date '+%Y-%m-%d %H:%M:%S')] $1"
    [ -n "$LOG_FILE" ] && echo "$msg" >> "$LOG_FILE"
    [ "$VERBOSE" = true ] && echo -e "${DIM}$msg${NC}"
}

error() {
    echo -e "${RED}𓅃 Error: $1${NC}" >&2
    log "ERROR: $1"
    return 1
}

success() {
    echo -e "${GREEN}𖤍 $1${NC}"
    log "SUCCESS: $1"
}

info() {
    echo -e "${GOLD}𓆲 $1${NC}"
    log "INFO: $1"
}

RECON_QUOTES=(
    "Scanning the digital horizon..."
    "The falcon sees all..."
    "Mapping the target landscape..."
    "Gathering intelligence..."
    "Probing the perimeter..."
    "Reconnaissance in progress..."
    "Hunting for vulnerabilities..."
    "𓅃 Flying low, scanning high..."
)

show_quote() {
    echo -e "${DIM}${RECON_QUOTES[$RANDOM % ${#RECON_QUOTES[@]}]}${NC}"
}

#───────────────────────────────────────────────────────────────────────────────
# 🐦‍🔥 BANNER
#───────────────────────────────────────────────────────────────────────────────

show_banner() {
    clear
    echo -e "${GOLD}"
    cat << 'EOF'
    ╔══════════════════════════════════════════════════════════════════╗
    ║                                                                  ║
    ║     𓅃  ███████╗ █████╗ ██╗      ██████╗  █████╗ ███╗   ██╗      ║
    ║        ██╔════╝██╔══██╗██║     ██╔════╝██╔══██╗████╗  ██║       ║
    ║        █████╗  ███████║██║     ██║     ██║  ██║██╔██╗ ██║       ║
    ║        ██╔══╝  ██╔══██║██║     ██║     ██║  ██║██║╚██╗██║       ║
    ║        ██║     ██║  ██║███████╗╚██████╗╚█████╔╝██║ ╚████║  𓅃   ║
    ║        ╚═╝     ╚═╝  ╚═╝╚══════╝ ╚═════╝ ╚════╝ ╚═╝  ╚═══╝       ║
    ║                                                                  ║
    ║       𓆲  R E C O N N A I S S A N C E   F R A M E W O R K  𓆲    ║
    ║                                                                  ║
EOF
    echo -e "    ║              ${WHITE}🐦‍🔥 Flying low, scanning high 🐦‍🔥${GOLD}                ║"
    echo -e "    ║                          ${AMBER}v${VERSION}${GOLD}                              ║"
    echo -e "    ║                                                                  ║"
    echo -e "    ║   ${DIM}👁️ Author: Mahmoud Elshorbagy | 𖤍 github.com/falcon0x1${GOLD}     ║"
    echo -e "    ╚══════════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    show_quote
    echo ""
}

#───────────────────────────────────────────────────────────────────────────────
# 𓆲 PROGRESS INDICATOR
#───────────────────────────────────────────────────────────────────────────────

show_progress() {
    local pid=$1
    local task=${2:-"Processing"}
    local chars="𓅈𓅉𓅂𓅆𓅇𓅃"
    local i=0
    
    while kill -0 "$pid" 2>/dev/null; do
        printf "\r${GOLD}  ${chars:$i:1} ${task}...${NC}  "
        ((i = (i + 1) % ${#chars}))
        sleep 0.3
    done
    printf "\r                                        \r"
}

show_spinner() {
    local pid=$1
    local delay=0.1
    local spinstr='|/-\'
    while kill -0 "$pid" 2>/dev/null; do
        local temp=${spinstr#?}
        printf " [%c]  " "$spinstr"
        local spinstr=$temp${spinstr%"$temp"}
        sleep $delay
        printf "\b\b\b\b\b\b"
    done
    printf "    \b\b\b\b"
}

#───────────────────────────────────────────────────────────────────────────────
# 🔧 TOOL CHECKS
#───────────────────────────────────────────────────────────────────────────────

check_tool() {
    command -v "$1" &> /dev/null
}

validate_target() {
    local target="$1"
    local clean_target=$(echo "$target" | sed -e 's|^https\?://||' -e 's|^www\.||' -e 's|/.*$||')
    
    # Check if it's an IP address
    if [[ "$clean_target" =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
        return 0
    fi
    
    # Check DNS resolution
    if check_tool dig; then
        dig +short "$clean_target" A 2>/dev/null | grep -q '[0-9]' && return 0
    elif check_tool host; then
        host "$clean_target" 2>/dev/null | grep -q 'has address' && return 0
    elif check_tool nslookup; then
        nslookup "$clean_target" 2>/dev/null | grep -q 'Address:' && return 0
    fi
    
    return 1
}

get_wordlist() {
    local paths=(
        "$CUSTOM_WORDLIST"
        "/usr/share/wordlists/dirb/common.txt"
        "/usr/share/wordlists/dirbuster/directory-list-2.3-small.txt"
        "/usr/share/seclists/Discovery/Web-Content/common.txt"
        "/opt/wordlists/common.txt"
        "$HOME/.falconrecon/wordlists/common.txt"
    )
    
    for p in "${paths[@]}"; do
        [ -n "$p" ] && [ -f "$p" ] && { echo "$p"; return 0; }
    done
    
    # Offer to download if not found
    echo -e "${AMBER}   No wordlist found. Would you like to download one? [y/N]: ${NC}" >&2
    read -r download_choice
    
    if [[ "$download_choice" =~ ^[Yy]$ ]]; then
        local wordlist_dir="$HOME/.falconrecon/wordlists"
        mkdir -p "$wordlist_dir"
        
        echo -e "${DIM}   Downloading SecLists common.txt...${NC}" >&2
        if curl -sL "https://raw.githubusercontent.com/danielmiessler/SecLists/master/Discovery/Web-Content/common.txt" \
            -o "$wordlist_dir/common.txt" 2>/dev/null; then
            echo -e "${GREEN}   𖤍 Wordlist downloaded to $wordlist_dir/common.txt${NC}" >&2
            echo "$wordlist_dir/common.txt"
            return 0
        else
            error "Failed to download wordlist"
            return 1
        fi
    fi
    
    error "No wordlist available. Use --wordlist option or download manually."
    return 1
}

#───────────────────────────────────────────────────────────────────────────────
# 𓅈 SUBDOMAIN ENUMERATION
#───────────────────────────────────────────────────────────────────────────────

enum_subdomains() {
    info "𓅈 Hunting subdomains..."
    local domain=$(echo "$TARGET" | sed -e 's|^https\?://||' -e 's|^www\.||' -e 's|/.*$||')
    
    if ! check_tool subfinder; then
        error "subfinder not installed. Run setup_tools.sh"
        return 1
    fi
    
    subfinder -d "$domain" -silent -o "$RESULTS/subdomains.txt" 2>/dev/null &
    show_progress $! "Enumerating subdomains"
    wait $!
    
    if [ -s "$RESULTS/subdomains.txt" ]; then
        local count=$(wc -l < "$RESULTS/subdomains.txt")
        success "Found $count subdomains"
        echo -e "${GREEN}   📁 File: $RESULTS/subdomains.txt${NC}"
    else
        echo -e "${AMBER}   No subdomains found${NC}"
    fi
    echo ""
}

#───────────────────────────────────────────────────────────────────────────────
# 🪽 LIVE HOST DETECTION
#───────────────────────────────────────────────────────────────────────────────

find_live() {
    if [ ! -s "$RESULTS/subdomains.txt" ]; then
        error "No subdomains file. Run subdomain enumeration first."
        return 1
    fi
    
    info "🪽 Probing for live hosts..."
    
    if ! check_tool httpx || ! check_tool jq; then
        error "httpx or jq not installed. Run setup_tools.sh"
        return 1
    fi
    
    httpx -l "$RESULTS/subdomains.txt" -json -silent -sc -title -tech-detect -nc -threads "$THREADS" 2>/dev/null | \
        tee >(jq -r '.url' > "$RESULTS/live.txt") > "$RESULTS/live_details.json"
    
    if [ -s "$RESULTS/live.txt" ]; then
        local count=$(wc -l < "$RESULTS/live.txt")
        success "$count live hosts discovered"
        echo -e "${GREEN}   📁 Files: live.txt, live_details.json${NC}"
    else
        echo -e "${AMBER}   No live hosts found${NC}"
    fi
    echo ""
}

#───────────────────────────────────────────────────────────────────────────────
# 📸 SCREENSHOT CAPTURE
#───────────────────────────────────────────────────────────────────────────────

capture_screens() {
    if [ ! -s "$RESULTS/live.txt" ]; then
        error "No live hosts. Run live host detection first."
        return 1
    fi
    
    info "📸 Capturing screenshots..."
    mkdir -p "$RESULTS/screens"
    
    if ! check_tool gowitness; then
        error "gowitness not installed. Run setup_tools.sh"
        return 1
    fi
    
    gowitness scan file -f "$RESULTS/live.txt" -s "$RESULTS/screens/" --write-none --threads 5 &>/dev/null &
    show_progress $! "Capturing screenshots"
    wait $!
    
    local count=$(find "$RESULTS/screens" -type f 2>/dev/null | wc -l)
    if [ "$count" -gt 0 ]; then
        success "Captured $count screenshots"
        echo -e "${GREEN}   📁 Folder: $RESULTS/screens/${NC}"
    else
        echo -e "${AMBER}   No screenshots captured${NC}"
    fi
    echo ""
}

#───────────────────────────────────────────────────────────────────────────────
# 👁️ PORT SCANNING
#───────────────────────────────────────────────────────────────────────────────

scan_ports() {
    info "👁️ Scanning ports..."
    local scan_target=$(echo "$TARGET" | sed -e 's|^https\?://||' -e 's|^www\.||' -e 's|/.*$||')
    
    if ! check_tool nmap; then
        error "nmap not installed. Run setup_tools.sh"
        return 1
    fi
    
    echo -e "${DIM}   Running nmap -Pn -sV --top-ports 1000...${NC}"
    nmap -Pn -sV -T4 --top-ports 1000 "$scan_target" -oN "$RESULTS/ports.txt" -oX "$RESULTS/ports.xml" &>/dev/null &
    show_progress $! "Port scanning"
    wait $!
    
    if [ -s "$RESULTS/ports.txt" ]; then
        if grep -q " open " "$RESULTS/ports.txt"; then
            local open_count=$(grep -c " open " "$RESULTS/ports.txt")
            success "Found $open_count open ports"
        else
            echo -e "${AMBER}   No open ports found${NC}"
        fi
        echo -e "${GREEN}   📁 Files: ports.txt, ports.xml${NC}"
    else
        error "Port scan failed"
    fi
    echo ""
}

#───────────────────────────────────────────────────────────────────────────────
# 𓅂 DIRECTORY BRUTEFORCE
#───────────────────────────────────────────────────────────────────────────────

find_dirs() {
    local url="$1"
    
    if [ -z "$url" ] && [ -s "$RESULTS/live.txt" ]; then
        info "Select target URL:"
        mapfile -t hosts < <(sort -u "$RESULTS/live.txt")
        select c in "${hosts[@]}"; do
            [ -n "$c" ] && { url="$c"; break; }
        done
    fi
    
    [ -z "$url" ] && { error "No URL specified"; return 1; }
    
    if ! check_tool gobuster; then
        error "gobuster not installed. Run setup_tools.sh"
        return 1
    fi
    
    local wordlist=$(get_wordlist)
    [ -z "$wordlist" ] && return 1
    
    info "𓅂 Scanning directories for $url"
    local fname=$(echo "$url" | sed -e 's|https\?://||' -e 's|[:/]|_|g')
    
    gobuster dir -u "$url" -w "$wordlist" -t "$THREADS" -q -o "$RESULTS/dirs_${fname}.txt" 2>/dev/null &
    show_progress $! "Directory bruteforce"
    wait $!
    
    if [ -s "$RESULTS/dirs_${fname}.txt" ]; then
        local count=$(wc -l < "$RESULTS/dirs_${fname}.txt")
        success "Found $count directories/files"
        echo -e "${GREEN}   📁 File: dirs_${fname}.txt${NC}"
    else
        echo -e "${AMBER}   No directories found${NC}"
    fi
    echo ""
}

#───────────────────────────────────────────────────────────────────────────────
# 𓅆 TECHNOLOGY DETECTION
#───────────────────────────────────────────────────────────────────────────────

detect_tech() {
    if [ ! -s "$RESULTS/live_details.json" ]; then
        error "No live host data. Run live host detection first."
        return 1
    fi
    
    info "𓅆 Detecting technologies..."
    
    jq -r 'select(.technologies != null and (.technologies | length) > 0) | 
           "\(.url): \(.technologies | join(", "))"' \
        "$RESULTS/live_details.json" > "$RESULTS/tech_summary.txt" 2>/dev/null
    
    if [ -s "$RESULTS/tech_summary.txt" ]; then
        success "Technology stack detected:"
        echo -e "${GOLD}   ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
        while IFS= read -r line; do
            echo -e "${WHITE}   $line${NC}"
        done < "$RESULTS/tech_summary.txt"
        echo -e "${GOLD}   ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
        echo -e "${GREEN}   📁 File: tech_summary.txt${NC}"
    else
        echo -e "${AMBER}   No technologies detected${NC}"
    fi
    echo ""
}

#───────────────────────────────────────────────────────────────────────────────
# 𓅇 URL CRAWLING
#───────────────────────────────────────────────────────────────────────────────

crawl_site() {
    local url="$1"
    
    if [ -z "$url" ] && [ -s "$RESULTS/live.txt" ]; then
        info "Select URL to crawl:"
        mapfile -t hosts < <(sort -u "$RESULTS/live.txt")
        select c in "${hosts[@]}"; do
            [ -n "$c" ] && { url="$c"; break; }
        done
    fi
    
    [ -z "$url" ] && { error "No URL specified"; return 1; }
    
    if ! check_tool katana; then
        error "katana not installed. Run setup_tools.sh"
        return 1
    fi
    
    info "𓅇 Crawling $url"
    local fname=$(echo "$url" | sed -e 's|https\?://||' -e 's|[:/]|_|g')
    
    katana -u "$url" -d 3 -o "$RESULTS/urls_${fname}.txt" -jc -kf all -silent -c 20 &>/dev/null &
    show_progress $! "Crawling URLs"
    wait $!
    
    if [ -s "$RESULTS/urls_${fname}.txt" ]; then
        local count=$(wc -l < "$RESULTS/urls_${fname}.txt")
        success "Found $count URLs"
        echo -e "${GREEN}   📁 File: urls_${fname}.txt${NC}"
    else
        echo -e "${AMBER}   No URLs found${NC}"
    fi
    echo ""
}

#───────────────────────────────────────────────────────────────────────────────
# 📡 DNS RECONNAISSANCE (NEW)
#───────────────────────────────────────────────────────────────────────────────

dns_recon() {
    info "📡 DNS Reconnaissance..."
    local domain=$(echo "$TARGET" | sed -e 's|^https\?://||' -e 's|^www\.||' -e 's|/.*$||')
    
    if ! check_tool dig; then
        if ! check_tool host; then
            error "dig or host not installed"
            return 1
        fi
    fi
    
    {
        echo "═══════════════════════════════════════════════════════════════"
        echo "  𓅃 DNS RECONNAISSANCE REPORT"
        echo "  Target: $domain"
        echo "  Date: $(date)"
        echo "═══════════════════════════════════════════════════════════════"
        echo ""
        
        echo "▶ A Records (IPv4):"
        dig +short "$domain" A 2>/dev/null | sed 's/^/   /'
        echo ""
        
        echo "▶ AAAA Records (IPv6):"
        dig +short "$domain" AAAA 2>/dev/null | sed 's/^/   /'
        echo ""
        
        echo "▶ MX Records (Mail):"
        dig +short "$domain" MX 2>/dev/null | sed 's/^/   /'
        echo ""
        
        echo "▶ NS Records (Nameservers):"
        dig +short "$domain" NS 2>/dev/null | sed 's/^/   /'
        echo ""
        
        echo "▶ TXT Records:"
        dig +short "$domain" TXT 2>/dev/null | sed 's/^/   /'
        echo ""
        
        echo "▶ CNAME Records:"
        dig +short "$domain" CNAME 2>/dev/null | sed 's/^/   /'
        echo ""
        
        echo "▶ SOA Record:"
        dig +short "$domain" SOA 2>/dev/null | sed 's/^/   /'
        echo ""
        
        # WHOIS if available
        if check_tool whois; then
            echo "═══════════════════════════════════════════════════════════════"
            echo "  WHOIS INFORMATION"
            echo "═══════════════════════════════════════════════════════════════"
            echo ""
            whois "$domain" 2>/dev/null | grep -E "(Registrar|Name Server|Creation|Expir|Updated|Status)" | head -20 | sed 's/^/   /'
        fi
        
    } > "$RESULTS/dns_recon.txt"
    
    success "DNS reconnaissance complete"
    echo -e "${GREEN}   📁 File: dns_recon.txt${NC}"
    echo ""
    
    # Show summary
    echo -e "${GOLD}   ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    head -30 "$RESULTS/dns_recon.txt" | tail -25
    echo -e "${GOLD}   ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
}

#───────────────────────────────────────────────────────────────────────────────
# 🔐 VULNERABILITY SCANNING (NEW)
#───────────────────────────────────────────────────────────────────────────────

vuln_scan() {
    if [ ! -s "$RESULTS/live.txt" ]; then
        error "No live hosts. Run live host detection first."
        return 1
    fi
    
    info "🔐 Vulnerability scanning..."
    
    if ! check_tool nuclei; then
        error "nuclei not installed. Run setup_tools.sh"
        echo -e "${DIM}   Install: go install -v github.com/projectdiscovery/nuclei/v3/cmd/nuclei@latest${NC}"
        return 1
    fi
    
    echo -e "${DIM}   Running nuclei with common templates...${NC}"
    nuclei -l "$RESULTS/live.txt" -severity low,medium,high,critical -silent -o "$RESULTS/vulnerabilities.txt" 2>/dev/null &
    show_progress $! "Scanning for vulnerabilities"
    wait $!
    
    if [ -s "$RESULTS/vulnerabilities.txt" ]; then
        local count=$(wc -l < "$RESULTS/vulnerabilities.txt")
        success "Found $count potential vulnerabilities"
        echo -e "${GREEN}   📁 File: vulnerabilities.txt${NC}"
        
        # Show critical findings
        local critical=$(grep -c "\[critical\]" "$RESULTS/vulnerabilities.txt" 2>/dev/null || echo "0")
        local high=$(grep -c "\[high\]" "$RESULTS/vulnerabilities.txt" 2>/dev/null || echo "0")
        
        [ "$critical" -gt 0 ] && echo -e "${RED}   ⚠️  Critical: $critical${NC}"
        [ "$high" -gt 0 ] && echo -e "${ORANGE}   ⚠️  High: $high${NC}"
    else
        echo -e "${GREEN}   No vulnerabilities found${NC}"
    fi
    echo ""
}

#───────────────────────────────────────────────────────────────────────────────
# 📊 REPORT GENERATION (NEW)
#───────────────────────────────────────────────────────────────────────────────

generate_report() {
    info "📊 Generating HTML report..."
    
    local report="$RESULTS/report.html"
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    
    cat > "$report" << EOF
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>𓅃 FalconRecon Report - $TARGET</title>
    <style>
        :root {
            --gold: #FFD700;
            --amber: #FFBF00;
            --dark: #1a1a2e;
            --darker: #16213e;
            --card: #1f2937;
        }
        * { box-sizing: border-box; margin: 0; padding: 0; }
        body {
            font-family: 'Segoe UI', system-ui, sans-serif;
            background: linear-gradient(135deg, var(--dark), var(--darker));
            color: #e5e7eb;
            min-height: 100vh;
            padding: 2rem;
        }
        .container { max-width: 1200px; margin: 0 auto; }
        header {
            text-align: center;
            padding: 2rem;
            background: var(--card);
            border-radius: 1rem;
            margin-bottom: 2rem;
            border: 1px solid var(--gold);
        }
        h1 { color: var(--gold); font-size: 2.5rem; margin-bottom: 0.5rem; }
        .subtitle { color: var(--amber); font-size: 1.2rem; }
        .meta { color: #9ca3af; margin-top: 1rem; font-size: 0.9rem; }
        .grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(300px, 1fr)); gap: 1.5rem; }
        .card {
            background: var(--card);
            border-radius: 0.75rem;
            padding: 1.5rem;
            border: 1px solid #374151;
        }
        .card h2 { color: var(--gold); margin-bottom: 1rem; font-size: 1.25rem; }
        .stat { font-size: 2rem; color: var(--amber); font-weight: bold; }
        .stat-label { color: #9ca3af; font-size: 0.875rem; }
        pre {
            background: #111827;
            padding: 1rem;
            border-radius: 0.5rem;
            overflow-x: auto;
            font-size: 0.875rem;
            max-height: 400px;
            overflow-y: auto;
        }
        .success { color: #10b981; }
        .warning { color: #f59e0b; }
        .danger { color: #ef4444; }
        .section { margin-top: 2rem; }
        ul { list-style: none; }
        li { padding: 0.5rem 0; border-bottom: 1px solid #374151; }
        li:last-child { border-bottom: none; }
    </style>
</head>
<body>
    <div class="container">
        <header>
            <h1>𓅃 FalconRecon Report</h1>
            <p class="subtitle">Reconnaissance Framework v$VERSION</p>
            <p class="meta">Target: <strong>$TARGET</strong> | Generated: $timestamp</p>
        </header>
        
        <div class="grid">
            <div class="card">
                <h2>📊 Summary</h2>
                <div class="stat">${SUBDOMAIN_COUNT:-0}</div>
                <div class="stat-label">Subdomains Found</div>
                <br>
                <div class="stat">${LIVE_COUNT:-0}</div>
                <div class="stat-label">Live Hosts</div>
            </div>
            
            <div class="card">
                <h2>🔐 Security</h2>
                <div class="stat ${VULN_COUNT:-0 > 0 ? 'danger' : 'success'}">${VULN_COUNT:-0}</div>
                <div class="stat-label">Vulnerabilities Found</div>
                <br>
                <div class="stat">${PORT_COUNT:-0}</div>
                <div class="stat-label">Open Ports</div>
            </div>
        </div>
        
        <div class="section">
            <div class="card">
                <h2>𓅈 Subdomains</h2>
                <pre>$([ -f "$RESULTS/subdomains.txt" ] && head -50 "$RESULTS/subdomains.txt" || echo "No data")</pre>
            </div>
        </div>
        
        <div class="section">
            <div class="card">
                <h2>🪽 Live Hosts</h2>
                <pre>$([ -f "$RESULTS/live.txt" ] && cat "$RESULTS/live.txt" || echo "No data")</pre>
            </div>
        </div>
        
        <div class="section">
            <div class="card">
                <h2>👁️ Open Ports</h2>
                <pre>$([ -f "$RESULTS/ports.txt" ] && grep -E "^[0-9]|open|PORT" "$RESULTS/ports.txt" | head -30 || echo "No data")</pre>
            </div>
        </div>
        
        <div class="section">
            <div class="card">
                <h2>𓅆 Technologies</h2>
                <pre>$([ -f "$RESULTS/tech_summary.txt" ] && cat "$RESULTS/tech_summary.txt" || echo "No data")</pre>
            </div>
        </div>
        
        <div class="section">
            <div class="card">
                <h2>📡 DNS Records</h2>
                <pre>$([ -f "$RESULTS/dns_recon.txt" ] && cat "$RESULTS/dns_recon.txt" || echo "No data")</pre>
            </div>
        </div>
        
        <footer style="text-align: center; margin-top: 2rem; color: #6b7280;">
            <p>𓅃 FalconRecon v$VERSION | Created by Mahmoud Elshorbagy</p>
            <p>🐦‍🔥 Flying low, scanning high 🐦‍🔥</p>
        </footer>
    </div>
</body>
</html>
EOF
    
    success "Report generated"
    echo -e "${GREEN}   📁 File: report.html${NC}"
    echo -e "${DIM}   Open in browser: file://$RESULTS/report.html${NC}"
    echo ""
}

#───────────────────────────────────────────────────────────────────────────────
# 🐦‍🔥 FULL AUTO SCAN
#───────────────────────────────────────────────────────────────────────────────

full_scan() {
    echo -e "${GOLD}"
    echo "    ╔════════════════════════════════════════════════════════════╗"
    echo "    ║   🐦‍🔥 INITIATING FULL RECONNAISSANCE 🐦‍🔥                     ║"
    echo "    ╚════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
    
    log "Starting full scan on $TARGET"
    
    # Phase 1: Information Gathering
    dns_recon
    enum_subdomains
    find_live
    
    # Phase 2: Active Scanning (parallel)
    if [ -s "$RESULTS/live.txt" ]; then
        capture_screens &
        local screen_pid=$!
        
        scan_ports
        detect_tech
        
        # Directory scanning for first 5 hosts
        local count=0
        while IFS= read -r host && [ $count -lt 5 ]; do
            find_dirs "$host"
            ((count++))
        done < "$RESULTS/live.txt"
        
        wait $screen_pid 2>/dev/null
        
        # Vulnerability scan
        vuln_scan
    else
        scan_ports
    fi
    
    # Phase 3: Report
    # Set stats for report
    SUBDOMAIN_COUNT=$([ -f "$RESULTS/subdomains.txt" ] && wc -l < "$RESULTS/subdomains.txt" || echo "0")
    LIVE_COUNT=$([ -f "$RESULTS/live.txt" ] && wc -l < "$RESULTS/live.txt" || echo "0")
    VULN_COUNT=$([ -f "$RESULTS/vulnerabilities.txt" ] && wc -l < "$RESULTS/vulnerabilities.txt" || echo "0")
    PORT_COUNT=$([ -f "$RESULTS/ports.txt" ] && grep -c " open " "$RESULTS/ports.txt" 2>/dev/null || echo "0")
    export SUBDOMAIN_COUNT LIVE_COUNT VULN_COUNT PORT_COUNT
    
    generate_report
    
    echo -e "${GOLD}"
    echo "    ╔════════════════════════════════════════════════════════════╗"
    echo "    ║   𓅃 RECONNAISSANCE COMPLETE 𓅃                              ║"
    echo "    ╚════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
    
    show_summary
}

#───────────────────────────────────────────────────────────────────────────────
# 𖤍 SUMMARY
#───────────────────────────────────────────────────────────────────────────────

show_summary() {
    echo ""
    echo -e "${GOLD}    ╔════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${GOLD}    ║          𖤍 RECONNAISSANCE SUMMARY 𖤍                        ║${NC}"
    echo -e "${GOLD}    ╚════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "    ${WHITE}Target:${NC} $TARGET"
    echo -e "    ${WHITE}Results:${NC} $RESULTS"
    echo ""
    
    # Status checks
    [ -f "$RESULTS/subdomains.txt" ] && \
        echo -e "    ${GREEN}𖤍 Subdomains:${NC} $(wc -l < "$RESULTS/subdomains.txt")" || \
        echo -e "    ${RED}✗ Subdomains:${NC} Not scanned"
    
    [ -f "$RESULTS/live.txt" ] && \
        echo -e "    ${GREEN}𖤍 Live hosts:${NC} $(wc -l < "$RESULTS/live.txt")" || \
        echo -e "    ${RED}✗ Live hosts:${NC} Not scanned"
    
    [ -d "$RESULTS/screens" ] && [ "$(find "$RESULTS/screens" -type f 2>/dev/null | wc -l)" -gt 0 ] && \
        echo -e "    ${GREEN}𖤍 Screenshots:${NC} $(find "$RESULTS/screens" -type f | wc -l)" || \
        echo -e "    ${RED}✗ Screenshots:${NC} Not captured"
    
    [ -f "$RESULTS/ports.txt" ] && \
        echo -e "    ${GREEN}𖤍 Ports:${NC} Scanned" || \
        echo -e "    ${RED}✗ Ports:${NC} Not scanned"
    
    [ -n "$(find "$RESULTS" -name 'dirs_*.txt' -print -quit 2>/dev/null)" ] && \
        echo -e "    ${GREEN}𖤍 Directories:${NC} Scanned" || \
        echo -e "    ${RED}✗ Directories:${NC} Not scanned"
    
    [ -f "$RESULTS/tech_summary.txt" ] && \
        echo -e "    ${GREEN}𖤍 Technologies:${NC} Detected" || \
        echo -e "    ${RED}✗ Technologies:${NC} Not scanned"
    
    [ -n "$(find "$RESULTS" -name 'urls_*.txt' -print -quit 2>/dev/null)" ] && \
        echo -e "    ${GREEN}𖤍 URLs:${NC} Crawled" || \
        echo -e "    ${RED}✗ URLs:${NC} Not crawled"
    
    [ -f "$RESULTS/dns_recon.txt" ] && \
        echo -e "    ${GREEN}𖤍 DNS:${NC} Scanned" || \
        echo -e "    ${RED}✗ DNS:${NC} Not scanned"
    
    [ -f "$RESULTS/vulnerabilities.txt" ] && \
        echo -e "    ${GREEN}𖤍 Vulns:${NC} $(wc -l < "$RESULTS/vulnerabilities.txt") found" || \
        echo -e "    ${RED}✗ Vulns:${NC} Not scanned"
    
    [ -f "$RESULTS/report.html" ] && \
        echo -e "    ${GREEN}𖤍 Report:${NC} Generated" || \
        echo -e "    ${RED}✗ Report:${NC} Not generated"
    
    echo ""
    echo -e "${GOLD}    ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
}

#───────────────────────────────────────────────────────────────────────────────
# ⚙️ SETTINGS
#───────────────────────────────────────────────────────────────────────────────

show_settings() {
    echo ""
    echo -e "${GOLD}    ╔════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${GOLD}    ║               ⚙️  SETTINGS                                  ║${NC}"
    echo -e "${GOLD}    ╚════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "    ${WHITE}Current Configuration:${NC}"
    echo -e "    ─────────────────────────────────────"
    echo -e "    Threads:        ${CYAN}$THREADS${NC}"
    echo -e "    Verbose:        ${CYAN}$VERBOSE${NC}"
    echo -e "    Log File:       ${CYAN}${LOG_FILE:-Not set}${NC}"
    echo -e "    Wordlist:       ${CYAN}${CUSTOM_WORDLIST:-Auto-detect}${NC}"
    echo -e "    Config File:    ${CYAN}$CONFIG_FILE${NC}"
    echo ""
    
    echo -e "    ${WHITE}Create/Edit config file?${NC} (y/N): "
    read -r choice
    
    if [[ "$choice" =~ ^[Yy]$ ]]; then
        cat > "$CONFIG_FILE" << EOF
# 𓅃 FalconRecon Configuration
# ═══════════════════════════════════════

# Thread count for parallel operations
THREADS=50

# Enable verbose logging
VERBOSE=false

# Log file path (empty = no logging)
LOG_FILE=""

# Custom wordlist path
CUSTOM_WORDLIST=""
EOF
        success "Config created at $CONFIG_FILE"
        echo -e "${DIM}    Edit with: nano $CONFIG_FILE${NC}"
    fi
    echo ""
}

#───────────────────────────────────────────────────────────────────────────────
# 𓅃 MENU
#───────────────────────────────────────────────────────────────────────────────

show_menu() {
    echo -e "${GOLD}"
    cat << 'EOF'
    ╔══════════════════════════════════════════════════════════════════╗
    ║  𓅃  F A L C O N   R E C O N                                      ║
    ╠══════════════════════════════════════════════════════════════════╣
EOF
    echo -e "    ║                                                                  ║"
    echo -e "    ║  ${WHITE}𓆲 RECONNAISSANCE MODULES${GOLD}                                       ║"
    echo -e "    ║  ─────────────────────────────────────────────────────          ║"
    echo -e "    ║   ${CYAN}[1]${GOLD} 🐦‍🔥 Full Auto Scan      ${CYAN}[6]${GOLD} 𓅂 Directory Brute            ║"
    echo -e "    ║   ${CYAN}[2]${GOLD} 𓅈 Subdomain Hunter     ${CYAN}[7]${GOLD} 𓅆 Tech Detection             ║"
    echo -e "    ║   ${CYAN}[3]${GOLD} 🪽 Live Host Probe      ${CYAN}[8]${GOLD} 𓅇 URL Crawler                ║"
    echo -e "    ║   ${CYAN}[4]${GOLD} 📸 Screenshot Capture   ${CYAN}[9]${GOLD} 🔐 Vuln Scan                  ║"
    echo -e "    ║   ${CYAN}[5]${GOLD} 👁️ Port Scanner         ${CYAN}[10]${GOLD} 📡 DNS Recon                 ║"
    echo -e "    ║                                                                  ║"
    echo -e "    ║  ${WHITE}𓆲 UTILITIES${GOLD}                                                     ║"
    echo -e "    ║  ─────────────────────────────────────────────────────          ║"
    echo -e "    ║   ${CYAN}[11]${GOLD} 📊 Generate Report     ${CYAN}[12]${GOLD} 𖤍 View Summary               ║"
    echo -e "    ║   ${CYAN}[13]${GOLD} ⚙️  Settings            ${CYAN}[0]${GOLD} 🚪 Exit                       ║"
    echo -e "    ║                                                                  ║"
    echo -e "    ╚══════════════════════════════════════════════════════════════════╝${NC}"
    echo ""
}

#═══════════════════════════════════════════════════════════════════════════════
# 𓅃 MAIN EXECUTION
#═══════════════════════════════════════════════════════════════════════════════

main() {
    load_config
    show_banner
    
    # Setup check
    if [ -f "./setup_tools.sh" ]; then
        echo -e "${GOLD}𓆲 Checking required tools...${NC}"
        if ! bash ./setup_tools.sh --check 2>/dev/null; then
            echo -e "${AMBER}Some tools may be missing. Run setup_tools.sh to install.${NC}"
        fi
        echo ""
    fi
    
    # Get target
    echo -e "${GOLD}𓆲 Enter your target domain:${NC}"
    read -p "   𓅃 0x1 ⌁ " TARGET
    
    [ -z "$TARGET" ] && { error "No target specified. Exiting..."; exit 1; }
    
    # Validate target
    echo -e "${DIM}   Validating target...${NC}"
    if ! validate_target "$TARGET"; then
        echo -e "${AMBER}   Warning: Could not resolve target. Proceeding anyway...${NC}"
    fi
    
    # Setup results directory
    CLEAN_NAME=$(echo "$TARGET" | sed -e 's|^https\?://||' -e 's|^www\.||' -e 's|/.*$||' -e 's|[^a-zA-Z0-9._-]|_|g')
    RESULTS="results/${CLEAN_NAME}"
    mkdir -p "$RESULTS"
    
    # Setup logging
    LOG_FILE="$RESULTS/falconrecon.log"
    
    echo ""
    info "Target: $TARGET"
    info "Results: $RESULTS"
    echo ""
    
    log "Session started for $TARGET"
    
    # Main menu loop
    while true; do
        show_menu
        echo -ne "${GOLD}   𓅉 Select option: ${NC}"
        read -r opt
        
        case $opt in
            1) full_scan ;;
            2) enum_subdomains ;;
            3) find_live ;;
            4) capture_screens ;;
            5) scan_ports ;;
            6) find_dirs ;;
            7) detect_tech ;;
            8) crawl_site ;;
            9) vuln_scan ;;
            10) dns_recon ;;
            11) generate_report ;;
            12) show_summary ;;
            13) show_settings ;;
            0) 
                echo ""
                echo -e "${GOLD}   𓅃 Exiting FalconRecon. Goodbye! 𓅃${NC}"
                echo -e "${DIM}   🐦‍🔥 Flying low, scanning high 🐦‍🔥${NC}"
                echo ""
                exit 0
                ;;
            *) 
                echo -e "${RED}   Invalid option. Try again.${NC}"
                ;;
        esac
        
        echo -e "${DIM}   Press Enter to continue...${NC}"
        read -r
        show_banner
    done
}

# Run main
main "$@"
