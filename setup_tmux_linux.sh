#!/bin/bash

# Stop on error
set -e

# --- Global Variables ---
CONFIG_FILE="$HOME/.tmux.conf"
TPM_PATH="$HOME/.tmux/plugins/tpm"

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
sudo apt-get update
sudo apt-get install -y tmux

# --- 2. Install TPM ---
if [ -d "$TPM_PATH" ]; then
  echo "TPM already installed at $TPM_PATH. Skipping installation."
else
  echo "Installing TPM (tmux Plugin Manager)..."
  git clone https://github.com/tmux-plugins/tpm "$TPM_PATH"
fi

# --- 3. Copy the Configuration File ---
echo "Copying the Configuration File..."
cp "tmux.conf" "$CONFIG_FILE"

# --- 4. Install Plugins ---
echo "Installing tmux plugins..."
tmux new-session -d -s temp_session
tmux send-keys -t temp_session:0 "$HOME/.tmux/plugins/tpm/bin/install_plugins" C-m
tmux kill-session -t temp_session

# --- 5. Source the Configuration ---
echo "Sourcing the Configuration..."
tmux source-file "$CONFIG_FILE" \; display "tmux configuration reloaded!"

echo "tmux setup complete!"
