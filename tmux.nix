{tmux, tmuxPlugins}:

let
  pluginList = with tmuxPlugins; [
    battery
    continuum
    copycat
    cpu
    fpp
    open
    pain-control
    prefix-highlight
    resurrect
    sensible
    sessionist
    yank
  ];
  pluginNames = builtins.map (p:
    let pName = p.pluginName;
        pFile = builtins.replaceStrings ["-"] ["_"] pName;
    in "run-shell ${p}/share/tmux-plugins/${pName}/${pFile}.tmux"
  ) pluginList;
  pluginConf = builtins.concatStringsSep "\n" pluginNames;
in {
  plugins = pluginList;
  config = ''
  # status update interval
  set -g status-interval 5

  # Basic status bar colors
  set -g status-style bg=black,fg=colour245

  set -g status-left-style bg=colour8,fg=white,bold
  set -g status-left-length 32
  set -g status-left " ❐ #S "

  set -g @prefix_highlight_empty_prompt 'default'
  set -g @prefix_highlight_bg 'green'

  set -g status-right-style bg=colour236,fg=white
  set -g status-right-length 128
  set -g status-right "#{prefix_highlight} #H « CPU: #{cpu_percentage} « Batt: #{battery_percentage} (#{battery_remain}) « %H:%M %d-%b-%y"

  # Window status
  set -g window-status-format "#I:#W#F"
  set -g window-status-current-format "#I:#W#F"

  # Last window style
  set -g window-status-last-style bg=black,fg=white

  # Current window status
  set -g window-status-current-style bg=green,fg=black

  # Window with activity status
  set -g window-status-activity-style bg=black,fg=green

  # Window with bell style
  set -g window-status-bell-style bg=black,fg=colour154

  # Window separator
  set -g window-status-separator " "

  # Window status alignment
  set -g status-justify left

  # Pane border
  set -g pane-border-style bg=default,fg=white

  # Active pane border
  set -g pane-active-border-style bg=default,fg=green

  # Pane number indicator
  set -g display-panes-colour white
  set -g display-panes-active-colour yellow

  # Clock mode
  set -g clock-mode-colour white
  set -g clock-mode-style 24

  # Message
  set -g message-style bg=yellow,fg=black

  # Command message
  set -g message-command-style bg=green,fg=black

  # Mode
  set -g mode-style bg=yellow,fg=black

  # Load plugins
  '' + pluginConf;
}
