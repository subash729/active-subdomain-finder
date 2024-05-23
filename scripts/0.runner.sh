#!/bin/bash

# Create a folder
echo -e "Step 1: Creating folder...\n"
mkdir actions-runner && cd actions-runner
echo -e "Step 1: Folder created.\n-----------------------------------------------------------------"

# Download the latest runner package
echo -e "Step 2: Downloading the latest runner package...\n"
sudo apt install -y curl
curl -o actions-runner-linux-x64-2.316.1.tar.gz -L https://github.com/actions/runner/releases/download/v2.316.1/actions-runner-linux-x64-2.316.1.tar.gz
echo -e "Step 2: Download completed.\n-----------------------------------------------------------------"

# Optional: Validate the hash
echo -e "Step 3: Validating hash...\n"
echo "d62de2400eeeacd195db91e2ff011bfb646cd5d85545e81d8f78c436183e09a8  actions-runner-linux-x64-2.316.1.tar.gz" | shasum -a 256 -c
echo -e "Step 3: Hash validated.\n-----------------------------------------------------------------"

# Extract the installer
echo -e "Step 4: Extracting the installer...\n"
tar xzf ./actions-runner-linux-x64-2.316.1.tar.gz
echo -e "Step 4: Installer extracted.\n-----------------------------------------------------------------"

echo -e "=================TASK completed Sucessfully======================"