#!/usr/bin/bash
# -*- coding: utf-8 -*-
# Title: GSP644 - Build a Serverless App with Cloud Run that Creates PDF Files
# Purpose: Automate the deployment of a serverless PDF converter using Cloud Run
# Compiler: bash 5.x
# OS: Manjaro Linux / Cloud Shell
# Version: V1.2
# Written on: 05-11-2025
# Revision Date: 05-11-2025
# Author: Kingsuk Majumdar
# Copyright (c) 2025 Kingsuk Majumdar

# "Automation is not about replacing humans; it's about empowering them." - Unknown

set -euo pipefail

# Color codes for output
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly CYAN='\033[0;36m'
readonly NC='\033[0m' # No Color

# Function to print colored output
print_message() {
    local color=$1
    shift
    echo -e "${color}$*${NC}"
}

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Main script starts here
main() {
    print_message "$GREEN" "=== GSP644: Build a Serverless App with Cloud Run ==="
    print_message "$YELLOW" "Author: Kingsuk Majumdar"
    echo

    # Check for required commands
    if ! command_exists gcloud; then
        print_message "$RED" "Error: gcloud CLI not found. Please install Google Cloud SDK."
        exit 1
    fi

    # Check if REGION is already set
    if [[ -z "${REGION:-}" ]]; then
        print_message "$YELLOW" "Step 1: Setting up environment variables"
        read -p "Enter your REGION (e.g., us-east1, us-central1): " REGION
        export REGION
        
        if [[ -z "$REGION" ]]; then
            print_message "$RED" "Error: REGION cannot be empty"
            exit 1
        fi
    else
        print_message "$GREEN" "✓ Using existing REGION: $REGION"
    fi
    
    print_message "$GREEN" "✓ Region set to: $REGION"
    echo

    # Get current project
    GOOGLE_CLOUD_PROJECT=$(gcloud config get-value project 2>/dev/null)
    export GOOGLE_CLOUD_PROJECT
    PROJECT_NUMBER=$(gcloud projects describe $GOOGLE_CLOUD_PROJECT --format='value(projectNumber)')
    export PROJECT_NUMBER
    print_message "$GREEN" "✓ Project: $GOOGLE_CLOUD_PROJECT"
    print_message "$GREEN" "✓ Project Number: $PROJECT_NUMBER"
    echo

    # Step 2: Authenticate
    print_message "$YELLOW" "Step 2: Authenticating..."
    gcloud auth list
    echo

    # Step 3: Enable Required APIs
    print_message "$YELLOW" "Step 3: Enabling required APIs..."
    gcloud services disable run.googleapis.com --quiet 2>/dev/null || true
    gcloud services enable run.googleapis.com
    gcloud services enable pubsub.googleapis.com
    gcloud services enable cloudbuild.googleapis.com
    gcloud services enable storage-api.googleapis.com
    print_message "$YELLOW" "Waiting 30 seconds for API propagation..."
    sleep 30
    print_message "$GREEN" "✓ Required APIs enabled"
    echo

    # Step 4: Clone repository
    print_message "$YELLOW" "Step 4: Cloning pet-theory repository..."
    rm -rf pet-theory 2>/dev/null || true
    git clone https://github.com/rosera/pet-theory.git
    cd pet-theory/lab03
    print_message "$GREEN" "✓ Repository cloned"
    echo

    # Step 5: Update package.json
    print_message "$YELLOW" "Step 5: Updating package.json..."
    sed -i '6a\    "start": "node index.js",' package.json
    print_message "$GREEN" "✓ package.json updated"
    echo

    # Step 6: Install dependencies
    print_message "$YELLOW" "Step 6: Installing npm dependencies..."
    npm install express body-parser child_process @google-cloud/storage --silent
    print_message "$GREEN" "✓ Dependencies installed"
    echo

    # Step 7: Build and submit Docker image
    print_message "$YELLOW" "Step 7: Building Docker image..."
    gcloud builds submit --tag gcr.io/$GOOGLE_CLOUD_PROJECT/pdf-converter
    print_message "$GREEN" "✓ Docker image built"
    echo

    # Step 8: Deploy Cloud Run service (first deployment)
    print_message "$YELLOW" "Step 8: Deploying Cloud Run service (initial)..."
    gcloud run deploy pdf-converter \
        --image gcr.io/$GOOGLE_CLOUD_PROJECT/pdf-converter \
        --platform managed \
        --region $REGION \
        --no-allow-unauthenticated \
        --max-instances=1 \
        --quiet
    print_message "$GREEN" "✓ Initial deployment completed"
    echo

    # Step 9: Get service URL
    print_message "$YELLOW" "Step 9: Retrieving service URL..."
    SERVICE_URL=$(gcloud run services describe pdf-converter \
        --platform managed \
        --region $REGION \
        --format="value(status.url)")
    export SERVICE_URL
    echo "Service URL: $SERVICE_URL"
    echo

    # Step 10: Test service
    print_message "$YELLOW" "Step 10: Testing service endpoint..."
    curl -X POST $SERVICE_URL || true
    echo
    
    print_message "$YELLOW" "Testing with authentication..."
    curl -X POST -H "Authorization: Bearer $(gcloud auth print-identity-token)" $SERVICE_URL
    echo
    print_message "$GREEN" "✓ Service endpoint tested"
    echo

    # Step 11: Create Cloud Storage buckets
    print_message "$YELLOW" "Step 11: Creating Cloud Storage buckets..."
    gsutil mb gs://$GOOGLE_CLOUD_PROJECT-upload 2>/dev/null || print_message "$YELLOW" "Upload bucket already exists"
    gsutil mb gs://$GOOGLE_CLOUD_PROJECT-processed 2>/dev/null || print_message "$YELLOW" "Processed bucket already exists"
    print_message "$GREEN" "✓ Storage buckets created"
    echo

    # Step 12: Create Pub/Sub notification (this triggers Pub/Sub service account creation)
    print_message "$YELLOW" "Step 12: Creating Pub/Sub notification..."
    gsutil notification create -t new-doc -f json -e OBJECT_FINALIZE gs://$GOOGLE_CLOUD_PROJECT-upload 2>/dev/null || \
        print_message "$YELLOW" "Notification already exists"
    print_message "$GREEN" "✓ Pub/Sub notification created"
    echo

    # Step 13: Create service account
    print_message "$YELLOW" "Step 13: Creating service account..."
    gcloud iam service-accounts create pubsub-cloud-run-invoker \
        --display-name "PubSub Cloud Run Invoker" 2>/dev/null || \
        print_message "$YELLOW" "Service account already exists"
    print_message "$GREEN" "✓ Service account created"
    echo

    # Step 14: Grant IAM permissions
    print_message "$YELLOW" "Step 14: Granting IAM permissions..."
    
    # Grant Cloud Run invoker role
    gcloud run services add-iam-policy-binding pdf-converter \
        --member=serviceAccount:pubsub-cloud-run-invoker@$GOOGLE_CLOUD_PROJECT.iam.gserviceaccount.com \
        --role=roles/run.invoker \
        --platform managed \
        --region $REGION \
        --quiet
    
    print_message "$GREEN" "✓ Cloud Run invoker permission granted"
    echo

    # Step 15: Enable Pub/Sub service account (workaround)
    print_message "$YELLOW" "Step 15: Enabling Pub/Sub service account..."
    
    # The Pub/Sub service account is created when you use Pub/Sub
    # We need to grant the token creator role to it
    PUBSUB_SA="service-${PROJECT_NUMBER}@gcp-sa-pubsub.iam.gserviceaccount.com"
    
    print_message "$YELLOW" "Granting token creator role to Pub/Sub service account..."
    
    # Use gcloud beta if regular command fails
    gcloud projects add-iam-policy-binding $GOOGLE_CLOUD_PROJECT \
        --member=serviceAccount:$PUBSUB_SA \
        --role=roles/iam.serviceAccountTokenCreator \
        --condition=None \
        --quiet 2>/dev/null || \
    gcloud projects add-iam-policy-binding $GOOGLE_CLOUD_PROJECT \
        --member=serviceAccount:$PUBSUB_SA \
        --role=roles/iam.serviceAccountTokenCreator \
        --quiet
    
    print_message "$GREEN" "✓ Pub/Sub service account permissions granted"
    echo

    # Step 16: Create Pub/Sub subscription
    print_message "$YELLOW" "Step 16: Creating Pub/Sub subscription..."
    gcloud pubsub subscriptions create pdf-conv-sub \
        --topic new-doc \
        --push-endpoint=$SERVICE_URL \
        --push-auth-service-account=pubsub-cloud-run-invoker@$GOOGLE_CLOUD_PROJECT.iam.gserviceaccount.com 2>/dev/null || \
        print_message "$YELLOW" "Subscription already exists"
    print_message "$GREEN" "✓ Pub/Sub subscription created"
    echo

    # Step 17: Copy test files (initial batch)
    print_message "$YELLOW" "Step 17: Copying initial test files to upload bucket..."
    gsutil -m cp gs://spls/gsp644/* gs://$GOOGLE_CLOUD_PROJECT-upload
    print_message "$GREEN" "✓ Initial test files copied"
    echo

    # Step 18: Create Dockerfile
    print_message "$YELLOW" "Step 18: Creating Dockerfile with LibreOffice..."
    cat > Dockerfile <<'EOF_END'
FROM node:20
RUN apt-get update -y \
    && apt-get install -y libreoffice \
    && apt-get clean
WORKDIR /usr/src/app
COPY package.json package*.json ./
RUN npm install --only=production
COPY . .
CMD [ "npm", "start" ]
EOF_END
    print_message "$GREEN" "✓ Dockerfile created"
    echo

    # Step 19: Create index.js
    print_message "$YELLOW" "Step 19: Creating index.js with PDF conversion logic..."
    cat > index.js <<'EOF_END'
const {promisify} = require('util');
const {Storage}   = require('@google-cloud/storage');
const exec        = promisify(require('child_process').exec);
const storage     = new Storage();
const express     = require('express');
const bodyParser  = require('body-parser');
const app         = express();

app.use(bodyParser.json());

const port = process.env.PORT || 8080;
app.listen(port, () => {
  console.log('Listening on port', port);
});

app.post('/', async (req, res) => {
  try {
    const file = decodeBase64Json(req.body.message.data);
    await downloadFile(file.bucket, file.name);
    const pdfFileName = await convertFile(file.name);
    await uploadFile(process.env.PDF_BUCKET, pdfFileName);
    await deleteFile(file.bucket, file.name);
  }
  catch (ex) {
    console.log(`Error: ${ex}`);
  }
  res.set('Content-Type', 'text/plain');
  res.send('\n\nOK\n\n');
})

function decodeBase64Json(data) {
  return JSON.parse(Buffer.from(data, 'base64').toString());
}

async function downloadFile(bucketName, fileName) {
  const options = {destination: `/tmp/${fileName}`};
  await storage.bucket(bucketName).file(fileName).download(options);
}

async function convertFile(fileName) {
  const cmd = 'libreoffice --headless --convert-to pdf --outdir /tmp ' +
              `"/tmp/${fileName}"`;
  console.log(cmd);
  const { stdout, stderr } = await exec(cmd);
  if (stderr) {
    throw stderr;
  }
  console.log(stdout);
  pdfFileName = fileName.replace(/\.\w+$/, '.pdf');
  return pdfFileName;
}

async function deleteFile(bucketName, fileName) {
  await storage.bucket(bucketName).file(fileName).delete();
}

async function uploadFile(bucketName, fileName) {
  await storage.bucket(bucketName).upload(`/tmp/${fileName}`);
}
EOF_END
    print_message "$GREEN" "✓ index.js created"
    echo

    # Step 20: Rebuild Docker image
    print_message "$YELLOW" "Step 20: Rebuilding Docker image with LibreOffice..."
    print_message "$CYAN" "This may take a few minutes. Please wait..."
    gcloud builds submit --tag gcr.io/$GOOGLE_CLOUD_PROJECT/pdf-converter
    print_message "$GREEN" "✓ Docker image rebuilt"
    echo

    # Step 21: Redeploy Cloud Run service with final configuration
    print_message "$YELLOW" "Step 21: Redeploying Cloud Run service with final configuration..."
    print_message "$CYAN" "This deployment includes LibreOffice and will take longer. Please wait..."
    gcloud run deploy pdf-converter \
        --image gcr.io/$GOOGLE_CLOUD_PROJECT/pdf-converter \
        --platform managed \
        --region $REGION \
        --memory=2Gi \
        --no-allow-unauthenticated \
        --max-instances=1 \
        --set-env-vars PDF_BUCKET=$GOOGLE_CLOUD_PROJECT-processed \
        --quiet
    print_message "$GREEN" "✓ Final deployment completed"
    echo

    # Step 22: Final service verification
    print_message "$YELLOW" "Step 22: Final service verification..."
    RESPONSE=$(curl -s -X POST -H "Authorization: Bearer $(gcloud auth print-identity-token)" $SERVICE_URL)
    echo "Response: $RESPONSE"
    
    if [[ "$RESPONSE" == *"OK"* ]]; then
        print_message "$GREEN" "✓ Service responding correctly"
    else
        print_message "$YELLOW" "⚠ Service responded but check logs if needed"
    fi
    echo

    # Step 23: Create copy_files.sh script for testing
    print_message "$YELLOW" "Step 23: Creating copy_files.sh for delayed file upload testing..."
    cat > ~/copy_files.sh <<'EOF_END'
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
EOF_END
    chmod +x ~/copy_files.sh
    print_message "$GREEN" "✓ copy_files.sh created in home directory"
    echo

    # Final summary
    print_message "$GREEN" "=========================================="
    print_message "$GREEN" "         Deployment Summary"
    print_message "$GREEN" "=========================================="
    echo "Service URL: $SERVICE_URL"
    echo "Upload Bucket: gs://$GOOGLE_CLOUD_PROJECT-upload"
    echo "Processed Bucket: gs://$GOOGLE_CLOUD_PROJECT-processed"
    echo "Region: $REGION"
    echo "Test Script: ~/copy_files.sh"
    print_message "$GREEN" "=========================================="
    echo
    print_message "$GREEN" "✓ Lab GSP644 completed successfully!"
    echo
    print_message "$CYAN" "📝 Next Steps:"
    print_message "$YELLOW" "1. Run: bash ~/copy_files.sh (to upload files with delay)"
    print_message "$YELLOW" "2. Check upload bucket: gsutil ls gs://$GOOGLE_CLOUD_PROJECT-upload"
    print_message "$YELLOW" "3. Check processed bucket: gsutil ls gs://$GOOGLE_CLOUD_PROJECT-processed"
    print_message "$YELLOW" "4. View logs: gcloud logging read \"resource.type=cloud_run_revision\" --limit 20"
    echo
}

# Execute main function
main "$@"
