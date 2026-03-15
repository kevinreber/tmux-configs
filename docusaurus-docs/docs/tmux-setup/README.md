---
sidebar_label: "Tmux Setup"
sidebar_position: 1
id: tmux-setup
title: My Tmux Setup
description: A fully configured tmux environment with Byobu-style keybindings, session persistence, and Catppuccin theming.
---

# Tmux Setup

Get a fully configured tmux environment with Byobu-style keybindings, session persistence, and Catppuccin theming — in one command.

[View source code on GitHub](https://github.com/kevinreber/tmux-configs/)

## Prerequisites

Before running the setup, make sure you have:

| Requirement | Details |
|---|---|
| **OS** | macOS, Linux (yum-based), or CBL-Mariner |
| **Homebrew** (macOS only) | [Install Homebrew](https://brew.sh/) |
| **Nerd Font** | [Hack Nerd Font](https://github.com/ryanoasis/nerd-fonts) — required for icons and the Catppuccin theme |
| **Terminal font setting** | Set your terminal's font to `Hack Nerd Font` after install |
| **tmux** | 3.0+ (the setup script will install it for you) |

<details>
<summary><strong>Installing Hack Nerd Font manually</strong></summary>

**Via Homebrew (macOS):**

```bash
brew install --cask font-hack-nerd-font
```

**Via shell (any OS):**

```bash
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/Hack.zip
unzip Hack.zip -d ~/Library/Fonts/    # macOS
# unzip Hack.zip -d ~/.local/share/fonts/  # Linux
```

After installing, set your terminal's font to **Hack Nerd Font** (e.g., in iTerm: Preferences > Profiles > Text > Font).

</details>

## Quick Start

```sh
# Clone and run
git clone https://github.com/kevinreber/tmux-configs.git
cd tmux-configs
chmod +x setup_tmux.sh
./setup_tmux.sh
```

The interactive menu will guide you through selecting your OS:

```
🌐 Please select your operating system:
Use ↑/↓ arrows to move, Enter to select

> 🍎 MacOS
  🐧 Linux (yum)
  🚢 CBL-Mariner
```

:::tip[That's it!]
The script installs tmux, copies the config, sets up TPM, and installs all plugins automatically.
:::

<details>
<summary><strong>Advanced: Run OS-specific scripts directly</strong></summary>

```bash
./setup_tmux_mac.sh          # macOS with Homebrew
./setup_tmux_linux.sh        # Linux with yum
./setup_tmux_mariner.sh      # CBL-Mariner with tdnf

# CI/non-interactive mode (auto-accepts all prompts)
./setup_tmux_mac.sh --ci
```

</details>

## What You Get

After running the setup script:

- **tmux installed** via your OS package manager
- **Config deployed** to `~/.tmux.conf`
- **TPM installed** at `~/.tmux/plugins/tpm`
- **Plugins auto-installed** — Catppuccin theme, session persistence, nerd font icons
- **Status bar** at the top with Catppuccin styling

**Reload config** after making changes:
```bash
# Inside tmux:
Ctrl+a then r

# From the command line:
tmux source-file ~/.tmux.conf
```

**Verify installation:**
```bash
./scripts/verify_install.sh
```

**Uninstall / reset to defaults:**
```bash
rm ~/.tmux.conf
rm -rf ~/.tmux/plugins
```

## 🚨 My Local Setup

:::tip[Before you copy/paste]

1. I've overridden **Caps Lock** to act as **Ctrl** — it's more ergonomic for tmux's prefix key and for Vim
2. Terminal: **iTerm** + **zsh** ([iTerm](https://iterm2.com))

:::

## Keybindings

> **Prefix key:** `Ctrl+a` (remapped from the default `Ctrl+b`)

### Pane Navigation

| Shortcut | Action |
|---|---|
| `Shift+Arrow` | Move to adjacent pane |
| `Ctrl+Arrow` | Move to adjacent pane (alternative) |
| `Prefix + \|` | Split pane horizontally |
| `Prefix + -` | Split pane vertically |

### Pane Management

| Shortcut | Action |
|---|---|
| `Prefix + Ctrl+Arrow` | Resize pane by 5 units |
| `Prefix + S` | Synchronize (type in all panes at once) |
| `Prefix + x` | Kill current pane |

### Window Navigation

| Shortcut | Action |
|---|---|
| `Alt+Left / Alt+Right` | Previous / next window |
| `Alt+Up / Alt+Down` | Swap window left / right |
| `Prefix + Ctrl+c` | New window |
| `Prefix + Ctrl+n / Ctrl+p` | Next / previous window |
| `Prefix + X` | Kill current window |

### Session & General

| Shortcut | Action |
|---|---|
| `Prefix + r` or `R` | Reload tmux config |
| `Prefix + Ctrl+d` | Detach from session |
| `F7` | Browse sessions/windows tree |

### Copy Mode (vi-style)

| Shortcut | Action |
|---|---|
| `v` | Begin selection |
| `y` | Copy selection |

### F-Key Quick Actions (Byobu-style)

| Key | Action |
|---|---|
| `F1` | Rename current window |
| `F2` | New window |
| `F3` / `F4` | Previous / next window |
| `F5` | Refresh screen |
| `F6` | Detach from session |
| `F7` | Browse session tree |
| `F8` | Swap window |
| `F9` | Kill window |
| `F10` / `F11` | Split pane vertically / horizontally |
| `F12` | Even horizontal layout |

## Plugins

All plugins are managed by [TPM](https://github.com/tmux-plugins/tpm) and installed automatically by the setup script.

| Plugin | Purpose |
|---|---|
| [catppuccin/tmux](https://github.com/catppuccin/tmux) | Catppuccin color theme |
| [tmux-nerd-font-window-name](https://github.com/joshmedeski/tmux-nerd-font-window-name) | Nerd font icons for file types |
| [tmux-resurrect](https://github.com/tmux-plugins/tmux-resurrect) | Save and restore sessions across restarts |
| [tmux-continuum](https://github.com/tmux-plugins/tmux-continuum) | Auto-save sessions every 15 minutes |

To install new plugins after adding them to `tmux.conf`, press **`Prefix + I`** inside tmux.

## Config File

<details>
<summary><strong>View full <code>.tmux.conf</code></strong></summary>

```bash title=".tmux.conf"
# Global Variables
# This is for TPM
set-environment -g TMUX_PLUGIN_MANAGER_PATH "$HOME/.tmux/plugins"

# Instead of the prefix default Ctrl+b, set prefix to be Ctrl+a
set -g prefix C-a

# Enable interactive mouse
set -g mouse on

# Activity Monitoring
set-option -g visual-activity on
setw -g monitor-activity on
setw -g automatic-rename off

# Key Bindings
bind C-a send-prefix
bind | split-window -h
bind - split-window -v
unbind '"'
unbind %

# Reload configuration
bind r source-file ~/.tmux.conf \; display "Reloaded!"
bind R source-file ~/.tmux.conf \; display "Reloaded!"

# Key Bindings for moving between panes using Shift+Arrow keys
bind -n S-Left select-pane -L
bind -n S-Right select-pane -R
bind -n S-Up select-pane -U
bind -n S-Down select-pane -D

# Switching between panes using Ctrl+Arrow keys
bind -n C-Left select-pane -L
bind -n C-Right select-pane -R
bind -n C-Up select-pane -U
bind -n C-Down select-pane -D

# Resize panes using Ctrl+a + Arrow keys
bind -r C-Left resize-pane -L 5
bind -r C-Right resize-pane -R 5
bind -r C-Up resize-pane -U 5
bind -r C-Down resize-pane -D 5

# Move between windows with Option+Cmd+Right/Left Arrow Keys
bind -n M-Left previous-window
bind -n M-Right next-window

# Window swapping with Option+Cmd+Up/Down Arrow keys
bind -n M-Up swap-window -t -1\; previous-window
bind -n M-Down swap-window -t +1\; next-window

# Copy mode key bindings
setw -g mode-keys vi
bind -T copy-mode-vi v send -X begin-selection
bind -T copy-mode-vi y send -X copy-selection-and-cancel

# Synchronize panes
bind S setw synchronize-panes

# Other key bindings
bind-key C-c new-window
bind-key C-n next-window
bind-key C-p previous-window
bind-key C-d detach
bind-key x kill-pane
bind-key X kill-window

# F1-F12 Key Bindings (Byobu-like)
bind-key -n F1 command-prompt "rename-window %%"
bind-key -n F2 new-window
bind-key -n F3 previous-window
bind-key -n F4 next-window
bind-key -n F5 refresh-client
bind-key -n F6 detach
bind-key -n F7 choose-tree
bind-key -n F8 command-prompt "swap-window -t %%"
bind-key -n F9 command-prompt "kill-window"
bind-key -n F10 split-window -v
bind-key -n F11 split-window -h
bind-key -n F12 select-layout even-horizontal

# Set status bar to top
set-option -g status-position top

# Tmux Plugin Manager ##############################
# List of plugins
set -g @plugin 'tmux-plugins/tpm'
# Tmux nerd font window name: https://github.com/joshmedeski/tmux-nerd-font-window-name
set -g @plugin 'joshmedeski/tmux-nerd-font-window-name'
# Catppuccin Tmux theme: https://github.com/catppuccin/tmux
set -g @plugin 'catppuccin/tmux'
# Tmux Resurrect: https://github.com/tmux-plugins/tmux-resurrect
set -g @plugin 'tmux-plugins/tmux-resurrect'
# Tmux continuum: https://github.com/tmux-plugins/tmux-continuum
set -g @plugin 'tmux-plugins/tmux-continuum'

# Tmux continuum settings
set -g @continuum-save-interval '15'
set -g @continuum-restore 'on'

# Catppuccin settings
set -g @catppuccin_window_left_separator ""
set -g @catppuccin_window_right_separator " "
set -g @catppuccin_window_middle_separator " █"
set -g @catppuccin_window_number_position "right"

set -g @catppuccin_window_default_fill "number"
set -g @catppuccin_window_default_text "#W"

set -g @catppuccin_window_current_fill "number"
set -g @catppuccin_window_current_text "#W"

set -g @catppuccin_status_modules_right "directory session"
set -g @catppuccin_status_left_separator  " "
set -g @catppuccin_status_right_separator ""
set -g @catppuccin_status_fill "icon"
set -g @catppuccin_status_connect_separator "no"

set -g @catppuccin_directory_text "#{pane_current_path}"

# Initialize TMUX plugin manager (keep this line at the very bottom of tmux.conf)
run '~/.tmux/plugins/tpm/tpm'
```

</details>

## Why Tmux over Byobu?

1. **Stronger community** — Tmux has more documentation, guides, and community support
2. **Direct control** — Byobu wraps tmux, which can complicate troubleshooting when your question is really a tmux question
3. **Plugin ecosystem** — Vanilla tmux gives you full access to TPM and the plugin ecosystem without abstraction layers

**TL;DR:** Tmux is to Byobu as React is to Angular — more freedom, less opinion.

<details>
<summary><strong>Default tmux config (for reference/reset)</strong></summary>

```
default-command ''
default-shell /bin/zsh
default-size 80x24
destroy-unattached off
detach-on-destroy on
display-panes-active-colour red
display-panes-colour blue
display-panes-time 1000
display-time 750
history-limit 2000
key-table root
lock-after-time 0
lock-command "lock -np"
message-command-style bg=black,fg=yellow
message-line 0
message-style bg=yellow,fg=black
mouse off
prefix C-b
prefix2 None
renumber-windows off
repeat-time 500
set-titles off
set-titles-string "#S:#I:#W - \"#T\" #{session_alerts}"
silence-action other
status on
status-bg default
status-fg default
status-interval 15
status-justify left
status-keys emacs
status-left "[#{session_name}] "
status-left-length 10
status-left-style default
status-position bottom
status-right "#{?window_bigger,[#{window_offset_x}#,#{window_offset_y}] ,}\"#{=21:pane_title}\" %H:%M %d-%b-%y"
status-right-length 40
status-right-style default
status-style bg=green,fg=black
visual-activity off
visual-bell off
visual-silence off
```

</details>

## References

- [Tmux Docs](https://github.com/tmux/tmux/wiki)
- [Tmux Quick Guide](https://hamvocke.com/blog/a-quick-and-easy-guide-to-tmux/)
- [Byobu - A simplified Tmux wrapper](https://www.byobu.org/)
- [iTerm](https://iterm2.com/)
- [Making Tmux Better and Beautiful - YouTube Tutorial](https://www.youtube.com/watch?v=jaI3Hcw-ZaA&t=212s)
