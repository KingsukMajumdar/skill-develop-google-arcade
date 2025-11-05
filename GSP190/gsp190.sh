#!/usr/bin/env bash
# -*- coding: utf-8 -*-
# Code URL: https://www.skills.google/games/6874/labs/42691
# Lab Code: GSP190
# Title: Google Cloud IAM Custom Role Manager
# Purpose: A comprehensive script to create, update, disable, delete, and undelete 
#          custom IAM roles in Google Cloud Platform with color-coded terminal output
# Compiler: Bash 4.0+
# OS: Manjaro Linux KDE Plasma
# Version: V1
# Written on: 05-Nov-2025
# Revision Date: 05-Nov-2025
# Version: V1.0
# Author: Kingsuk Majumdar
# MIT License 2025 Kingsuk Majumdar
#
# Aphorism: "With great power comes great responsibility - manage IAM roles wisely"
#
# Description:
# This script automates the management of Google Cloud IAM custom roles including
# role creation, permission updates, role state transitions, and role lifecycle
# management. It provides visual feedback through color-coded terminal output.

#═══════════════════════════════════════════════════════════════════════════════
# SECTION 1: COLOR DEFINITIONS USING TPUT
#═══════════════════════════════════════════════════════════════════════════════

# Define foreground text colors using tput setaf (set ANSI foreground)
# These variables store escape sequences for terminal color manipulation
# https://unix.stackexchange.com/questions/269077/tput-setaf-color-table-how-to-determine-color-codes
BLACK=`tput setaf 0`       # Sets text color to black (color code 0)
RED=`tput setaf 1`         # Sets text color to red (color code 1)
GREEN=`tput setaf 2`       # Sets text color to green (color code 2)
YELLOW=`tput setaf 3`      # Sets text color to yellow (color code 3)
BLUE=`tput setaf 4`        # Sets text color to blue (color code 4)
MAGENTA=`tput setaf 5`     # Sets text color to magenta (color code 5)
CYAN=`tput setaf 6`        # Sets text color to cyan (color code 6)
WHITE=`tput setaf 7`       # Sets text color to white (color code 7)

# Define background colors using tput setab (set ANSI background)
# These variables store escape sequences for terminal background color manipulation
BG_BLACK=`tput setab 0`    # Sets background color to black (color code 0)
BG_RED=`tput setab 1`      # Sets background color to red (color code 1)
BG_GREEN=`tput setab 2`    # Sets background color to green (color code 2)
BG_YELLOW=`tput setab 3`   # Sets background color to yellow (color code 3)
BG_BLUE=`tput setab 4`     # Sets background color to blue (color code 4)
BG_MAGENTA=`tput setab 5`  # Sets background color to magenta (color code 5)
BG_CYAN=`tput setab 6`     # Sets background color to cyan (color code 6)
BG_WHITE=`tput setab 7`    # Sets background color to white (color code 7)

# Define text formatting attributes
BOLD=`tput bold`           # Enables bold text formatting
RESET=`tput sgr0`          # Resets all text attributes to default (sgr0 = select graphic rendition 0)

#═══════════════════════════════════════════════════════════════════════════════
# SECTION 2: SCRIPT EXECUTION START NOTIFICATION
#═══════════════════════════════════════════════════════════════════════════════

# Display a visually appealing execution start message
# ${YELLOW}${BOLD} makes "Starting" appear in bold yellow
# ${GREEN}${BOLD} makes "Execution" appear in bold green
# ${RESET} after each word returns formatting to default
echo "${YELLOW}${BOLD}Starting${RESET}" "${GREEN}${BOLD}Execution${RESET}"

#═══════════════════════════════════════════════════════════════════════════════
# SECTION 3: CREATE INITIAL IAM ROLE DEFINITION FILE (EDITOR ROLE)
#═══════════════════════════════════════════════════════════════════════════════

