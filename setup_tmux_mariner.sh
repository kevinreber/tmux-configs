#!/bin/bash

# Stop on error
set -e

# --- Global Variables ---
CONFIG_FILE="$HOME/.tmux.conf"
TPM_PATH="$HOME/.tmux/plugins/tpm"

# --- Confirmation Prompt ---
read -r -p "❓ Install tmux and setup configs for CBL-Mariner? (Y/N): " response
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
    sudo tdnf remove -y tmux
    echo "🔄 Updating package lists..."
    sudo tdnf update -y
    echo "🔄 Reinstalling tmux..."
    sudo tdnf install -y tmux
    echo "✅ tmux reinstalled!"
  else
    echo "🔄 Skipping tmux reinstallation."
  fi
else
  echo "🔄 Updating package lists..."
  sudo tdnf update -y
  echo "✅ Package lists updated!"
  echo "🔄 Installing tmux..."
  sudo tdnf install -y tmux
  echo "✅ tmux installed!"
fi

# --- 2. Install font ---
echo "🔄 Installing Hack Nerd Font..."

# Check if unzip is installed, install if not
if ! command -v unzip >/dev/null 2>&1; then
  echo "🔄 unzip is not installed. Installing..."
  sudo tdnf install -y unzip
  echo "✅ unzip installed!"
fi

# Define font directory
FONT_DIR="$HOME/.local/share/fonts"

# Check if font directory exists
if [ -d "$FONT_DIR" ]; then
  echo "⚠️ Font directory already exists at $FONT_DIR. Skipping creation."
else
  # Create fonts directory if it doesn't exist
  echo "🔄 Creating font directory..."
  mkdir -p "$FONT_DIR"
  echo "✅ Font directory created!"
fi

# Download Hack Nerd Font
echo "🔄 Downloading Hack Nerd Font..."
curl -fLo Hack.zip https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/Hack.zip

# Check if the download was successful
if [ -f "Hack.zip" ]; then
  echo "✅ Hack Nerd Font (v3.4.0) downloaded!"
  # Extract the font files
  echo "🔄 Extracting font files..."
  unzip -o Hack.zip -d "$FONT_DIR/"
  echo "✅ Hack Nerd Font (v3.4.0) extracted!"

  # Clean up zip file
  echo "🔄 Removing Hack Nerd Font (v3.4.0) zip file..."
  rm -f Hack.zip
  echo "✅ Hack Nerd Font (v3.4.0) zip file removed!"

  # Update font cache
  echo "🔄 Updating Hack Nerd Font (v3.4.0) font cache..."
  fc-cache -fv
  echo "✅ Hack Nerd Font (v3.4.0) font cache updated!"
  echo "✅ Hack Nerd Font installed!"
else
  echo "❌ Failed to download Hack Nerd Font (v3.4.0). Trying fallback version (v2.1.0)..."
  curl -fLo Hack.zip https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/Hack.zip

  if [ -f "Hack.zip" ]; then
    echo "✅ Hack Nerd Font (v2.1.0) downloaded!"
    # Extract the font files
    echo "🔄 Extracting font files..."
    unzip -o Hack.zip -d "$FONT_DIR/"
    echo "✅ Hack Nerd Font (v2.1.0) extracted!"

    # Clean up zip file
    echo "🔄 Removing Hack Nerd Font (v2.1.0) zip file..."
    rm -f Hack.zip
    echo "✅ Hack Nerd Font (v2.1.0) zip file removed!"

    # Update font cache
    echo "🔄 Updating Hack Nerd Font (v2.1.0) font cache..."
    fc-cache -fv
    echo "✅ Hack Nerd Font (v2.1.0) font cache updated!"
    echo "✅ Hack Nerd Font installed!"
  else
    echo "❌ Failed to download Hack Nerd Font (v2.1.0) as well. Please check your internet connection and the download URLs."
  fi
fi

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

# --- 5. Install Plugins and Source the Configuration ---
echo "🔄 Creating new tmux session to install plugins..."
tmux new-session -d -s temp_session
echo "✅ New tmux session created!"

echo "🔄 Attempting to install tmux plugins..."
tmux send-keys -t temp_session:0 "$HOME/.tmux/plugins/tpm/bin/install_plugins" C-m
echo "✅ Plugins installed!"

echo "🔄 Attempting to source tmux configuration..."
tmux source-file "$CONFIG_FILE"
echo "✅ tmux configuration reloaded!"

echo "🔄 Killing tmux session..."
tmux kill-session -t temp_session
echo "✅ tmux session killed!"

echo "✅ Your configuration will be loaded when you start tmux."
echo "🚀 tmux setup complete!"