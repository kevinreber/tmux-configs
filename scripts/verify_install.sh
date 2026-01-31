#!/bin/bash

# verify_install.sh
# Post-installation verification script for tmux setup
# Exit codes: 0 = all checks passed, 1 = one or more checks failed

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Counters
PASSED=0
FAILED=0
WARNINGS=0

# --- Helper Functions ---
pass() {
    echo -e "${GREEN}[PASS]${NC} $1"
    ((PASSED++))
}

fail() {
    echo -e "${RED}[FAIL]${NC} $1"
    ((FAILED++))
}

warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
    ((WARNINGS++))
}

# --- Configuration ---
CONFIG_FILE="$HOME/.tmux.conf"
TPM_PATH="$HOME/.tmux/plugins/tpm"
PLUGINS_DIR="$HOME/.tmux/plugins"

# Expected plugins from tmux.conf
EXPECTED_PLUGINS=(
    "tpm"
    "vim-tmux-navigator"
    "tmux-nerd-font-window-name"
    "tmux"  # catppuccin/tmux
    "tmux-resurrect"
    "tmux-continuum"
)

echo "======================================"
echo "  tmux Installation Verification"
echo "======================================"
echo ""

# --- 1. Check if tmux is installed ---
echo "1. Checking tmux installation..."
if command -v tmux >/dev/null 2>&1; then
    TMUX_VERSION=$(tmux -V)
    pass "tmux is installed: $TMUX_VERSION"
else
    fail "tmux is not installed or not in PATH"
fi

# --- 2. Check tmux.conf exists ---
echo ""
echo "2. Checking tmux configuration file..."
if [ -f "$CONFIG_FILE" ]; then
    pass "tmux.conf exists at $CONFIG_FILE"
else
    fail "tmux.conf not found at $CONFIG_FILE"
fi

# --- 3. Validate tmux.conf content ---
echo ""
echo "3. Validating tmux.conf content..."
if [ -f "$CONFIG_FILE" ]; then
    # Check for key configurations
    if grep -q "set -g prefix C-a" "$CONFIG_FILE"; then
        pass "Prefix key is set to Ctrl+a"
    else
        fail "Prefix key configuration not found"
    fi

    if grep -q "set -g mouse on" "$CONFIG_FILE"; then
        pass "Mouse support is enabled"
    else
        warn "Mouse support may not be enabled"
    fi

    if grep -q "@plugin 'catppuccin/tmux'" "$CONFIG_FILE"; then
        pass "Catppuccin theme plugin is configured"
    else
        fail "Catppuccin theme plugin not found in config"
    fi

    if grep -q "tmux-plugins/tmux-resurrect" "$CONFIG_FILE"; then
        pass "tmux-resurrect plugin is configured"
    else
        fail "tmux-resurrect plugin not found in config"
    fi

    if grep -q "tmux-plugins/tmux-continuum" "$CONFIG_FILE"; then
        pass "tmux-continuum plugin is configured"
    else
        fail "tmux-continuum plugin not found in config"
    fi
else
    fail "Cannot validate config - file does not exist"
fi

# --- 4. Check TPM installation ---
echo ""
echo "4. Checking TPM (Tmux Plugin Manager)..."
if [ -d "$TPM_PATH" ]; then
    pass "TPM is installed at $TPM_PATH"

    if [ -f "$TPM_PATH/tpm" ]; then
        pass "TPM main script exists"
    else
        fail "TPM main script not found"
    fi

    if [ -f "$TPM_PATH/bin/install_plugins" ]; then
        pass "TPM install_plugins script exists"
    else
        fail "TPM install_plugins script not found"
    fi
else
    fail "TPM not found at $TPM_PATH"
fi

# --- 5. Check installed plugins ---
echo ""
echo "5. Checking installed plugins..."
if [ -d "$PLUGINS_DIR" ]; then
    for plugin in "${EXPECTED_PLUGINS[@]}"; do
        if [ -d "$PLUGINS_DIR/$plugin" ]; then
            pass "Plugin installed: $plugin"
        else
            warn "Plugin not installed yet: $plugin (may install on first tmux start)"
        fi
    done
else
    fail "Plugins directory not found at $PLUGINS_DIR"
fi

# --- 6. Check tmux can parse config without errors ---
echo ""
echo "6. Validating tmux can parse configuration..."
if command -v tmux >/dev/null 2>&1 && [ -f "$CONFIG_FILE" ]; then
    # Try to parse the config file (dry run)
    # Note: This may fail if TPM isn't fully set up yet, so we treat it as a warning
    if tmux -f "$CONFIG_FILE" start-server \; list-sessions 2>/dev/null; then
        pass "tmux can start with the configuration"
    else
        # Try a simpler check - just see if tmux can be invoked
        if tmux -V >/dev/null 2>&1; then
            warn "tmux config may have issues (plugins may need to be installed first)"
        else
            fail "tmux cannot start properly"
        fi
    fi
else
    warn "Skipping config parse test - tmux or config not available"
fi

# --- Summary ---
echo ""
echo "======================================"
echo "  Verification Summary"
echo "======================================"
echo -e "${GREEN}Passed:${NC}   $PASSED"
echo -e "${RED}Failed:${NC}   $FAILED"
echo -e "${YELLOW}Warnings:${NC} $WARNINGS"
echo "======================================"

if [ $FAILED -gt 0 ]; then
    echo -e "${RED}Verification FAILED${NC}"
    exit 1
else
    if [ $WARNINGS -gt 0 ]; then
        echo -e "${YELLOW}Verification PASSED with warnings${NC}"
    else
        echo -e "${GREEN}Verification PASSED${NC}"
    fi
    exit 0
fi
