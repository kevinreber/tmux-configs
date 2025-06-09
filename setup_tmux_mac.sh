#!/bin/bash

# Stop on error
set -e

# --- Global Variables ---
CONFIG_FILE="$HOME/.tmux.conf"
TPM_PATH="$HOME/.tmux/plugins/tpm"

# --- Confirmation Prompt ---
read -r -p "❓ Install tmux and setup configs for MacOS? (Y/N): " response
if [[ "$response" =~ ^([yY][eE][sS]|[yY]) ]]
then
  echo "🚀 Continuing with tmux installation and setup..."
else
  echo "❌ Aborting tmux installation and setup..."
  exit 0
fi

# --- 1. Check if tmux is installed ---
if command -v tmux >/dev/null 2>&1; then
  echo "⚠️ Tmux is already installed."
  read -r -p "❓ Would you like to uninstall tmux and reinstall? (Y/N): " reinstall_tmux
  if [[ "$reinstall_tmux" =~ ^([yY][eE][sS]|[yY])$ ]]; then
    echo "🔄 Uninstalling tmux..."
    brew uninstall tmux
    echo "🔄 Updating homebrew..."
    brew update
    echo "🔄 Reinstalling tmux..."
    brew install tmux
    echo "✅ tmux reinstalled!"
  else
    echo "🔄 Skipping tmux reinstallation."
  fi
else
  echo "🔄 Updating homebrew..."
  brew update
  echo "✅ Homebrew updated!"
  echo "🔄 Installing tmux..."
  brew install tmux
  echo "✅ tmux installed!"
fi

# --- 2. Install font ---
echo "🔄 Installing font..."
brew install --cask font-hack-nerd-font
echo "✅ font installed!"

# --- 3. Install TPM ---
if [ -d "$TPM_PATH" ]; then
  echo "⚠️ TPM already installed at $TPM_PATH. Skipping installation."
else
  echo "🔄 Installing TPM (tmux Plugin Manager)..."
  git clone https://github.com/tmux-plugins/tpm "$TPM_PATH"
  echo "✅ TPM installed!"
fi

# --- 4. Handle Existing tmux.conf ---
if [ -f "$CONFIG_FILE" ]; then
  echo "⚠️ tmux config file already exists at $CONFIG_FILE."
  read -r -p "❓ Would you like to overwrite it? (Y/N): " overwrite_conf
  if [[ "$overwrite_conf" =~ ^([yY][eE][sS]|[yY])$ ]]; then
    echo "🔄 Overwriting tmux config file..."
    cp "tmux.conf" "$CONFIG_FILE"
    echo "✅ tmux config file overwritten!"
  else
    echo "✅ Keeping existing tmux config file at $CONFIG_FILE."
  fi
else
  echo "🔄 Copying tmux config file..."
  cp "tmux.conf" "$CONFIG_FILE"
  echo "✅ tmux config file copied!"
fi

# # --- 5. Install Plugins and Source the Configuration ---
# echo "🔄 Creating new tmux session to install plugins..."
# tmux new-session -d -s temp_session
# echo "✅ New tmux session created!"

# echo "🔄 Attempting to install tmux plugins..."
# tmux send-keys -t temp_session:0 "$HOME/.tmux/plugins/tpm/bin/install_plugins" C-m
# echo "✅ Plugins installed!"

# echo "🔄 Attempting to source tmux configuration..."
# tmux source-file "$CONFIG_FILE"
# echo "✅ tmux configuration reloaded!"

# echo "🔄 Killing tmux session..."
# tmux kill-session -t temp_session
# echo "✅ tmux session killed!"

# echo "🚀 tmux setup complete! 🎉 You can now start tmux with `tmux`!"
# echo "☕ You can buy me a coffee at coff.ee/kevinreber"
