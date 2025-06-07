#!/bin/bash

# Stop on error
set -e

# --- Global Variables ---
CONFIG_FILE="$HOME/.tmux.conf"

# --- Confirmation Prompt ---
read -r -p "Install tmux and setup configs? (Y/N): " response
if [[ "$response" =~ ^([yY][eE][sS]|[yY]) ]]
then
  echo "Continuing with tmux installation and setup..."
else
  echo "Aborting tmux installation and setup."
  exit 0
fi

# --- 1. Update and Install tmux ---
echo "Updating package lists and installing tmux..."
brew update
brew install tmux

# --- 2. Install TPM ---
echo "Installing TPM (tmux Plugin Manager)..."
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# --- 3. Copy the Configuration File ---
echo "Copying the Configuration File..."
cp "tmux.conf" "$CONFIG_FILE"

# --- 4. Install Plugins ---
echo "Installing tmux plugins..."
tmux start \; command-prompt "install" \; display "Installing plugins..."

# --- 5. Source the Configuration ---
echo "Sourcing the Configuration..."
tmux source-file "$CONFIG_FILE" \; display "tmux configuration reloaded!"

echo "tmux setup complete!"
