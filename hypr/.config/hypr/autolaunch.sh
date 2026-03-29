#!/usr/bin/env zsh

# SWWW Wallpaper Manager
swww-daemon &
swww img ~/Pictures/Wallpapers/Nix Anime Girl.jpg

# Waybar
waybar &

# SwayNC
swaync &

# Hyprlock
hyprlock &

# Hypridle
hypridle &

# Cliphist
wl-paste --type text --watch cliphist store &
wl-paste --type image --watch cliphist store &

# Ollama (for some services)
ollama serve &
