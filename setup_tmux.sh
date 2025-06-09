#!/bin/bash

# Stop on error
set -e

# --- Global Variables ---
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_FILE="$HOME/.tmux.conf"
TPM_PATH="$HOME/.tmux/plugins/tpm"

# Function to install plugins and source config
install_plugins_and_source() {
    echo "🔄 Setting up tmux plugins and configuration..."

    # Create a temporary session if one doesn't exist
    if ! tmux has-session -t temp_session 2>/dev/null; then
        echo "🔄 Creating temporary tmux session..."
        tmux new-session -d -s temp_session
        echo "✅ Temporary session created!"
    fi

    # Source the configuration
    echo "🔄 Sourcing tmux configuration..."
    if [ -f "$CONFIG_FILE" ]; then
        tmux source-file "$CONFIG_FILE"
        echo "✅ tmux configuration reloaded!"
    else
        echo "❌ tmux config file not found at $CONFIG_FILE"
        return 1
    fi

    # Install plugins
    echo "🔄 Installing tmux plugins..."
    if [ -f "$TPM_PATH/bin/install_plugins" ]; then
        # Get list of plugins from tmux.conf
        PLUGINS=$(grep -o "set -g @plugin '[^']*'" "$CONFIG_FILE" | cut -d"'" -f2)

        # Install plugins
        tmux send-keys -t temp_session:0 "$TPM_PATH/bin/install_plugins" C-m

        # Wait for plugins to be installed
        echo "🔄 Waiting for plugins to install..."
        for plugin in $PLUGINS; do
            plugin_name=$(basename "$plugin")
            while [ ! -d "$HOME/.tmux/plugins/$plugin_name" ]; do
                sleep 1
            done
        done
        echo "✅ Plugins installed!"
    else
        echo "❌ TPM install script not found at $TPM_PATH/bin/install_plugins"
        return 1
    fi

    # Kill the temporary session
    echo "🔄 Cleaning up temporary session..."
    tmux kill-session -t temp_session 2>/dev/null
    echo "✅ Temporary session removed!"

    echo '🚀 tmux setup complete! 🎉 You can now start a new tmux session by entering "tmux"!'
    echo "☕ You can buy me a coffee at coff.ee/kevinreber"
}

# --- Arrow Key Selection Menu ---
# Function to handle arrow key input
arrow_key_menu() {
    local options=("🍎 MacOS" "🐧 Linux (yum)" "🚢 CBL-Mariner")
    local selected=0
    local key

    # Hide cursor
    tput civis

    # Function to display menu
    display_menu() {
        clear
        echo "🌐 Please select your operating system:"
        echo "Use ↑/↓ arrows to move, Enter to select"
        echo
        for i in "${!options[@]}"; do
            if [ $i -eq $selected ]; then
                echo "> ${options[$i]}"
            else
                echo "  ${options[$i]}"
            fi
        done
    }

    # Initial display
    display_menu

    # Read arrow keys
    while true; do
        read -rsn1 key
        case "$key" in
            $'\x1b')  # ESC sequence
                read -rsn2 key
                case "$key" in
                    "[A")  # Up arrow
                        selected=$((selected - 1))
                        [ $selected -lt 0 ] && selected=$((${#options[@]} - 1))
                        display_menu
                        ;;
                    "[B")  # Down arrow
                        selected=$((selected + 1))
                        [ $selected -ge ${#options[@]} ] && selected=0
                        display_menu
                        ;;
                esac
                ;;
            "")  # Enter key
                break
                ;;
        esac
    done

    # Show cursor
    tput cnorm
    return $selected
}

# Call the menu function
arrow_key_menu
os_choice=$?

# --- Execute the appropriate script based on selection ---
case $os_choice in
    0)
        echo "🍎 Selected MacOS"
        bash "$SCRIPT_DIR/setup_tmux_mac.sh"
        ;;
    1)
        echo "🐧 Selected Linux (yum)"
        bash "$SCRIPT_DIR/setup_tmux_linux.sh"
        ;;
    2)
        echo "🚢 Selected CBL-Mariner"
        bash "$SCRIPT_DIR/setup_tmux_mariner.sh"
        ;;
    *)
        echo "❌ Invalid selection. Please run the script again and select a valid option."
        exit 1
        ;;
esac

# After OS-specific script completes, install plugins and source config
install_plugins_and_source