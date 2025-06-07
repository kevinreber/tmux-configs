#!/bin/bash

# Stop on error
set -e

# --- Global Variables ---
CONFIG_FILE="$HOME/.tmux.conf"
TPM_PATH="$HOME/.tmux/plugins/tpm"

# --- Confirmation Prompt ---
read -r -p "Install tmux and setup configs for MacOS? (Y/N): " response
if [[ "$response" =~ ^([yY][eE][sS]|[yY]) ]]
then
  echo "Continuing with tmux installation and setup..."
else
  echo "Aborting tmux installation and setup."
  exit 0
fi

# --- 1. Check if tmux is installed ---
if command -v tmux >/dev/null 2>&1; then
  echo "Tmux is already installed."
  read -r -p "Would you like to uninstall tmux and reinstall? (Y/N): " reinstall_tmux
  if [[ "$reinstall_tmux" =~ ^([yY][eE][sS]|[yY])$ ]]; then
    echo "Uninstalling tmux..."
    brew uninstall tmux
    echo "Reinstalling tmux..."
    brew update
    brew install tmux
  else
    echo "Skipping tmux reinstallation."
  fi
else
  echo "Installing tmux..."
  brew update
  brew install tmux
fi

# --- 2. Install TPM ---
if [ -d "$TPM_PATH" ]; then
  echo "TPM already installed at $TPM_PATH. Skipping installation."
else
  echo "Installing TPM (tmux Plugin Manager)..."
  git clone https://github.com/tmux-plugins/tpm "$TPM_PATH"
fi

# --- 3. Handle Existing tmux.conf ---
if [ -f "$CONFIG_FILE" ]; then
  echo "tmux config file already exists at $CONFIG_FILE."
  read -r -p "Would you like to overwrite it? (Y/N): " overwrite_conf
  if [[ "$overwrite_conf" =~ ^([yY][eE][sS]|[yY])$ ]]; then
    echo "Overwriting tmux config file..."
    cp "tmux.conf" "$CONFIG_FILE"
  else
    echo "Keeping existing tmux config file."
  fi
else
  echo "Copying tmux config file..."
  cp "tmux.conf" "$CONFIG_FILE"
fi

# --- 4. Install Plugins ---
echo "Installing tmux plugins..."
tmux new-session -d -s temp_session
tmux send-keys -t temp_session:0 "$HOME/.tmux/plugins/tpm/bin/install_plugins" C-m
tmux kill-session -t temp_session

# --- 5. Source the Configuration ---
echo "Sourcing the Configuration..."
tmux source-file "$CONFIG_FILE" \; display "tmux configuration reloaded!"

echo "tmux setup complete!"


