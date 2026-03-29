#!/usr/bin/env sh

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
RESET='\033[0m'
BOLD='\033[1m'

# Packages
PACKAGES=(
  "ascii-faces:.ascii.faces:ASCII emoticons collection"
  "browsh:browsh config:Terminal web browser"
  "ghostty:ghostty config:Terminal emulator"
  "gitui:gitui keybindings:Git TUI"
  "helix:helix editor:Modern modal editor"
  "hypr:Hyprland config:Wayland compositor"
  "mov-cli:mov-cli config:Movie/show CLI"
  "nixvim:NixVim config:Neovim via Nix"
  "nvim:Neovim config:Classic Neovim setup"
  "starship:starship.toml:Shell prompt"
  "tmux:tmux config:Terminal multiplexer"
  "wezterm:.wezterm.lua:GPU-accelerated terminal"
  "wofi:wofi config:Wayland app launcher"
  "zshrc:.zshrc:Zsh configuration"
  "mpv:mpv:Lightweight media player"
)

# OS Selection Menu
OS_OPTIONS=(
  "arch:Arch Linux / Manjaro / EndeavourOS:pacman"
  "debian:Debian / Ubuntu / Pop!_OS / Linux Mint:apt"
  "fedora:Fedora / RHEL / CentOS:dnf"
  "opensuse:openSUSE:zypper"
  "void:Void Linux:xbps"
  "gentoo:Gentoo:emerge"
  "alpine:Alpine Linux:apk"
  "nixos:NixOS:nix"
  "macos:macOS:brew"
  "other:Other (manual):none"
)

# OS Detection
detect_os() {
  if [ -f /etc/os-release ]; then
    . /etc/os-release
    echo "$ID"
  elif [[ "$OSTYPE" == "darwin"* ]]; then
    echo "macos"
  else
    echo "unknown"
  fi
}

# Package manager detection
get_package_manager() {
  local os=$1
  case "$os" in
    arch|manjaro|endeavouros) echo "pacman" ;;
    debian|ubuntu|pop|linuxmint) echo "apt" ;;
    fedora|rhel|centos) echo "dnf" ;;
    opensuse*) echo "zypper" ;;
    void) echo "xbps" ;;
    gentoo) echo "emerge" ;;
    alpine) echo "apk" ;;
    nixos) echo "nix" ;;
    macos) echo "brew" ;;
    *) echo "unknown" ;;
  esac
}

# Install command based on package manager
get_install_cmd() {
  local pm=$1
  case "$pm" in
    pacman) echo "sudo pacman -S --noconfirm" ;;
    apt) echo "sudo apt install -y" ;;
    dnf) echo "sudo dnf install -y" ;;
    zypper) echo "sudo zypper install -y" ;;
    xbps) echo "sudo xbps-install -S" ;;
    emerge) echo "sudo emerge --ask" ;;
    apk) echo "sudo apk add" ;;
    nix) echo "" ;;
    brew) echo "brew install" ;;
    *) echo "" ;;
  esac
}

# Check for required commands
check_requirements() {
  local missing=()
  for cmd in git stow; do
    if ! command -v "$cmd" >/dev/null 2>&1; then
      missing+=("$cmd")
    fi
  done
  
  if [ ${#missing[@]} -gt 0 ]; then
    echo -e "${RED}Error: Missing required command(s): ${missing[*]}${RESET}"
    echo -e "Please install them first:"
    echo -e "  ${BOLD}git${RESET} - version control"
    echo -e "  ${BOLD}stow${RESET} - dotfile manager"
    exit 1
  fi
}

# Terminal control functions
hide_cursor() { printf '\033[?25l'; }
show_cursor() { printf '\033[?25h'; }
clear_screen() { printf '\033[2J\033[H'; }

# Cleanup on exit
cleanup() {
  show_cursor
  stty echo
  printf '\n'
}
trap cleanup EXIT INT TERM

# Read single key
read_key() {
  local key key2 key3
  IFS= read -rsn1 key
  if [ -z "$key" ]; then
    echo "enter"; return
  fi
  if [ "$key" = $'\e' ]; then
    IFS= read -rsn1 -t 0.01 key2
    if [ "$key2" = "[" ]; then
      IFS= read -rsn1 -t 0.01 key3
      case "$key3" in
        A) echo "up"; return ;;
        B) echo "down"; return ;;
        C) echo "right"; return ;;
        D) echo "left"; return ;;
        Z) echo "shift-tab"; return ;;
      esac
    elif [ -n "$key2" ]; then
      case "$key2" in
        n) echo "alt-n"; return ;;
        p) echo "alt-p"; return ;;
      esac
    fi
    echo "escape"; return
  fi
  case "$key" in
    k|K) echo "up" ;;
    j|J) echo "down" ;;
    h|H) echo "left" ;;
    l|L) echo "right" ;;
    a|A) echo "toggle-all" ;;
    d|D) echo "dry-run" ;;
    q|Q) echo "quit" ;;
    ' ') echo "space" ;;
    *)
      val=$(printf "%d" "'$key" 2>/dev/null)
      if [ -n "$val" ]; then
        case $val in
          9) echo "tab" ;;
          10|13) echo "enter" ;;
          14) echo "alt-n" ;;
          16) echo "alt-p" ;;
          2) echo "left" ;;
          6) echo "right" ;;
          *) echo "unknown" ;;
        esac
      else
        echo "unknown"
      fi
      ;;
  esac
}

