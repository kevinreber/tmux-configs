# CLAUDE.md - AI Assistant Guidelines

This document provides comprehensive guidance for AI assistants working with this repository.

## Project Overview

**tmux-configs** is Kevin Reber's personal tmux configuration repository that provides:
- Automated cross-platform setup scripts for tmux (terminal multiplexer)
- Pre-configured keybindings inspired by Byobu
- A Docusaurus documentation site

**Target Platforms:** macOS, Linux (yum-based/RHEL/CentOS), CBL-Mariner (Microsoft cloud OS)

## Repository Structure

```
/
├── README.md                    # Main project documentation
├── CLAUDE.md                    # AI assistant guidelines (this file)
├── tmux.conf                    # Primary tmux configuration (copy to ~/.tmux.conf)
├── setup_tmux.sh                # Interactive OS selector script (entry point)
├── setup_tmux_mac.sh            # macOS-specific setup (uses Homebrew)
├── setup_tmux_linux.sh          # Linux yum-based setup
├── setup_tmux_mariner.sh        # CBL-Mariner setup (uses tdnf)
├── scripts/
│   └── verify_install.sh        # Post-install verification script
├── .github/workflows/
│   ├── test.yml                 # CI: ShellCheck + E2E tests (Linux, macOS, Mariner)
│   └── deploy.yml               # CD: Docusaurus deployment to GitHub Pages
└── docusaurus-docs/             # Documentation website (Node.js/TypeScript)
    ├── package.json             # Dependencies (Node 18+, Docusaurus 3.8.1)
    ├── package-lock.json        # Locked dependency versions
    ├── docusaurus.config.ts     # Site configuration
    ├── sidebars.ts              # Documentation navigation (auto-generated)
    ├── tsconfig.json             # TypeScript config (extends @docusaurus/tsconfig)
    ├── docs/
    │   └── tmux-setup/
    │       └── README.md        # Main documentation page (MDX-enhanced)
    ├── src/
    │   ├── css/
    │   │   └── custom.css       # Theme customization (green primary, dark mode)
    │   └── pages/
    │       ├── index.tsx         # Homepage React component
    │       ├── index.module.css  # Homepage styles
    │       └── markdown-page.md  # Additional markdown page
    └── static/
        ├── .nojekyll            # Prevents Jekyll processing on GitHub Pages
        └── img/
            ├── favicon.png
            └── logo.png
```

## Common Commands

### Setup Scripts

```bash
# Interactive setup (prompts for OS selection via arrow-key menu)
./setup_tmux.sh

# Direct OS-specific setup
./setup_tmux_mac.sh          # macOS with Homebrew
./setup_tmux_linux.sh        # Linux with yum
./setup_tmux_mariner.sh      # CBL-Mariner with tdnf

# CI/non-interactive mode (auto-accepts prompts)
./setup_tmux_mac.sh --ci
./setup_tmux_linux.sh --ci
./setup_tmux_mariner.sh --ci
```

### Verification

```bash
# Verify installation (run after setup)
./scripts/verify_install.sh
```

### Documentation Site (Docusaurus)

```bash
cd docusaurus-docs

# Install dependencies
npm ci

# Local development server
npm run start

# Production build
npm run build

# Serve production build locally
npm run serve

# Clear Docusaurus cache
npm run clear
```

## CI/CD Pipeline

### test.yml (Triggered on: push/PR to main, manual dispatch)

1. **ShellCheck** - Static analysis of all bash scripts (severity: warning, excludes `docusaurus-docs/` and `node_modules/`)
2. **E2E Linux** - Full install test on Rocky Linux 8 container (`rockylinux:8`)
3. **E2E macOS** - Full install test on macOS runner (`macos-latest`)
4. **E2E Mariner** - Full install test on CBL-Mariner container (`mcr.microsoft.com/cbl-mariner/base/core:2.0`)

Each E2E job runs the OS-specific setup script with `--ci` flag, then runs `scripts/verify_install.sh`.

### deploy.yml (Triggered on: push to main, manual dispatch)

Builds Docusaurus site (Node 18, `npm ci` + `npm run build`) and deploys to GitHub Pages via `gh-pages` branch using `peaceiris/actions-gh-pages@v3`.

## Code Conventions

### Bash Scripts

- **Error handling**: Always start with `set -e` (exit on error)
- **Global variables**: Define at top of script (`SCRIPT_DIR`, `CONFIG_FILE`, `TPM_PATH`)
- **Functions before main logic**: Helper functions defined before they're called
- **Command checks**: Use `command -v <tool> >/dev/null 2>&1` to check for installed tools
- **User prompts**: Use `read -r -p` with descriptive prompts
- **Response validation**: `[[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]`
- **Visual feedback with emojis**:
  - `🔄` = In progress
  - `✅` = Success
  - `❌` = Error/Abort
  - `⚠️` = Warning
  - `🍎` = macOS, `🐧` = Linux, `🚢` = Mariner

### Script Pattern

```bash
#!/bin/bash
set -e

# Global variables
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_FILE="tmux.conf"
TPM_PATH="$HOME/.tmux/plugins/tpm"

# CI mode detection
CI_MODE=false
if [[ "$1" == "--ci" ]] || [[ "$1" == "-y" ]]; then
    CI_MODE=true
fi

# Confirmation helper
confirm_action() {
    if [[ "$CI_MODE" == true ]]; then
        return 0  # Auto-yes in CI mode
    fi
    read -r -p "❓ $1 (Y/N): " response
    [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]
}

# Main logic...
```

### Tmux Configuration

