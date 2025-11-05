# 📄 Build a Serverless App with Cloud Run that Creates PDF Files - GSP644

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Google Cloud](https://img.shields.io/badge/Google%20Cloud-4285F4?style=flat&logo=google-cloud&logoColor=white)](https://cloud.google.com)
[![Bash](https://img.shields.io/badge/Bash-4EAA25?style=flat&logo=gnu-bash&logoColor=white)](https://www.gnu.org/software/bash/)
[![Cloud Run PDF](https://img.shields.io/badge/Lab-Cloud%20Run%20PDF-blue?style=flat)](https://www.skills.google/games/6875/labs/42699)
[![Version](https://img.shields.io/badge/Version-V1.0-green.svg)](https://github.com/KingsukMajumdar/skill-develop-google-arcade/blob/main/GSP644/gsp644.sh)

## LAB ID: GSP644
## LAB NAME: [Build a Serverless App with Cloud Run that Creates PDF Files](https://www.skills.google/games/6875/labs/42699)

## 🚀 Quick Start

### Step 1: Export Region Variable
```bash
export REGION=us-east1
```
**Note:** Replace `us-east1` with your preferred region (e.g., `us-central1`, `europe-west1`, `asia-south1`)

### Step 2: Run Automated Script

In google console copy and paste the following command (before executing read the code carefully [gsp644.sh](https://github.com/KingsukMajumdar/skill-develop-google-arcade/blob/main/GSP644/gsp644.sh))
```bash
curl -LO raw.githubusercontent.com/KingsukMajumdar/skill-develop-google-arcade/main/GSP644/gsp644.sh
sudo chmod +x gsp644.sh
./gsp644.sh
```
## OR

### 📥 Step 1: Download
```bash
curl -LO raw.githubusercontent.com/KingsukMajumdar/skill-develop-google-arcade/main/GSP644/gsp644.sh
```
**🔍 Explanation:**
- `curl` → Downloads files from internet
- `-L` → Follows redirects automatically
- `-O` → Saves with original filename
- Downloads `gsp644.sh` to current directory

### 🔓 Step 2: Make Executable
```bash
sudo chmod +x gsp644.sh
```
**🔍 Explanation:**
- `sudo` → Runs with admin privileges
- `chmod` → Changes file permissions
- `+x` → Adds execute permission
- Transforms file from text to executable program

### ▶️ Step 3: Execute
```bash
./gsp644.sh
```
**🔍 Explanation:**
- `./` → Current directory indicator
- Executes the script with bash interpreter
- Automates entire Cloud Run PDF converter deployment

## 📖 What This Lab Does

This script automates the deployment of a serverless PDF conversion application using Google Cloud Run:

✅ Deploys containerized Node.js application with LibreOffice  
✅ Configures Cloud Storage buckets for file processing  
✅ Sets up Pub/Sub event-driven architecture  
✅ Implements IAM permissions for service authentication  
✅ Automatically converts uploaded documents to PDF format

## 🎯 Key Operations

1. **Cloud Run Service** → Deploys containerized PDF converter with LibreOffice
2. **Cloud Storage** → Creates upload and processed buckets for file management
3. **Pub/Sub Integration** → Triggers automatic conversion on file upload
4. **IAM Configuration** → Sets up secure service account permissions
5. **Document Processing** → Converts multiple formats to PDF automatically

## 🔧 Prerequisites

- ✅ Google Cloud account with active project
- ✅ Cloud Run, Cloud Build, Pub/Sub, Storage APIs enabled
- ✅ Cloud Shell access or gcloud CLI installed
- ✅ Sufficient IAM permissions (Editor or Owner role)

## 📊 Architecture Flow

🗂️ **Upload File** → ☁️ **Cloud Storage** → 📢 **Pub/Sub** → 🚀 **Cloud Run** → 📄 **PDF Conversion** → ☁️ **Processed Storage**

## ⚠️ Important Notes

- Always review scripts before execution: `cat gsp644.sh`
- LibreOffice requires 2Gi memory for conversion
- Original files deleted after successful conversion
- Service requires authentication via IAM
- Test in non-production environments first

## 🐛 Troubleshooting

**Permission denied?**
```bash
chmod +x gsp644.sh
```

**Service not accessible?**
```bash
gcloud run services get-iam-policy pdf-converter --platform managed --region $REGION
```

**Files not converting?**
```bash
gcloud logging read "resource.type=cloud_run_revision AND resource.labels.service_name=pdf-converter" --limit 50
```

## 🧪 Manual Testing (After Script Completion)

### Test 1: Verify Service Deployment
```bash
curl -X POST -H "Authorization: Bearer $(gcloud auth print-identity-token)" $SERVICE_URL
```
**Expected Response:** `OK`

### Test 2: Upload Files with Delay Script
```bash
cat <<'EOF' > copy_files.sh
#!/bin/bash

SOURCE_BUCKET="gs://spls/gsp644"
DESTINATION_BUCKET="gs://${GOOGLE_CLOUD_PROJECT}-upload"
DELAY=5

# Get a list of files in the source bucket
files=$(gsutil ls "$SOURCE_BUCKET")

# Loop through the files
for file in $files; do
  source_file_path="$file"
  gsutil cp "$source_file_path" "$DESTINATION_BUCKET"
  
  if [ $? -eq 0 ]; then
    echo "Copied: $source_file_path to $DESTINATION_BUCKET"
  else
    echo "Failed to copy: $source_file_path"
  fi
  
  sleep $DELAY
done

echo "All files copied!"
EOF

bash copy_files.sh
```

### Test 3: Verify PDF Conversion
1. Navigate to Cloud Storage in Console
2. Check `[PROJECT_ID]-upload` bucket (files disappear as converted)
3. Check `[PROJECT_ID]-processed` bucket (PDF files appear)
4. Download and verify PDF files

## 📚 Resources

- [Cloud Run Documentation](https://cloud.google.com/run/docs)
- [Pub/Sub Push Subscriptions](https://cloud.google.com/pubsub/docs/push)
- [Cloud Storage Notifications](https://cloud.google.com/storage/docs/pubsub-notifications)
- [LibreOffice Headless Mode](https://help.libreoffice.org/latest/en-US/text/shared/guide/start_parameters.html)

## 👨‍🏫 Author

**Kingsuk Majumdar, Ph.D (Engg)**  
Assistant Professor, Department of Electrical Engineering  
Dr. B. C. Roy Engineering College, Durgapur

🙏🏻 Thank You: **Mr. RUPAK CHATTERJEE**, **Mr. SUBHA SARKAR** and **et.al**  
🌐 GitHub: [@KingsukMajumdar](https://github.com/KingsukMajumdar)  
📺 YouTube: [Learn With Kingsuk](https://youtube.com/@LearnWithKingsuk)

**Hashtags:** `#LearnWithKingsuk` `#GoogleCloud` `#CloudRun` `#Serverless` `#BCREC` `#GSP644`

---

<div align="center">

**© 2025 Kingsuk Majumdar | Made with ❤️**

*"Serverless computing is not about eliminating servers, but about eliminating server management."*

[![GitHub followers](https://img.shields.io/github/followers/KingsukMajumdar?style=social)](https://github.com/KingsukMajumdar)
[![YouTube Channel Subscribers](https://img.shields.io/youtube/channel/subscribers/UCo2Rho6ypq7IkxaKwByWQRA?style=social)](https://youtube.com/@LearnWithKingsuk)
</div>