# Initialize selected state
declare -A SELECTED
for i in "${!PACKAGES[@]}"; do
  SELECTED[$i]=0
done
CURRENT=0
TOTAL=${#PACKAGES[@]}

# Draw the package selection menu
draw_menu() {
  clear_screen
  echo -e "${BOLD}${CYAN}╔══════════════════════════════════════════════════════════════╗${RESET}"
  echo -e "${BOLD}${CYAN}║${RESET}  ${BOLD}Dotfiles Interactive Installer${RESET}                         ${BOLD}${CYAN}║${RESET}"
  echo -e "${BOLD}${CYAN}╚══════════════════════════════════════════════════════════════╝${RESET}"
  echo ""
  echo -e "${YELLOW}OS:${RESET} $OS_NAME ($PKG_MANAGER)"
  echo -e "${YELLOW}Navigate:${RESET} ↑↓/hjkl/Ctrl-n,p/Tab/Alt-n,p  ${YELLOW}Select:${RESET} Space  ${YELLOW}Toggle:${RESET} a  ${YELLOW}Dry-run:${RESET} d  ${YELLOW}Install:${RESET} Enter"
  echo ""
  for i in "${!PACKAGES[@]}"; do
    IFS=':' read -r dir file desc <<< "${PACKAGES[$i]}"
    [ ${SELECTED[$i]} -eq 1 ] && checkbox="${GREEN}[✓]${RESET}" || checkbox="[ ]"
    if [ $i -eq $CURRENT ]; then
      echo -e "  ${BOLD}${BLUE}>${RESET} $checkbox ${BOLD}$dir${RESET} - $desc"
    else
      echo -e "    $checkbox $dir - $desc"
    fi
  done
  echo ""
  local selected_count=0
  for val in "${SELECTED[@]}"; do selected_count=$((selected_count + val)); done
  echo -e "${CYAN}Selected: $selected_count/$TOTAL${RESET}"
}

menu_loop() {
  hide_cursor
  stty -echo
  while true; do
    draw_menu
    key=$(read_key)
    case "$key" in
      up|alt-p|left) CURRENT=$((CURRENT - 1)); [ $CURRENT -lt 0 ] && CURRENT=$((TOTAL - 1));;
      down|alt-n|tab|right) CURRENT=$((CURRENT + 1)); [ $CURRENT -ge $TOTAL ] && CURRENT=0;;
      shift-tab) CURRENT=$((CURRENT - 1)); [ $CURRENT -lt 0 ] && CURRENT=$((TOTAL - 1));;
      space) SELECTED[$CURRENT]=$((1 - ${SELECTED[$CURRENT]}));;
      toggle-all)
        local all_selected=1
        for val in "${SELECTED[@]}"; do [ $val -eq 0 ] && all_selected=0; done
        for i in "${!SELECTED[@]}"; do SELECTED[$i]=$((1 - all_selected)); done
        ;;
      d) show_cursor; stty echo; dry_run_packages; hide_cursor; stty -echo;;
      enter) show_cursor; stty echo; return 0;;
      quit) show_cursor; stty echo; echo -e "\n${YELLOW}Installation cancelled.${RESET}"; exit 0;;
    esac
  done
}

