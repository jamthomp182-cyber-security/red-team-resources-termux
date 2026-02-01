# 🛡️ Attacker Tools Installer Script

This repository contains a Bash script that automatically downloads, organizes, installs, and archives a large collection of open‑source penetration‑testing and security‑assessment tools.

The script:

- ✅ Runs only as a non‑root user for safety  
- ✅ Checks required dependencies  
- ✅ Clones tools from GitHub  
- ✅ Organizes them by category  
- ✅ Runs install scripts when present  
- ✅ Zips each tool directory  
- ✅ Logs everything to install_log.txt  
- ✅ Calculates total disk usage  

---

## 📂 Directory Layout

All tools are installed into:

~/attacker_tools/

Inside that folder, tools are grouped by category:

attacker_tools/
├── web_app_security/
│   ├── sqlmap/
│   ├── nikto/
│   └── sqlmap.zip
├── reconnaissance/
├── password_cracking/
├── vulnerability_scanning/
└── install_log.txt

---

## ⚙️ Requirements

Before running the script, ensure the following tools are installed:

- git
- zip
- python3

On Termux:

pkg install git zip python

---

## 🚀 Usage

Clone this repository:

git clone https://github.com/jamthomp182-cyber-security/red-team-resources-termux.git
cd red-team-resources-termux

Make the script executable:

chmod +x install_tools.sh  

Run it as a normal user (not root):

./install_tools.sh  

❗ If you try to run as root, the script will exit for safety.

---

## 🧰 Included Tools

The script installs a wide range of tools including:

- sqlmap  
- aircrack‑ng  
- Metasploit Framework  
- Nikto  
- Amass  
- Gobuster  
- Hashcat  
- John the Ripper  
- Recon‑ng  
- BeEF  
- OpenVAS  
- Nessus  
- WPScan  
- XSSer  
- W3af  
- WebGoat  

…and many more.

Each tool entry includes:

- Repository URL  
- Approximate size  
- Category  

---

## 📝 Logging

All activity is recorded in:

install_log.txt

This includes:

- Successful clones  
- Failed installs  
- Zip creation  
- Total disk usage  

---

## 💾 Disk Space Warning

⚠️ This script downloads several very large projects.  
Some tools exceed 300MB, and the full run can require multiple gigabytes of disk space.

Make sure you have:

- Enough storage
- A stable internet connection

---

## 🔒 Security Notes

- The script refuses to run as root.
- No privilege escalation is performed.
- Review the code before executing.
- Only use these tools on systems you own or have permission to test.

---

## 📌 Customizing the Tool List

You can add or remove tools in the tools array:

"toolname | https://github.com/example/tool.git | ~5 MB | category"

Format:

NAME | GIT_URL | SIZE | CATEGORY

---

## ⚠️ Legal Disclaimer

This project is for educational and authorized security testing only.

You are responsible for complying with all applicable laws.  
The author assumes no liability for misuse or damage caused by this script.

---

## 🤝 Contributing

Pull requests are welcome.

Ideas:

- Add more tools
- Improve error handling
- Add distro detection
- Add package auto‑install
- Add resume‑from‑failure support

---

## ⭐ Star the Repo

If you find this useful, consider starring the repository so others can find it 👍
