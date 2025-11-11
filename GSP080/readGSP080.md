# ☁️ Cloud Run Functions: Qwik Start - Command Line - GSP080

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Google Cloud](https://img.shields.io/badge/Google%20Cloud-4285F4?style=flat&logo=google-cloud&logoColor=white)](https://cloud.google.com)
[![Bash](https://img.shields.io/badge/Bash-4EAA25?style=flat&logo=gnu-bash&logoColor=white)](https://www.gnu.org/software/bash/)
[![Cloud Run Functions](https://img.shields.io/badge/Lab-Cloud%20Run%20Functions-blue?style=flat)](https://www.skills.google/games/6875/labs/42698)
[![Version](https://img.shields.io/badge/Version-V1.0-green.svg)](https://github.com/KingsukMajumdar/skill-develop-google-arcade/blob/main/GSP080/gsp080.sh)

## LAB ID: GSP080
## LAB NAME: [Cloud Run Functions: Qwik Start - Command Line](https://www.skills.google/games/6875/labs/42698)
## 🚀 Quick Start

In google console copy and paste the following command ( before executing read the code carefully [gsp080.sh](https://github.com/KingsukMajumdar/skill-develop-google-arcade/blob/main/GSP080/gsp080.sh))
```bash
curl -LO raw.githubusercontent.com/KingsukMajumdar/skill-develop-google-arcade/main/GSP080/gsp080.sh
sudo chmod +x gsp080.sh && ./gsp080.sh
```
## Note:
> [!CAUTION]
> $${\color{red}\text{If you get a service account serviceAccountTokenCreator notification select "n".}}$$
## OR

### 📥 Step 1: Download
```bash
curl -LO raw.githubusercontent.com/KingsukMajumdar/skill-develop-google-arcade/main/GSP080/gsp080.sh
```
**🔍 Explanation:**
- `curl` → Downloads files from internet
- `-L` → Follows redirects automatically
- `-O` → Saves with original filename
- Downloads `gsp080.sh` to current directory

### 🔓 Step 2: Make Executable
```bash
sudo chmod +x gsp080.sh
```
**🔍 Explanation:**
- `sudo` → Runs with admin privileges
- `chmod` → Changes file permissions
- `+x` → Adds execute permission
- Transforms file from text to executable program

### ▶️ Step 3: Execute
```bash
./gsp080.sh
```
**🔍 Explanation:**
- `./` → Current directory indicator
- Executes the script with bash interpreter
- Performs all Cloud Function operations automatically

## 📖 What This Lab Does

This script automates Google Cloud Run Functions deployment and testing:

✅ Creates Cloud Run function with Pub/Sub trigger  
✅ Deploys Node.js serverless function  
✅ Tests function with message publishing  
✅ Views execution logs automatically  
✅ Provides color-coded terminal feedback

## 🎯 Key Operations

1. **Set Region** → Configures default Cloud Run region
2. **Create Function** → Builds Node.js function with CloudEvent handler
3. **Deploy Function** → Deploys to Google Cloud with Gen2 runtime
4. **Test Function** → Publishes test message to Pub/Sub topic
5. **View Logs** → Displays function execution logs

## 🔧 Prerequisites

- ✅ Google Cloud account with active project
- ✅ Cloud Functions API enabled
- ✅ Cloud Shell access or gcloud CLI installed

## 📊 Function Architecture

```
Pub/Sub Topic (cf-demo)
         ↓
   Cloud Function
   (nodejs-pubsub-function)
         ↓
    Console Logs
```

## ⚠️ Important Notes

- Always review scripts before execution: `cat gsp080.sh`
- Uses Node.js 20 runtime (not nodejs8 from old lab)
- Function uses 2nd generation Cloud Run runtime
- Logs may take up to 10 minutes to appear

## 🐛 Troubleshooting

**Permission denied?**
```bash
chmod +x gsp080.sh
```

**Function already exists?**
```bash
gcloud functions delete nodejs-pubsub-function --region=$REGION --gen2
```

**Logs not appearing?**
```bash
# Wait 10-15 minutes, then retry
gcloud functions logs read nodejs-pubsub-function --region=$REGION
```

## 📚 Resources

- [Cloud Run Functions Documentation](https://cloud.google.com/functions/docs)
- [Node.js Runtime Guide](https://cloud.google.com/functions/docs/concepts/nodejs-runtime)
- [gcloud Reference](https://cloud.google.com/sdk/gcloud/reference/functions)


## 👨‍🏫 Author

**Kingsuk Majumdar, Ph.D (Engg)**  
Assistant Professor, Department of Electrical Engineering  
Dr. B. C. Roy Engineering College, Durgapur


🙏🏻 Thank You: **Mr. RUPAK CHATTERJEE, Mr. SUBHA SARKAR and Mr. Debayan Laha, Mr. Chanchal Bhattacharya, Mr Akash Mukherjee, Mr. Surjendu Mukherjee, Mr Tirtha Mondal and Mr Abir Kumar Laha et.all**
🌐 GitHub: [@KingsukMajumdar](https://github.com/KingsukMajumdar)  
📺 YouTube: [Learn With Kingsuk](https://youtube.com/@LearnWithKingsuk)

**Hashtags:** `#LearnWithKingsuk` `#GoogleCloud` `#CloudFunctions` `#BCREC` `#GSP080`

---

<div align="center">

**© 2025 Kingsuk Majumdar | Made with ❤️**

*"Serverless computing: Focus on code, not infrastructure."*


[![GitHub followers](https://img.shields.io/github/followers/KingsukMajumdar?style=social)](https://github.com/KingsukMajumdar)
[![YouTube Channel Subscribers](https://img.shields.io/youtube/channel/subscribers/UCo2Rho6ypq7IkxaKwByWQRA?style=social)](https://youtube.com/@LearnWithKingsuk)
</div>
