#!/bin/bash

# Stop on error
set -e

# --- Global Variables ---
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# --- Arrow Key Selection Menu ---
# Function to handle arrow key input
arrow_key_menu() {
    local options=("🍎 macOS" "🐧 Linux (yum)" "🚢 CBL-Mariner")
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
        echo "🍎 Selected macOS"
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