# Show what stow will do without making changes
dry_run_packages() {
  clear_screen
  echo -e "${BOLD}${CYAN}╔══════════════════════════════════════════════════════════════╗${RESET}"
  echo -e "${BOLD}${CYAN}║${RESET}  ${BOLD}Dry Run Preview${RESET}                                          ${BOLD}${CYAN}║${RESET}"
  echo -e "${BOLD}${CYAN}╚══════════════════════════════════════════════════════════════╝${RESET}"
  echo ""
  echo -e "${YELLOW}The following packages will be processed:${RESET}\n"
  
  local count=0
  for i in "${!PACKAGES[@]}"; do
    if [ ${SELECTED[$i]} -eq 1 ]; then
      IFS=':' read -r dir file desc <<< "${PACKAGES[$i]}"
      count=$((count + 1))
      if [ -d "$dir" ]; then
        echo -e "  ${GREEN}[✓]${RESET} $dir - $desc"
        echo -e "     ${CYAN}Files to be symlinked from:${RESET} $PWD/$dir"
      else
        echo -e "  ${RED}[✗]${RESET} $dir - $desc ${RED}(directory not found)${RESET}"
      fi
    fi
  done
  
  if [ $count -eq 0 ]; then
    echo -e "  ${YELLOW}No packages selected${RESET}"
  fi
  
  echo ""
  read -p "Press Enter to continue..." _
}

select_os() {
  local current=0 total=${#OS_OPTIONS[@]} detected_os=$(detect_os)
  for i in "${!OS_OPTIONS[@]}"; do
    IFS=':' read -r os_id _ _ <<< "${OS_OPTIONS[$i]}"
    [ "$os_id" = "$detected_os" ] && current=$i && break
  done
  hide_cursor
  stty -echo
  while true; do
    clear_screen
    echo -e "${BOLD}${CYAN}╔══════════════════════════════════════════════════════════════╗${RESET}"
    echo -e "${BOLD}${CYAN}║${RESET}  ${BOLD}Select Your Operating System${RESET}                           ${BOLD}${CYAN}║${RESET}"
    echo -e "${BOLD}${CYAN}╚══════════════════════════════════════════════════════════════╝${RESET}"
    echo ""
    [ "$detected_os" != "unknown" ] && echo -e "${GREEN}Detected:${RESET} $detected_os (auto-selected if available)\n"
    echo -e "${YELLOW}Navigate:${RESET} ↑↓/hjkl/Ctrl-n,p/Tab/Alt-n,p  ${YELLOW}Select:${RESET} Enter  ${YELLOW}Quit:${RESET} q"
    echo ""
    for i in "${!OS_OPTIONS[@]}"; do
      IFS=':' read -r os_id os_name pkg_mgr <<< "${OS_OPTIONS[$i]}"
      if [ $i -eq $current ]; then
        echo -e "  ${BOLD}${BLUE}>${RESET} ${BOLD}$os_name${RESET} ${CYAN}($pkg_mgr)${RESET}"
      else
        echo -e "    $os_name ${CYAN}($pkg_mgr)${RESET}"
      fi
    done
    echo ""
    key=$(read_key)
    case "$key" in
      up|alt-p|left|shift-tab) current=$((current - 1)); [ $current -lt 0 ] && current=$((total - 1));;
      down|alt-n|tab|right) current=$((current + 1)); [ $current -ge $total ] && current=0;;
      enter) show_cursor; stty echo; IFS=':' read -r OS OS_NAME PKG_MANAGER <<< "${OS_OPTIONS[$current]}"; return 0;;
      quit) show_cursor; stty echo; echo -e "\n${YELLOW}Installation cancelled.${RESET}"; exit 0;;
    esac
  done
}

