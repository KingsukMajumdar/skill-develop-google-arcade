#!/usr/bin/env bash
# -*- coding: utf-8 -*-
# Code URL: https://www.skills.google/games/6875/labs/42698
# Lab Code: GSP080
# Title: Cloud Run Functions: Qwik Start - Command Line
# Purpose: Automate creation, deployment, and testing of Google Cloud Functions
#          triggered by Pub/Sub with color-coded terminal output
# Compiler: Bash 4.0+
# OS: Manjaro Linux KDE Plasma
# Version: V1
# Written on: 05-Nov-2025
# Revision Date: 05-Nov-2025
# Author: Kingsuk Majumdar
# Copyright (c) 2025 Kingsuk Majumdar
#
# Aphorism: "Code is like humor. When you have to explain it, it's bad." - Cory House

#═══════════════════════════════════════════════════════════════════════════════
# SECTION 1: COLOR DEFINITIONS USING TPUT
#═══════════════════════════════════════════════════════════════════════════════

BLACK=`tput setaf 0`
RED=`tput setaf 1`
GREEN=`tput setaf 2`
YELLOW=`tput setaf 3`
BLUE=`tput setaf 4`
MAGENTA=`tput setaf 5`
CYAN=`tput setaf 6`
WHITE=`tput setaf 7`

BG_BLACK=`tput setab 0`
BG_RED=`tput setab 1`
BG_GREEN=`tput setab 2`
BG_YELLOW=`tput setab 3`
BG_BLUE=`tput setab 4`
BG_MAGENTA=`tput setab 5`
BG_CYAN=`tput setab 6`
BG_WHITE=`tput setab 7`

BOLD=`tput bold`
RESET=`tput sgr0`

#═══════════════════════════════════════════════════════════════════════════════
# SECTION 2: SCRIPT EXECUTION START NOTIFICATION
#═══════════════════════════════════════════════════════════════════════════════

echo "${YELLOW}${BOLD}Starting${RESET}" "${GREEN}${BOLD}Execution${RESET}"

#═══════════════════════════════════════════════════════════════════════════════
# SECTION 3: SET DEFAULT REGION FOR CLOUD RUN
#═══════════════════════════════════════════════════════════════════════════════

# Set the default region for Cloud Run functions
# Using us-central1 as the default region for this lab
export REGION="${REGION:-us-central1}"
gcloud config set run/region $REGION

#═══════════════════════════════════════════════════════════════════════════════
# SECTION 4: CREATE FUNCTION DIRECTORY AND NAVIGATE
#═══════════════════════════════════════════════════════════════════════════════

# Create directory for Cloud Function code and change to it
# The $_ variable contains the last argument of the previous command (gcf_hello_world)
mkdir gcf_hello_world && cd $_

#═══════════════════════════════════════════════════════════════════════════════
# SECTION 5: CREATE FUNCTION SOURCE CODE (index.js)
#═══════════════════════════════════════════════════════════════════════════════

# Create index.js with Cloud Function code
# This function is triggered by Pub/Sub CloudEvents
# The function extracts the message data, decodes it from base64, and logs it
cat > index.js << 'EOF'
const functions = require('@google-cloud/functions-framework');

// Register a CloudEvent callback with the Functions Framework that will
// be executed when the Pub/Sub trigger topic receives a message.
functions.cloudEvent('helloPubSub', cloudEvent => {
  // The Pub/Sub message is passed as the CloudEvent's data payload.
  const base64name = cloudEvent.data.message.data;

  const name = base64name
    ? Buffer.from(base64name, 'base64').toString()
    : 'World';

  console.log(`Hello, ${name}!`);
});
EOF

#═══════════════════════════════════════════════════════════════════════════════
# SECTION 6: CREATE PACKAGE CONFIGURATION (package.json)
#═══════════════════════════════════════════════════════════════════════════════

# Create package.json with Node.js dependencies
# Specifies the Functions Framework dependency required for Cloud Run functions
cat > package.json << 'EOF'
{
  "name": "gcf_hello_world",
  "version": "1.0.0",
  "main": "index.js",
  "scripts": {
    "start": "node index.js",
    "test": "echo \"Error: no test specified\" && exit 1"
  },
  "dependencies": {
    "@google-cloud/functions-framework": "^3.0.0"
  }
}
EOF

#═══════════════════════════════════════════════════════════════════════════════
# SECTION 7: INSTALL NODE.JS PACKAGE DEPENDENCIES
#═══════════════════════════════════════════════════════════════════════════════

# Install the required npm packages defined in package.json
# This installs the @google-cloud/functions-framework and its dependencies
npm install

#═══════════════════════════════════════════════════════════════════════════════
# SECTION 8: DEPLOY CLOUD FUNCTION TO GOOGLE CLOUD
#═══════════════════════════════════════════════════════════════════════════════

# Deploy the Cloud Function (2nd Generation)
# nodejs-pubsub-function: Name of the deployed function
# --gen2: Use 2nd generation Cloud Functions runtime
# --runtime=nodejs20: Use Node.js 20 runtime environment
# --region=$REGION: Deploy to the configured region
# --source=.: Use current directory as source code
# --entry-point=helloPubSub: JavaScript function name to execute
# --trigger-topic cf-demo: Pub/Sub topic that triggers the function
# --stage-bucket: Cloud Storage bucket for staging deployment artifacts
# --service-account: Service account for function execution
# --allow-unauthenticated: Allow invocations without authentication
gcloud functions deploy nodejs-pubsub-function \
  --gen2 \
  --runtime=nodejs20 \
  --region=$REGION \
  --source=. \
  --entry-point=helloPubSub \
  --trigger-topic cf-demo \
  --stage-bucket $DEVSHELL_PROJECT_ID-bucket \
  --service-account cloudfunctionsa@$DEVSHELL_PROJECT_ID.iam.gserviceaccount.com \
  --allow-unauthenticated

#═══════════════════════════════════════════════════════════════════════════════
# SECTION 9: VERIFY FUNCTION DEPLOYMENT STATUS
#═══════════════════════════════════════════════════════════════════════════════

# Describe the deployed function to verify ACTIVE status
# This command displays function configuration and current state
gcloud functions describe nodejs-pubsub-function \
  --region=$REGION

#═══════════════════════════════════════════════════════════════════════════════
# SECTION 10: TEST FUNCTION BY PUBLISHING MESSAGE TO PUB/SUB
#═══════════════════════════════════════════════════════════════════════════════

# Publish a test message to the Pub/Sub topic
# This triggers the Cloud Function execution
# Message: "Cloud Function Gen2"
gcloud pubsub topics publish cf-demo --message="Cloud Function Gen2"

#═══════════════════════════════════════════════════════════════════════════════
# SECTION 11: VIEW FUNCTION EXECUTION LOGS
#═══════════════════════════════════════════════════════════════════════════════

# Wait for function to execute and logs to be available
sleep 15

# Read function execution logs
# This displays log entries from the function execution
# Expected log output: "Hello, Cloud Function Gen2!"
gcloud functions logs read nodejs-pubsub-function \
  --region=$REGION

#═══════════════════════════════════════════════════════════════════════════════
# SECTION 12: COMPLETION MESSAGE WITH COLOR FORMATTING
#═══════════════════════════════════════════════════════════════════════════════

echo "${RED}${BOLD}Congratulations${RESET}" "${WHITE}${BOLD}for${RESET}" "${GREEN}${BOLD}Completing the Lab !!!${RESET}"

#═══════════════════════════════════════════════════════════════════════════════
# END OF SCRIPT
#═══════════════════════════════════════════════════════════════════════════════
