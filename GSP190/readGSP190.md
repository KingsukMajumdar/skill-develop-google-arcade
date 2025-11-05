# 🔐 IAM Custom Roles Lab - GSP190

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Google Cloud](https://img.shields.io/badge/Google%20Cloud-4285F4?style=flat&logo=google-cloud&logoColor=white)](https://cloud.google.com)
[![Bash](https://img.shields.io/badge/Bash-4EAA25?style=flat&logo=gnu-bash&logoColor=white)](https://www.gnu.org/software/bash/)
[![IAM Custom Roles](https://img.shields.io/badge/Lab-IAM%20Custom%20Roles-blue?style=flat)](https://www.skills.google/games/6874/labs/42691)
[![Version](https://img.shields.io/badge/Version-V1.0-green.svg)](https://github.com/KingsukMajumdar/skill-develop-google-arcade/blob/main/GSP190/gsp190.sh)

## LAB ID: GSP190
## LAB NAME: [IAM Custom Roles](https://www.skills.google/games/6874/labs/42691)
## 🚀 Quick Start

In google console copy and paste the following command ( before executing read the code carefully [gsp190.sh](https://github.com/KingsukMajumdar/skill-develop-google-arcade/blob/main/GSP190/gsp190.sh))
```bash
curl -LO raw.githubusercontent.com/KingsukMajumdar/skill-develop-google-arcade/main/GSP190/gsp190.sh
sudo chmod +x gsp190.sh && ./gsp190.sh
```
## OR

### 📥 Step 1: Download
```bash
curl -LO raw.githubusercontent.com/KingsukMajumdar/skill-develop-google-arcade/main/GSP190/gsp190.sh
```
**🔍 Explanation:**
- `curl` → Downloads files from internet
- `-L` → Follows redirects automatically
- `-O` → Saves with original filename
- Downloads `gsp190.sh` to current directory

### 🔓 Step 2: Make Executable
```bash
sudo chmod +x gsp190.sh
```
**🔍 Explanation:**
- `sudo` → Runs with admin privileges
- `chmod` → Changes file permissions
- `+x` → Adds execute permission
- Transforms file from text to executable program

### ▶️ Step 3: Execute
```bash
./gsp190.sh
```
**🔍 Explanation:**
- `./` → Current directory indicator
- Executes the script with bash interpreter
- Performs all IAM operations automatically

## 📖 What This Lab Does

This script automates Google Cloud IAM custom role management:

✅ Creates custom "editor" and "viewer" IAM roles  
✅ Updates roles with additional permissions  
✅ Demonstrates role lifecycle (disable/delete/restore)  
✅ Generates YAML configuration files  
✅ Provides color-coded terminal feedback

## 🎯 Key Operations

1. **Create Roles** → Defines custom roles with specific permissions
2. **Update Roles** → Adds storage permissions incrementally
3. **Disable Role** → Sets viewer role to DISABLED state
4. **Delete Role** → Soft-deletes with 7-day recovery window
5. **Restore Role** → Undeletes the viewer role

## 🔧 Prerequisites

- ✅ Google Cloud account with active project
- ✅ IAM role creation permissions
- ✅ Cloud Shell access or gcloud CLI installed

## 📊 Role Lifecycle Stages

🔵 **ALPHA** → 🟣 **BETA** → 🟢 **GA** → 🟠 **DEPRECATED** → 🔴 **DISABLED** → ⚫ **DELETED**

## ⚠️ Important Notes

- Always review scripts before execution: `cat gsp190.sh`
- Custom roles follow principle of least privilege
- Deleted roles recoverable within 7 days
- Test in non-production environments first

## 🐛 Troubleshooting

**Permission denied?**
```bash
chmod +x gsp190.sh
```

**Role exists?**
```bash
gcloud iam roles delete viewer --project $DEVSHELL_PROJECT_ID
```

## 📚 Resources

- [IAM Documentation](https://cloud.google.com/iam/docs)
- [Custom Roles Guide](https://cloud.google.com/iam/docs/creating-custom-roles)
- [gcloud Reference](https://cloud.google.com/sdk/gcloud/reference/iam/roles)


## 👨‍🏫 Author

**Kingsuk Majumdar, Ph.D (Engg)**  
Assistant Professor, Department of Electrical Engineering  
Dr. B. C. Roy Engineering College, Durgapur


🙏🏻 Thank You: **Mr. RUPAK CHATTERJEE**, **Mr. SUBHA SARKAR** etc **all of you**   
🌐 GitHub: [@KingsukMajumdar](https://github.com/KingsukMajumdar)  
📺 YouTube: [Learn With Kingsuk](https://youtube.com/@LearnWithKingsuk)

**Hashtags:** `#LearnWithKingsuk` `#GoogleCloud` `#IAM` `#BCREC` `GSP190`

---

<div align="center">

**© 2025 Kingsuk Majumdar | Made with ❤️**

*"Access control is about saying yes to the right people at the right time."*

</div>