# Generate a YAML configuration file for the "editor" custom IAM role
# The > operator creates/overwrites the file role-definition.yaml
# This heredoc-style multi-line echo creates a structured YAML file with:
#   - title: Human-readable name of the role
#   - description: Purpose of the role
#   - stage: Development stage (ALPHA, BETA, GA, DEPRECATED, DISABLED)
#   - includedPermissions: List of GCP permissions granted by this role
echo 'title: "Role Editor"
description: "Edit access for App Versions"
stage: "ALPHA"
includedPermissions:
- appengine.versions.create
- appengine.versions.delete' > role-definition.yaml

#═══════════════════════════════════════════════════════════════════════════════
# SECTION 4: CREATE CUSTOM IAM ROLE "EDITOR" FROM YAML FILE
#═══════════════════════════════════════════════════════════════════════════════

# Create a new custom IAM role named "editor" in the current GCP project
# gcloud iam roles create: GCloud command to create custom IAM roles
# editor: The unique role ID (name) for this custom role
# --project $DEVSHELL_PROJECT_ID: Specifies the GCP project ID (environment variable)
# --file role-definition.yaml: Reads role configuration from the YAML file created above
# The backslash (\) allows command continuation on the next line for readability
gcloud iam roles create editor --project $DEVSHELL_PROJECT_ID \
--file role-definition.yaml

#═══════════════════════════════════════════════════════════════════════════════
# SECTION 5: CREATE CUSTOM IAM ROLE "VIEWER" WITH INLINE PARAMETERS
#═══════════════════════════════════════════════════════════════════════════════

# Create a second custom IAM role named "viewer" using command-line parameters
# gcloud iam roles create viewer: Creates a role with ID "viewer"
# --project $DEVSHELL_PROJECT_ID: Specifies the target GCP project
# --title "Role Viewer": Sets the human-readable display name
# --description "Custom role description.": Provides role purpose description
# --permissions: Comma-separated list of permissions granted by this role
#   - compute.instances.get: Allows viewing details of compute instances
#   - compute.instances.list: Allows listing all compute instances
# --stage ALPHA: Sets the role lifecycle stage to ALPHA (early testing phase)
gcloud iam roles create viewer --project $DEVSHELL_PROJECT_ID \
--title "Role Viewer" --description "Custom role description." \
--permissions compute.instances.get,compute.instances.list --stage ALPHA

#═══════════════════════════════════════════════════════════════════════════════
# SECTION 6: CREATE UPDATED YAML DEFINITION FOR EDITOR ROLE
#═══════════════════════════════════════════════════════════════════════════════

# Generate an updated YAML configuration file for modifying the existing "editor" role
# This file includes additional permissions and updated metadata
# Key additions:
#   - etag: Entity tag for versioning (left empty, GCP will populate)
#   - Additional permissions: storage.buckets.get and storage.buckets.list
#   - name: Full resource name format (projects/PROJECT_ID/roles/ROLE_ID)
# The single quotes preserve literal text, while $DEVSHELL_PROJECT_ID is expanded
echo 'description: Edit access for App Versions
etag:
includedPermissions:
- appengine.versions.create
- appengine.versions.delete
- storage.buckets.get
- storage.buckets.list
name: projects/'$DEVSHELL_PROJECT_ID'/roles/editor
stage: ALPHA
title: Role Editor' > new-role-definition.yaml

#═══════════════════════════════════════════════════════════════════════════════
# SECTION 7: UPDATE EDITOR ROLE WITH NEW PERMISSIONS FROM YAML FILE
#═══════════════════════════════════════════════════════════════════════════════

# Update the existing "editor" role with the modified configuration
# gcloud iam roles update: Command to modify existing custom IAM roles
# editor: The role ID to be updated
# --project $DEVSHELL_PROJECT_ID: Specifies the GCP project containing the role
# --file new-role-definition.yaml: Reads updated configuration from YAML file
# --quiet: Suppresses interactive prompts and confirmation messages
gcloud iam roles update editor --project $DEVSHELL_PROJECT_ID \
--file new-role-definition.yaml --quiet

