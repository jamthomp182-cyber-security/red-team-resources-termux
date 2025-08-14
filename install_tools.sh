#!/bin/bash

# Security Check: Ensure the script is run as a non-root user
if [ "$(id -u)" -eq 0 ]; then
    echo "This script should not be run as root. Please run as a normal user." >&2
    exit 1
fi

# Security Check: Ensure necessary tools are installed
required_tools=("git" "zip" "python3")
for tool in "${required_tools[@]}"; do
    if ! command -v "$tool" &> /dev/null; then
        echo "Error: $tool is not installed. Please install it before running this script." >&2
        exit 1
    fi
done

# Create a base directory for the tools
base_dir="$HOME/attacker_tools"
mkdir -p "$base_dir"
cd "$base_dir" || { echo "Failed to create or enter directory $base_dir"; exit 1; }

# Log file
log_file="install_log.txt"
echo "Installation Log - $(date)" > "$log_file"

# Function to install a tool
install_tool() {
    local name="$1"
    local git_url="$2"
    local size="$3"
    local category="$4"

    # Extract size in MB for display
    local size_in_mb="${size// MB/}"
    echo "Installing $name from $git_url... (Size: $size_in_mb MB)" | tee -a "$log_file"

    # Create category directory if it doesn't exist
    local category_dir="$base_dir/$category"
    mkdir -p "$category_dir"

    # Clone the repository into the category directory
    if git clone "$git_url" "$category_dir/$name"; then
        echo "Successfully cloned $name." | tee -a "$log_file"
    else
        echo "Failed to clone $name." | tee -a "$log_file"
        return
    fi

    # Navigate into the tool's directory
    cd "$category_dir/$name" || { echo "Failed to enter directory $name"; return; }

    # Check if there's an installation script or instructions
    if [ -f "install.sh" ]; then
        if bash install.sh; then
            echo "Successfully installed $name." | tee -a "$log_file"
        else
            echo "Installation script failed for $name." | tee -a "$log_file"
        fi
    elif [ -f "setup.py" ]; then
        if python3 setup.py install; then
            echo "Successfully installed $name." | tee -a "$log_file"
        else
            echo "Setup script failed for $name." | tee -a "$log_file"
        fi
    else
        echo "No installation script found for $name. Please check the repository." | tee -a "$log_file"
    fi

    # Zip the tool's directory
    cd "$category_dir" || return
    zip -r "${name}.zip" "$name" && echo "Zipped $name into ${name}.zip." | tee -a "$log_file"

    # Go back to the base directory
    cd "$base_dir" || return
}

# List of tools to install (add more tools in the same format)
tools=(
    "sqlmap | https://github.com/sqlmapproject/sqlmap.git | ~2 MB | web_app_security"
    "aircrack-ng | https://github.com/aircrack-ng/aircrack-ng.git | ~5 MB | wireless_security"
    "nikto | https://github.com/sullo/nikto.git | ~1 MB | web_app_security"
    "metasploit | https://github.com/rapid7/metasploit-framework.git | ~300 MB | penetration_testing"
    "Veil-Evasion | https://github.com/Veil-Framework/Veil-Evasion.git | ~10 MB | evasion"
    "masscan | https://github.com/robertdavidgraham/masscan.git | ~1 MB | network_scanning"
    "OpenSnitch | https://github.com/evilsocket/opensnitch.git | ~50 MB | firewall"
    "Amass | https://github.com/OWASP/Amass.git | ~20 MB | reconnaissance"
    "sslscan | https://github.com/niklasb/sslscan.git | ~1 MB | ssl_scanning"
    "Empire | https://github.com/EmpireProject/Empire.git | ~20 MB | post_exploitation"
    "Burp Suite | https://github.com/s0md3v/BurpSuite-Extensions.git | ~5 MB | web_app_security"
    "dnsrecon | https://github.com/darkoperator/dnsrecon.git | ~1 MB | dns_recon"
    "wpscan | https://github.com/wpscanteam/wpscan.git | ~5 MB | wordpress_security"
    "gobuster | https://github.com/OJ/gobuster.git | ~2 MB | directory_brute_forcing"
    "hashcat | https://github.com/hashcat/hashcat.git | ~10 MB | password_cracking"
    "john | https://github.com/openwall/john.git | ~5 MB | password_cracking"
    "recon-ng | https://github.com/lanmaster53/recon-ng.git | ~10 MB | reconnaissance"
    "setoolkit | https://github.com/trustedsec/social-engineer-toolkit.git | ~5 MB | social_engineering"
    "feroxbuster | https://github.com/epi052/feroxbuster.git | ~2 MB | directory_brute_forcing"
    "Arachni | https://github.com/Arachni/arachni.git | ~50 MB | web_app_security"
    "BeEF | https://github.com/beefproject/beef.git | ~10 MB | browser_exploitation"
    "Cewl | https://github.com/digininja/CeWL.git | ~1 MB | word_list_generator"
    "Dmitry | https://github.com/jaygreig/dmitry.git | ~1 MB | information_gathering"
    "Evil-WinRM | https://github.com/Hackplayers/evil-winrm.git | ~1 MB | remote_management"
    "Faraday | https://github.com/infobyte/faraday.git | ~50 MB | collaborative_pen_testing"
    "Giskard | https://github.com/0x00-0x00/giskard.git | ~2 MB | network_security"
    "Joomscan | https://github.com/rezasp/joomscan.git | ~1 MB | joomla_scanning"
    "Maltego | https://github.com/paterva/maltego-trx.git | ~100 MB | osint"
    "Nessus | https://github.com/tenable/nessus.git | ~200 MB | vulnerability_scanning"
    "OpenVAS | https://github.com/greenbone/openvas.git | ~300 MB | vulnerability_scanning"
    "Pipenv | https://github.com/pypa/pipenv.git | ~5 MB | dependency_management"
    "Snyk | https://github.com/snyk/snyk.git | ~5 MB | security_scanning"
    "Subjack | https://github.com/haccer/subjack.git | ~1 MB | subdomain_takeover"
    "Tenable.io | https://github.com/tenable/Tenable.io.git | ~200 MB | vulnerability_management"
    "W3af | https://github.com/andresriancho/w3af.git | ~50 MB | web_app_security"
    "WebGoat | https://github.com/WebGoat/WebGoat.git | ~100 MB | web_app_security_training"
    "XSSer | https://github.com/epsylon/xsser.git | ~1 MB | xss_exploitation"
)


# Loop through each tool and install
total_size=0
for tool_info in "${tools[@]}"; do
    IFS=' | ' read -r name git_url size category <<< "$tool_info"
    install_tool "$name" "$git_url" "$size" "$category"

    # Extract size in MB and add to total size
    size_in_mb="${size// MB/}"
    total_size=$((total_size + size_in_mb))
done

# Display total space used
echo "Total space used: $total_size MB" | tee -a "$log_file"

echo "All installations complete." | tee -a "$log_file"

