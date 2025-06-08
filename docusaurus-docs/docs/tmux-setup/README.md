---
sidebar_label: "Tmux Setup"
sidebar_position: 1
id: tmux-setup
title: My Tmux Setup
description: My personal Tmux Configuration
---

# Tmux Setup

My personal `tmux.conf` configs and keybindings – inspired by Byobu keybindings (a Tmux wrapper) \
You can view source code [here](https://github.com/kevinreber/tmux-configs/)

## 🔥 Quick script to setup Tmux

Follow steps below to run a script that will install tmux, tpm and setup your configs to match mine 😎
:::tip[Scripts to setup Tmux]
I currently only have created scripts for **MacOS**, **Mariner** and **Linux**

- For **MacOS** use `setup_tmux_mac.sh`
- For **MarinerOS** use `setup_tmux_mariner.sh`
- For **Linux** use `setup_tmux_linux.sh`
  :::

Example using **MacOS** script

```sh
# 1. Clone repo
$ git clone https://github.com/kevinreber/tmux-configs.git

# 2. Change directory
$ cd tmux-configs

# 3. Make sure script is executable
tmux-configs $ chmod +x setup_tmux_mac.sh

# 4. Run script
tmux-configs $ ./setup_tmux_mac.sh
```

## 🚨 DISCLAIMER

:::tip[My local setup]

Some disclaimers before blindly copy/pasting my **.tmux.conf** file below

1. I have overridden my **"Caps Locks"** button to be **"Ctrl"**. Why do I do this?

   - I rarely use my **"Caps Locks"** button to toggle character casing
   - It feels more ergonomically friendly when setting prefixes and using specific keybindings in Tmux (and if you're a Vim user 😉)

2. For my terminal and shell I am using **iTerm + zsh** (see [iTerm](https://iterm2.com))
   :::

## 💻 Installing Tmux

Linux (CentOS)

```bash
sudo yum install tmux
```

Mac (Homebrew)

```bash
brew install tmux
```

## 📄 My `.tmux.conf` file

Note: A lot of these keybindings are very similar to Byobu's default settings
`tmux.conf`

```bash title=".tmux.conf"
# Global Variables
# This is for TPM
set-environment -g TMUX_PLUGIN_MANAGER_PATH "$HOME/.tmux/plugins"

# Instead of the prefix default Ctrl+b, set prefix to be Ctrl+a
# Why do this? My Caps Lock button is set to also be Ctrl, so I feel this is more ergonomically comfortable
set -g prefix C-a

# Enable interactive mouse
set -g mouse on

# Byobu-like tmux configuration below

# I use a theme for styling, so I don't use the Byobu default styling 😄 ############################################
# General Settings
# set -g default-terminal "screen-256color"
# set -g history-limit 10000
# set -g base-index 1
# setw -g pane-base-index 1
# set -g renumber-windows on
# set -s escape-time 0

# Status Bar Settings
# set -g status-bg colour234
# set -g status-fg white
# set -g status-interval 5
# set -g status-left-length 32
# set -g status-right-length 150
# set -g status-left '#[fg=colour16,bg=colour254,bold] #S #[fg=colour254,bg=colour238,nobold]#[fg=colour238,bg=colour234,nobold]#[fg=colour143,bg=colour018,nobold] #h |'
# set -g status-right '#[fg=colour16,bg=colour254,bold] %R #[fg=colour245] %d %b #[fg=colour16,bg=colour254,bold] #h '
# set -g window-status-format "#[fg=white,bg=colour234] #I #W "
# set -g window-status-current-format "#[fg=colour234,bg=colour39]#[fg=colour16,bg=colour39,noreverse,bold] #I ❭ #W #[fg=colour39,bg=colour234,nobold]"

# Pane Borders
# set-option -g pane-active-border-style "bg=black,fg=green"
# set-option -g pane-border-style "bg=default,fg=white"
# End of Byobu default styling ############################################

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

# Set status bar to top – I like to see my status bar on the top, this can be helpful when using VIM
set-option -g status-position top

# Tmux Plugin Manager ##############################
# List of plugins
set -g @plugin 'tmux-plugins/tpm'
# Tmux nerd font window name: https://github.com/joshmedeski/tmux-nerd-font-window-name
set -g @plugin 'joshmedeski/tmux-nerd-font-window-name'
# Catpuccin Tmux theme: https://github.com/catppuccin/tmux
set -g @plugin 'catppuccin/tmux'
# Tmux Resurrect: https://github.com/tmux-plugins/tmux-resurrect
set -g @plugin 'tmux-plugins/tmux-resurrect'
# Tmux continuum: https://github.com/tmux-plugins/tmux-continuum
set -g @plugin 'tmux-plugins/tmux-continuum'

# Tmux continuum intervalsettings
set -g @continuum-save-interval '15'
set -g @continuum-restore 'on'

# Catpuccin settings - Config 3
set -g @catppuccin_window_left_separator ""
set -g @catppuccin_window_right_separator " "
set -g @catppuccin_window_middle_separator " █"
set -g @catppuccin_window_number_position "right"

set -g @catppuccin_window_default_fill "number"
set -g @catppuccin_window_default_text "#W"

set -g @catppuccin_window_current_fill "number"
set -g @catppuccin_window_current_text "#W"

set -g @catppuccin_status_modules_right "directory session"
set -g @catppuccin_status_left_separator  " "
set -g @catppuccin_status_right_separator ""
set -g @catppuccin_status_fill "icon"
set -g @catppuccin_status_connect_separator "no"

set -g @catppuccin_directory_text "#{pane_current_path}"

# Initialize TMUX plugin manager (keep this line at the very bottom of tmux.conf)
run '~/.tmux/plugins/tpm/tpm'
```

### Key Binding Descriptions

- Shift+Left (S-Left): Move to the pane on the left.
- Shift+Right (S-Right): Move to the pane on the right.
- Shift+Up (S-Up): Move to the pane above.
- Shift+Down (S-Down): Move to the pane below.
- Ctrl+Left (C-Left): Move to the pane on the left.
- Ctrl+Right (C-Right): Move to the pane on the right.
- Ctrl+Up (C-Up): Move to the pane above.
- Ctrl+Down (C-Down): Move to the pane below.

### F-Key Binding Descriptions

- F1: Rename the current window.
- F2: Create a new window.
- F3: Go to the previous window.
- F4: Go to the next window.
- F5: Refresh the client (redraw the screen).
- F6: Detach from the current session.
- F7: Display a tree of windows and panes.
- F8: Swap the current window with another.
- F9: Kill the current window.
- F10: Split the current pane horizontally.
- F11: Split the current pane vertically.
- F12: Arrange panes in an even horizontal layout.

## 🔌 Tmux Plugins

Installing `tmux-plugins`

```bash
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```

I like to use Catpuccin as my Tmux theme

### Tmux nerd font window name

Special icons for programming files
Installation guide: https://github.com/joshmedeski/tmux-nerd-font-window-name

### Tmux Theme Catpuccin

Styling theme
Installation guide: https://github.com/catppuccin/tmux

### Catpuccin Requirements

Catpuccin uses Nerd Fonts as their default font.
You can download the Hack Nerd Font (or any other preferred Nerd Font) from the Nerd Fonts repository locally:
via shell

```bash
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/Hack.zip
unzip Hack.zip -d ~/Library/Fonts/
```

or via Homebrew

```bash
brew tap homebrew/cask-fonts
brew install --cask font-hack-nerd-font
```

After installing Nerd Fonts, make sure to set you iTerm Profile font to `Hack Nerd Font`

## 🤔 Why not just use Byobu instead of Tmux?

1. While Byobu is great out the box and can do everything Tmux can, I feel the documentation and community is not as strong as Tmux.
2. In my experience whenever I think I have a "Byobu related question" it ends up being more of a "Tmux related question" and having Byobu as a wrapper can sometimes complicate the solution I'm looking for. At that point I might as well only be using Tmux.
3. Byobu does abstract a lot from Tmux and makes thing simple, but it's simplicity also limits the use of plugins and customizations that you can get with "vanilla" Tmux.

### TLDR;

The Tmux and Byobu relationship is almost like a React vs Angular question. React gives you more freedom while Angular is great out the box but more opinionated on how things are executed.

## 🔧 Default Tmux Configs

If you ever need to reference or reset your tmux configs, this is the default `tmux.conf`

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
status-format[0] "#[align=left range=left #{E:status-left-style}]#[push-default]#{T;=/#{status-left-length}:status-left}#[pop-default]#[norange default]#[list=on align=#{status-justify}]#[list=left-marker]<#[list=right-marker]>#[list=on]#{W:#[range=window|#{window_index} #{E:window-status-style}#{?#{&&:#{window_last_flag},#{!=:#{E:window-status-last-style},default}}, #{E:window-status-last-style},}#{?#{&&:#{window_bell_flag},#{!=:#{E:window-status-bell-style},default}}, #{E:window-status-bell-style},#{?#{&&:#{||:#{window_activity_flag},#{window_silence_flag}},#{!=:#{E:window-status-activity-style},default}}, #{E:window-status-activity-style},}}]#[push-default]#{T:window-status-format}#[pop-default]#[norange default]#{?window_end_flag,,#{window-status-separator}},#[range=window|#{window_index} list=focus #{?#{!=:#{E:window-status-current-style},default},#{E:window-status-current-style},#{E:window-status-style}}#{?#{&&:#{window_last_flag},#{!=:#{E:window-status-last-style},default}}, #{E:window-status-last-style},}#{?#{&&:#{window_bell_flag},#{!=:#{E:window-status-bell-style},default}}, #{E:window-status-bell-style},#{?#{&&:#{||:#{window_activity_flag},#{window_silence_flag}},#{!=:#{E:window-status-activity-style},default}}, #{E:window-status-activity-style},}}]#[push-default]#{T:window-status-current-format}#[pop-default]#[norange list=on default]#{?window_end_flag,,#{window-status-separator}}}#[nolist align=right range=right #{E:status-right-style}]#[push-default]#{T;=/#{status-right-length}:status-right}#[pop-default]#[norange default]"
status-format[1] "#[align=centre]#{P:#{?pane_active,#[reverse],}#{pane_index}[#{pane_width}x#{pane_height}]#[default] }"
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
update-environment[0] DISPLAY
update-environment[1] KRB5CCNAME
update-environment[2] SSH_ASKPASS
update-environment[3] SSH_AUTH_SOCK
update-environment[4] SSH_AGENT_PID
update-environment[5] SSH_CONNECTION
update-environment[6] WINDOWID
update-environment[7] XAUTHORITY
visual-activity off
visual-bell off
visual-silence off
word-separators "!\"#$%&'()*+,-./:;<=>?@[\\]^`{|}~"
```

## 📚 References

- [Tmux Docs](https://github.com/tmux/tmux/wiki)
- [Tmux Quick Guide](https://hamvocke.com/blog/a-quick-and-easy-guide-to-tmux/)
- [Byobu - A simplified Tmux wrapper](https://www.byobu.org/)
- [iTerm](https://iterm2.com/)
- [Making Tmux Better and Beautiful - YouTube Tutorial](https://www.youtube.com/watch?v=jaI3Hcw-ZaA&t=212s)