#═══════════════════════════════════════════════════════════════════════════════
# SECTION 8: ADD ADDITIONAL PERMISSIONS TO VIEWER ROLE
#═══════════════════════════════════════════════════════════════════════════════

# Incrementally add new permissions to the "viewer" role without replacing existing ones
# gcloud iam roles update: Updates existing role configuration
# viewer: The role ID to be modified
# --project $DEVSHELL_PROJECT_ID: Target GCP project
# --add-permissions: Appends new permissions to the existing permission list
#   - storage.buckets.get: Grants permission to view storage bucket details
#   - storage.buckets.list: Grants permission to list all storage buckets
# This approach preserves existing permissions while adding new ones
gcloud iam roles update viewer --project $DEVSHELL_PROJECT_ID \
--add-permissions storage.buckets.get,storage.buckets.list

#═══════════════════════════════════════════════════════════════════════════════
# SECTION 9: DISABLE THE VIEWER ROLE
#═══════════════════════════════════════════════════════════════════════════════

# Change the lifecycle stage of "viewer" role to DISABLED
# gcloud iam roles update: Modifies role properties
# viewer: The role ID to be disabled
# --project $DEVSHELL_PROJECT_ID: Project containing the role
# --stage DISABLED: Sets the role stage to DISABLED
# Note: Disabled roles cannot be used in new IAM policy bindings but
# existing bindings remain intact. This is a soft-delete mechanism.
gcloud iam roles update viewer --project $DEVSHELL_PROJECT_ID \
--stage DISABLED

#═══════════════════════════════════════════════════════════════════════════════
# SECTION 10: DELETE THE VIEWER ROLE
#═══════════════════════════════════════════════════════════════════════════════

# Permanently delete the "viewer" custom IAM role from the project
# gcloud iam roles delete: Removes the custom role
# viewer: The role ID to be deleted
# --project $DEVSHELL_PROJECT_ID: Project from which to delete the role
# Note: Deleted roles can be recovered within 7 days using the undelete command
# After 7 days, the role is permanently removed and cannot be recovered
# Deletion fails if the role is currently bound to any resources
gcloud iam roles delete viewer --project $DEVSHELL_PROJECT_ID

#═══════════════════════════════════════════════════════════════════════════════
# SECTION 11: UNDELETE (RESTORE) THE VIEWER ROLE
#═══════════════════════════════════════════════════════════════════════════════

# Restore a previously deleted custom IAM role within the 7-day recovery window
# gcloud iam roles undelete: Recovers a deleted role
# viewer: The role ID to be restored
# --project $DEVSHELL_PROJECT_ID: Project containing the deleted role
# Note: This command only works within 7 days of deletion
# After undelete, the role returns to its DISABLED state and must be
# explicitly enabled if needed
gcloud iam roles undelete viewer --project $DEVSHELL_PROJECT_ID

#═══════════════════════════════════════════════════════════════════════════════
# SECTION 12: COMPLETION MESSAGE WITH COLOR FORMATTING
#═══════════════════════════════════════════════════════════════════════════════

# Display a celebratory completion message with multi-color formatting
# ${RED}${BOLD}Congratulations${RESET}: "Congratulations" in bold red
# ${WHITE}${BOLD}for${RESET}: "for" in bold white
# ${GREEN}${BOLD}Completing the Lab !!!${RESET}: "Completing the Lab !!!" in bold green
# Each ${RESET} ensures color formatting doesn't bleed into subsequent terminal output
echo "${RED}${BOLD}Congratulations${RESET}" "${WHITE}${BOLD}for${RESET}" "${GREEN}${BOLD}Completing the Lab !!!${RESET}"

#═══════════════════════════════════════════════════════════════════════════════
# END OF SCRIPT
#═══════════════════════════════════════════════════════════════════════════════