install_packages() {
  clear_screen
  echo -e "${BOLD}${CYAN}╔══════════════════════════════════════════════════════════════╗${RESET}"
  echo -e "${BOLD}${CYAN}║${RESET}  ${BOLD}Installing Dotfiles${RESET}                                     ${BOLD}${CYAN}║${RESET}"
  echo -e "${BOLD}${CYAN}╚══════════════════════════════════════════════════════════════╝${RESET}"
  echo ""

  # NixOS special handling - declarative only
  if [ "$OS" = "nixos" ]; then
    echo -e "${YELLOW}Detected NixOS.${RESET}"
    echo ""
    echo -e "${CYAN}NixOS uses a declarative configuration approach.${RESET}"
    echo -e "${CYAN}This script will only deploy dotfiles via stow.${RESET}"
    echo ""
    echo -e "${YELLOW}Prerequisites:${RESET}"
    echo -e "  1. Add ${BOLD}git${RESET} and ${BOLD}stow${RESET} to your ${BOLD}/etc/nixos/configuration.nix${RESET}:"
    echo ""
    echo -e "${GREEN}  environment.systemPackages = with pkgs; [${RESET}"
    echo -e "${GREEN}    git${RESET}"
    echo -e "${GREEN}    stow${RESET}"
    echo -e "${GREEN}  ];${RESET}"
    echo ""
    echo -e "  2. Rebuild your system:"
    echo -e "${BOLD}  sudo nixos-rebuild switch${RESET}"
    echo ""
    echo -e "${YELLOW}Then run this installer to deploy your dotfiles.${RESET}"
    echo ""
    read -p "Press Enter to continue..." _
  else
    if ! command -v stow >/dev/null 2>&1; then
      echo -e "${YELLOW}Installing GNU Stow...${RESET}"
      if [ -n "$INSTALL_CMD" ]; then
        eval "$INSTALL_CMD stow"
      else
        echo -e "${RED}Error: Cannot install stow - unknown package manager${RESET}"
        exit 1
      fi
    fi
  fi

  local installed=0 failed=0
  for i in "${!PACKAGES[@]}"; do
    if [ ${SELECTED[$i]} -eq 1 ]; then
      IFS=':' read -r dir file desc <<< "${PACKAGES[$i]}"
      echo -e "\n${BLUE}[$(($installed + $failed + 1))] Installing: ${BOLD}$dir${RESET} - $desc"
      if [ -d "$dir" ]; then
        if output=$(stow "$dir" 2>&1); then
          echo -e "  ${GREEN}✓${RESET} Successfully installed $dir"
          installed=$((installed + 1))
        else
          echo -e "  ${RED}✗${RESET} Stow failed for $dir"
          echo -e "  ${YELLOW}Error:${RESET} $output"
          echo ""
          echo -e "  ${CYAN}Options:${RESET}"
          echo -e "    1) Continue with next package (default)"
          echo -e "    2) Backup existing files and retry"
          echo -e "    3) Skip this package"
          read -p "  Choose option [1-3]: " choice
          case "$choice" in
            2)
              if backup_dir=$(mktemp -d); then
                if cp -r "$HOME/.config/$dir" "$backup_dir/" 2>/dev/null; then
                  echo -e "  ${GREEN}✓${RESET} Backed up to $backup_dir"
                  rm -rf "$HOME/.config/$dir"
                  if stow "$dir" 2>/dev/null; then
                    echo -e "  ${GREEN}✓${RESET} Successfully installed after backup"
                    installed=$((installed + 1))
                  else
                    echo -e "  ${RED}✗${RESET} Installation still failed"
                    failed=$((failed + 1))
                  fi
                else
                  echo -e "  ${RED}✗${RESET} Backup failed"
                  failed=$((failed + 1))
                fi
              fi
              ;;
            3)
              echo -e "  ${YELLOW}⊘${RESET} Skipped $dir"
              ;;
            *)
              failed=$((failed + 1))
              ;;
          esac
        fi
      else
        echo -e "  ${RED}✗${RESET} Directory $dir not found"
        failed=$((failed + 1))
      fi
    fi
  done

  echo ""
  echo -e "${BOLD}${CYAN}╔══════════════════════════════════════════════════════════════╗${RESET}"
  echo -e "${BOLD}${CYAN}║${RESET}  ${BOLD}Installation Complete${RESET}                                   ${BOLD}${CYAN}║${RESET}"
  echo -e "${BOLD}${CYAN}╚══════════════════════════════════════════════════════════════╝${RESET}"
  echo -e "${GREEN}Successfully installed:${RESET} $installed"
  [ $failed -gt 0 ] && echo -e "${RED}Failed:${RESET} $failed"
  echo ""
}

main() {
  if [ ! -f "README.md" ] || [ ! -d "nixvim" ]; then
    echo -e "${RED}Error: Please run this script from your dotfiles directory${RESET}"
    exit 1
  fi
  check_requirements
  select_os
  INSTALL_CMD=$(get_install_cmd "$PKG_MANAGER")
  menu_loop
  install_packages
}

main "$@"
