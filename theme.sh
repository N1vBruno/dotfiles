#!/bin/env bash
theme="$HOME/.config/alacritty/theme.yml"
dark="$HOME/.config/alacritty/dark.yml"
light="$HOME/.config/alacritty/light.yml"
tconf="$HOME/.config/tmux/tmux.conf"

[[ -f "$theme" || -f "$HOME/.config/tmux/tmux.conf" ]] || exit

isDark=$(sleep 0.05 && gsettings get org.gnome.desktop.interface color-scheme)

chAlacritty() {
  if [[ "$isDark" =~ "dark" ]]; then
    grep -q -m1 "[lL]ight" "$theme" || return
    mv "$theme" "$light"
    mv "$dark" "$theme"
  elif [[ "$isDark" =~ "default" ]]; then
    grep -q -m1 "[dD]ark" "$theme" || return
    mv "$theme" "$dark"
    mv "$light" "$theme"
  fi
}

chTmux() {
  if grep -q -m1 "[lL]ight" "$theme"; then
    sed -i "s/\(status-style fg=colour\)254/\1235/g" "$tconf"
  elif grep -q -m1 "[dD]ark" "$theme"; then
    sed -i "s/\(status-style fg=colour\)235/\1254/g" "$tconf"
  fi
  tmux source-file "$tconf"
}

chAlacritty
chTmux
