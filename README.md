# tmux configs
Personal `tmux.conf` keybindings – inspired from byobu (tmux wrapper)

## FYI
I rarely use my `Caps Locks` button for what it's originally intended for so I've overrided it to be `Ctrl` which I feel is more ergonomically friendly when setting prefixes and using spefic keybindings.

## References
- Tmux Docs: https://github.com/tmux/tmux/wiki
- Learn how to use tmux: https://hamvocke.com/blog/a-quick-and-easy-guide-to-tmux/
- Byobu - A simplified tmux wrapper: https://www.byobu.org/

## My keybindings

`tmux.conf`
```bash
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

# Move between windows
bind -n M-Left previous-window
bind -n M-Right next-window

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

# Tmux Plugin Manager ##############################
# List of plugins
set -g @plugin 'tmux-plugins/tpm'
# Tmux nerd font window name: https://github.com/joshmedeski/tmux-nerd-font-window-name
set -g @plugin 'joshmedeski/tmux-nerd-font-window-name'
# Catpuccin Tmux theme: https://github.com/catppuccin/tmux
set -g @plugin 'catppuccin/tmux'

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

*Key Binding Descriptions*
- Shift+Left (S-Left): Move to the pane on the left.
- Shift+Right (S-Right): Move to the pane on the right.
- Shift+Up (S-Up): Move to the pane above.
- Shift+Down (S-Down): Move to the pane below.
- Ctrl+Left (C-Left): Move to the pane on the left.
- Ctrl+Right (C-Right): Move to the pane on the right.
- Ctrl+Up (C-Up): Move to the pane above.
- Ctrl+Down (C-Down): Move to the pane below.

*F-Key Binding Descriptions*
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

# Tmux Plugins
I like to use Catpuccin as my Tmux theme

## Tmux nerd font window name
Special icons for programming files
Installation guide: https://github.com/joshmedeski/tmux-nerd-font-window-name

## Theme – Catpuccin
Styling theme
Installation guide: https://github.com/catppuccin/tmux

### Requirements
Catpuccin uses Nerd Fonts as their default font.
You can download the Hack Nerd Font (or any other preferred Nerd Font) from the Nerd Fonts repository:
via shell
```bash
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/Hack.zip
unzip Hack.zip -d ~/Library/Fonts/
```
or via homebrew
```bash
brew tap homebrew/cask-fonts
brew install --cask font-hack-nerd-font
```
After installing Nerd Fonts, make sure to set you iTerm Profile font to `Hack Nerd Font`