- **Prefix key**: `Ctrl+a` (remapped from default `Ctrl+b`)
- **Status bar**: Positioned at top (`set -g status-position top`)
- **Mouse**: Enabled (`set -g mouse on`)
- **Key binding style**: Byobu-inspired F-keys plus arrow-key navigation
  - `Shift+Arrow`: Pane navigation
  - `Ctrl+Arrow`: Pane navigation and resizing
  - `Alt+Arrow`: Window switching and swapping
  - `F1-F12`: Byobu-style function keys
- **Plugin management**: TPM (Tmux Plugin Manager) initialized at end of config
- **Reload bindings**: Both `prefix + r` and `prefix + R`
- **Theme**: Catppuccin with custom separators and status modules

### Docusaurus Site

- **Framework**: Docusaurus 3.8.1 with React 19 and TypeScript 5.6
- **Site URL**: https://kevinreber.github.io/tmux-configs/
- **Sidebar**: Auto-generated from filesystem structure
- **Theme**: Green primary (#2e8555), dark mode with teal variations
- **Strict mode**: Broken links throw errors, broken markdown links warn
- **Prism themes**: GitHub (light) / Dracula (dark)

## Key Files to Understand

| File | Purpose |
|------|---------|
| `tmux.conf` | Main tmux settings, keybindings, and plugins |
| `setup_tmux.sh` | Entry point with interactive arrow-key OS menu |
| `setup_tmux_mac.sh` | macOS setup via Homebrew (includes font install) |
| `setup_tmux_linux.sh` | Linux setup via yum |
| `setup_tmux_mariner.sh` | CBL-Mariner setup via tdnf (includes font fallback logic) |
| `scripts/verify_install.sh` | Post-install validation with colored output and pass/fail/warn counters |
| `.github/workflows/test.yml` | Multi-platform CI testing (4 parallel jobs) |
| `.github/workflows/deploy.yml` | Docusaurus build and GitHub Pages deployment |
| `docusaurus-docs/docusaurus.config.ts` | Site config (URL, navbar, footer, theme) |

## Testing Approach

1. **Static Analysis**: ShellCheck validates all bash scripts
2. **E2E Testing**: Full installation tested on all three platforms
3. **Container Testing**: Rocky Linux and CBL-Mariner run in containers
4. **Verification Script**: Validates tmux, config, TPM, and plugins after install

### Running Tests Locally

```bash
# ShellCheck (install with: brew install shellcheck / apt install shellcheck)
shellcheck setup_tmux.sh setup_tmux_*.sh scripts/*.sh

# Full verification
./scripts/verify_install.sh
```

## Tmux Plugins Used

| Plugin | Repository | Purpose |
|--------|-----------|---------|
| tpm | `tmux-plugins/tpm` | Tmux Plugin Manager |
| vim-tmux-navigator | `christoomey/vim-tmux-navigator` | Seamless Vim/Tmux pane navigation |
| tmux-nerd-font-window-name | `joshmedeski/tmux-nerd-font-window-name` | Nerd font icons for file types |
| catppuccin/tmux | `catppuccin/tmux` | Catppuccin color theme |
| tmux-resurrect | `tmux-plugins/tmux-resurrect` | Session persistence |
| tmux-continuum | `tmux-plugins/tmux-continuum` | Auto-save sessions (every 15min) |

**Font requirement**: Hack Nerd Font (v3.4.0, with v2.1.0 fallback on Mariner)

## Git Conventions

- **Branch naming**: `claude/feature-name-hash` for AI-assisted work
- **Commit messages**: Imperative mood, descriptive
  - Good: "Add verification script for post-install validation"
  - Good: "Fix font download fallback for older Mariner versions"
- **PRs**: Use numbered pull requests with merge commits

## Documentation

- **Live site**: https://kevinreber.github.io/tmux-configs/
- **Root README.md**: Quick setup + full config display
- **Docusaurus docs**: Detailed guides with MDX enhancements

### Updating Documentation

1. **Root README.md**: Keep in sync with tmux.conf changes
2. **docusaurus-docs/docs/**: Detailed documentation with frontmatter
3. **Docusaurus config**: `docusaurus-docs/docusaurus.config.ts`

## Common Tasks

### Adding a New Platform

1. Create `setup_tmux_<platform>.sh` following existing script patterns
2. Add E2E test job in `.github/workflows/test.yml`
3. Update `setup_tmux.sh` menu to include new option
4. Update README.md with new platform instructions

### Modifying Tmux Config

1. Edit `tmux.conf`
2. Test locally: `tmux source-file ~/.tmux.conf`
3. Update README.md if keybindings changed
4. Update docusaurus docs if relevant

### Adding a Tmux Plugin

1. Add plugin line to `tmux.conf`: `set -g @plugin 'author/plugin-name'`
2. Add to expected plugins array in `scripts/verify_install.sh`
3. Document in README.md
4. Run `prefix + I` in tmux to install

### Modifying the Documentation Site

1. Edit files in `docusaurus-docs/docs/` for content changes
2. Edit `docusaurus-docs/src/` for layout/component changes
3. Test locally with `cd docusaurus-docs && npm start`
4. Production build test: `npm run build` (catches broken links)
5. Deployment is automatic on push to main

## Troubleshooting

- **Font issues**: Ensure terminal is using Hack Nerd Font
- **Plugins not loading**: Run `~/.tmux/plugins/tpm/scripts/install_plugins.sh`
- **Config not applying**: Run `tmux source-file ~/.tmux.conf` or restart tmux
- **Verification failures**: Check if tmux version is 3.0+ (`tmux -V`)
- **Docusaurus build fails**: Check Node version (18+ required), try `npm run clear` then rebuild
- **ShellCheck warnings**: Run `shellcheck <script>` locally to see detailed explanations
