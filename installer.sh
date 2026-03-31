#!/usr/bin/env sh

set -e

# ─────────────────────────────────────────────────────────────
#  Colors & Styles
# ─────────────────────────────────────────────────────────────
RESET='\033[0m'
BOLD='\033[1m'
DIM='\033[2m'
ITALIC='\033[3m'

# Foreground
BLACK='\033[30m'
RED='\033[31m'
GREEN='\033[32m'
YELLOW='\033[33m'
BLUE='\033[34m'
MAGENTA='\033[35m'
CYAN='\033[36m'
WHITE='\033[37m'

# Bright foreground
BRED='\033[91m'
BGREEN='\033[92m'
BYELLOW='\033[93m'
BBLUE='\033[94m'
BMAGENTA='\033[95m'
BCYAN='\033[96m'
BWHITE='\033[97m'

# Background
BG_BLACK='\033[40m'
BG_BLUE='\033[44m'
BG_MAGENTA='\033[45m'
BG_CYAN='\033[46m'

# ─────────────────────────────────────────────────────────────
#  Packages  (key:display-name:description:category)
# ─────────────────────────────────────────────────────────────
PACKAGES=(
  "ascii-faces:ascii.faces:ASCII emoticons collection:shell"
  "browsh:browsh:Terminal web browser:shell"
  "ghostty:ghostty:Terminal emulator:terminal"
  "gitui:gitui:Git TUI:dev"
  "helix:helix:Modern modal editor:editor"
  "hypr:Hyprland:Wayland compositor:wm"
  "mov-cli:mov-cli:Movie/show CLI:media"
  "nixvim:NixVim:Neovim distro controlled by Nix:editor"
  "nvim:Neovim:Classic Neovim setup:editor"
  "starship:starship:Shell prompt:shell"
  "tmux:tmux:Terminal multiplexer:terminal"
  "wezterm:wezterm:GPU-accelerated terminal:terminal"
  "wofi:wofi:Wayland app launcher:wm"
  "zshrc:zshrc:Zsh configuration:shell"
  "mpv:mpv:Lightweight media player:media"
  "fastfetch:fastfetch:A popular Neofetch successor:hardware"
)

# Category colors
cat_color() {
  case "$1" in
    editor)   echo "$BMAGENTA" ;;
    terminal) echo "$BCYAN"    ;;
    shell)    echo "$BGREEN"   ;;
    dev)      echo "$BYELLOW"  ;;
    wm)       echo "$BBLUE"    ;;
    media)    echo "$BRED"     ;;
    hardware) echo "$BWHITE"   ;;
    *)        echo "$BWHITE"   ;;
  esac
}

cat_icon() {
  case "$1" in
    editor)   echo "✎" ;;
    terminal) echo "⬡" ;;
    shell)    echo "❯" ;;
    dev)      echo "⌥" ;;
    wm)       echo "⬢" ;;
    media)    echo "▶" ;;
    hardware) echo " " ;;
    *)        echo "•" ;;
  esac
}

# ─────────────────────────────────────────────────────────────
#  OS Options
# ─────────────────────────────────────────────────────────────
OS_OPTIONS=(
  "arch:Arch / Manjaro / EndeavourOS:pacman"
  "debian:Debian / Ubuntu / Pop!_OS / Mint:apt"
  "fedora:Fedora / RHEL / CentOS:dnf"
  "opensuse:openSUSE:zypper"
  "void:Void Linux:xbps"
  "gentoo:Gentoo:emerge"
  "alpine:Alpine Linux:apk"
  "nixos:NixOS:nix"
  "macos:macOS:brew"
  "other:Other (manual):none"
)

# ─────────────────────────────────────────────────────────────
#  OS / Package-manager helpers
# ─────────────────────────────────────────────────────────────
detect_os() {
  if [ -f /etc/os-release ]; then
    . /etc/os-release; echo "$ID"
  elif [[ "$OSTYPE" == "darwin"* ]]; then
    echo "macos"
  else
    echo "unknown"
  fi
}

get_package_manager() {
  case "$1" in
    arch|manjaro|endeavouros) echo "pacman" ;;
    debian|ubuntu|pop|linuxmint) echo "apt"  ;;
    fedora|rhel|centos)        echo "dnf"    ;;
    opensuse*)                 echo "zypper" ;;
    void)                      echo "xbps"   ;;
    gentoo)                    echo "emerge" ;;
    alpine)                    echo "apk"    ;;
    nixos)                     echo "nix"    ;;
    macos)                     echo "brew"   ;;
    *)                         echo "unknown";;
  esac
}

get_install_cmd() {
  case "$1" in
    pacman) echo "sudo pacman -S --noconfirm" ;;
    apt)    echo "sudo apt install -y"         ;;
    dnf)    echo "sudo dnf install -y"         ;;
    zypper) echo "sudo zypper install -y"      ;;
    xbps)   echo "sudo xbps-install -S"        ;;
    emerge) echo "sudo emerge --ask"           ;;
    apk)    echo "sudo apk add"                ;;
    nix)    echo ""                            ;;
    brew)   echo "brew install"                ;;
    *)      echo ""                            ;;
  esac
}

# ─────────────────────────────────────────────────────────────
#  Requirements check
# ─────────────────────────────────────────────────────────────
check_requirements() {
  local missing=()
  for cmd in git stow; do
    command -v "$cmd" >/dev/null 2>&1 || missing+=("$cmd")
  done
  if [ ${#missing[@]} -gt 0 ]; then
    echo -e "\n  ${BRED}✖  Missing: ${missing[*]}${RESET}"
    echo -e "  ${DIM}Install ${BOLD}git${RESET}${DIM} and ${BOLD}stow${RESET}${DIM} before continuing.${RESET}\n"
    exit 1
  fi
}

# ─────────────────────────────────────────────────────────────
#  Terminal helpers
# ─────────────────────────────────────────────────────────────
hide_cursor() { printf '\033[?25l'; }
show_cursor() { printf '\033[?25h'; }
clear_screen() { printf '\033[2J\033[H'; }

cleanup() { show_cursor; stty echo 2>/dev/null; printf '\n'; }
trap cleanup EXIT INT TERM

read_key() {
  local key key2 key3
  IFS= read -rsn1 key
  [ -z "$key" ] && { echo "enter"; return; }
  if [ "$key" = $'\e' ]; then
    IFS= read -rsn1 -t 0.01 key2
    if [ "$key2" = "[" ]; then
      IFS= read -rsn1 -t 0.01 key3
      case "$key3" in
        A) echo "up";    return ;;
        B) echo "down";  return ;;
        C) echo "right"; return ;;
        D) echo "left";  return ;;
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
    k|K) echo "up"   ;;
    j|J) echo "down" ;;
    h|H) echo "left" ;;
    l|L) echo "right";;
    a|A) echo "toggle-all" ;;
    d|D) echo "dry-run"    ;;
    q|Q) echo "quit"       ;;
    ' ') echo "space"      ;;
    *)
      val=$(printf "%d" "'$key" 2>/dev/null)
      if [ -n "$val" ]; then
        case $val in
          9)      echo "tab"    ;;
          10|13)  echo "enter"  ;;
          14)     echo "alt-n"  ;;
          16)     echo "alt-p"  ;;
          2)      echo "left"   ;;
          6)      echo "right"  ;;
          *)      echo "unknown";;
        esac
      else
        echo "unknown"
      fi
      ;;
  esac
}

# ─────────────────────────────────────────────────────────────
#  Shared banner
# ─────────────────────────────────────────────────────────────
print_banner() {
  echo -e "${BMAGENTA}${BOLD}"
  echo -e "  ██████╗  ██████╗ ████████╗███████╗██╗██╗     ███████╗███████╗"
  echo -e "  ██╔══██╗██╔═══██╗╚══██╔══╝██╔════╝██║██║     ██╔════╝██╔════╝"
  echo -e "  ██║  ██║██║   ██║   ██║   █████╗  ██║██║     █████╗  ███████╗"
  echo -e "  ██║  ██║██║   ██║   ██║   ██╔══╝  ██║██║     ██╔══╝  ╚════██║"
  echo -e "  ██████╔╝╚██████╔╝   ██║   ██║     ██║███████╗███████╗███████║"
  echo -e "  ╚═════╝  ╚═════╝    ╚═╝   ╚═╝     ╚═╝╚══════╝╚══════╝╚══════╝"
  echo -e "${RESET}"
  echo -e "  ${DIM}${CYAN}interactive installer  ·  powered by GNU stow${RESET}"
  echo -e ""
}

print_divider() {
  echo -e "  ${DIM}${MAGENTA}────────────────────────────────────────────────────────────${RESET}"
}

print_section_header() {
  local label="$1"
  local color="${2:-$BCYAN}"
  echo -e ""
  echo -e "  ${color}${BOLD}▌ ${label}${RESET}"
  echo -e "  ${DIM}${color}$(printf '─%.0s' {1..54})${RESET}"
}

# ─────────────────────────────────────────────────────────────
#  State
# ─────────────────────────────────────────────────────────────
declare -A SELECTED
for i in "${!PACKAGES[@]}"; do SELECTED[$i]=0; done
CURRENT=0
TOTAL=${#PACKAGES[@]}

# ─────────────────────────────────────────────────────────────
#  Package menu
# ─────────────────────────────────────────────────────────────
draw_menu() {
  clear_screen
  print_banner

  # Status bar
  echo -e "  ${DIM}OS:${RESET} ${CYAN}${BOLD}$OS_NAME${RESET}  ${DIM}│${RESET}  ${DIM}pkg:${RESET} ${YELLOW}$PKG_MANAGER${RESET}"
  echo ""

  # Keybind strip
  echo -e "  ${DIM}${BG_BLACK} ↑↓/jk/ ${RESET}${DIM} navigate   ${BG_BLACK} space ${RESET}${DIM} toggle   ${BG_BLACK}  a  ${RESET}${DIM} select all   ${BG_BLACK}  d  ${RESET}${DIM} preview   ${BG_BLACK} enter ${RESET}${DIM} install   ${BG_BLACK}  q  ${RESET}${DIM} quit${RESET}"
  print_divider
  echo ""

  local sel_count=0
  for val in "${SELECTED[@]}"; do sel_count=$((sel_count + val)); done

  for i in "${!PACKAGES[@]}"; do
    IFS=':' read -r dir file desc cat <<< "${PACKAGES[$i]}"
    local ccolor; ccolor=$(cat_color "$cat")
    local cicon;  cicon=$(cat_icon  "$cat")

    if [ ${SELECTED[$i]} -eq 1 ]; then
      local checkbox="${BGREEN}${BOLD} ●${RESET}"
    else
      local checkbox="${DIM} ○${RESET}"
    fi

    local tag="${ccolor}${DIM}$cicon ${cat}${RESET}"

    if [ $i -eq $CURRENT ]; then
      # Highlighted row
      echo -e "  ${BMAGENTA}${BOLD}❯${RESET} $checkbox  ${BOLD}${BWHITE}$(printf '%-14s' "$dir")${RESET}  ${DIM}${WHITE}$desc${RESET}  ${tag}"
    else
      echo -e "    $checkbox  ${CYAN}$(printf '%-14s' "$dir")${RESET}  ${DIM}$desc${RESET}  ${tag}"
    fi
  done

  echo ""
  print_divider

  # Footer counter with a mini progress bar
  local bar_filled=$(( sel_count * 20 / TOTAL ))
  local bar=""
  for ((b=0; b<20; b++)); do
    if [ $b -lt $bar_filled ]; then
      bar="${bar}${BMAGENTA}█${RESET}"
    else
      bar="${bar}${DIM}░${RESET}"
    fi
  done
  echo -e "  ${DIM}selected${RESET}  $bar  ${BOLD}${BMAGENTA}$sel_count${RESET}${DIM}/$TOTAL${RESET}"
  echo ""
}

menu_loop() {
  hide_cursor; stty -echo
  while true; do
    draw_menu
    key=$(read_key)
    case "$key" in
      up|alt-p|left|shift-tab)
        CURRENT=$((CURRENT - 1)); [ $CURRENT -lt 0 ] && CURRENT=$((TOTAL - 1)) ;;
      down|alt-n|tab|right)
        CURRENT=$((CURRENT + 1)); [ $CURRENT -ge $TOTAL ] && CURRENT=0 ;;
      space)
        SELECTED[$CURRENT]=$((1 - ${SELECTED[$CURRENT]})) ;;
      toggle-all)
        local all=1
        for v in "${SELECTED[@]}"; do [ $v -eq 0 ] && all=0; done
        for i in "${!SELECTED[@]}"; do SELECTED[$i]=$((1 - all)); done ;;
      d)
        show_cursor; stty echo; dry_run_packages; hide_cursor; stty -echo ;;
      enter)
        show_cursor; stty echo; return 0 ;;
      quit)
        show_cursor; stty echo
        echo -e "\n  ${YELLOW}Installation cancelled.${RESET}\n"
        exit 0 ;;
    esac
  done
}

# ─────────────────────────────────────────────────────────────
#  Dry-run preview
# ─────────────────────────────────────────────────────────────
dry_run_packages() {
  clear_screen
  print_banner
  print_section_header "DRY RUN PREVIEW" "$BYELLOW"
  echo ""

  local count=0
  for i in "${!PACKAGES[@]}"; do
    [ ${SELECTED[$i]} -eq 1 ] || continue
    IFS=':' read -r dir file desc cat <<< "${PACKAGES[$i]}"
    local ccolor; ccolor=$(cat_color "$cat")
    local cicon;  cicon=$(cat_icon  "$cat")
    count=$((count + 1))
    if [ -d "$dir" ]; then
      echo -e "  ${BGREEN}✔${RESET}  ${BOLD}$(printf '%-14s' "$dir")${RESET}  ${ccolor}$cicon $cat${RESET}"
      echo -e "     ${DIM}symlink source →${RESET} ${CYAN}$PWD/$dir${RESET}"
    else
      echo -e "  ${BRED}✖${RESET}  ${BOLD}$(printf '%-14s' "$dir")${RESET}  ${BRED}directory not found${RESET}"
    fi
    echo ""
  done

  [ $count -eq 0 ] && echo -e "  ${YELLOW}No packages selected.${RESET}\n"

  print_divider
  echo -e "  ${DIM}$count package(s) queued for install${RESET}"
  echo ""
  read -p "  Press Enter to go back..." _
}

# ─────────────────────────────────────────────────────────────
#  OS selection
# ─────────────────────────────────────────────────────────────
select_os() {
  local current=0 total=${#OS_OPTIONS[@]} detected_os
  detected_os=$(detect_os)

  for i in "${!OS_OPTIONS[@]}"; do
    IFS=':' read -r os_id _ _ <<< "${OS_OPTIONS[$i]}"
    [ "$os_id" = "$detected_os" ] && current=$i && break
  done

  hide_cursor; stty -echo
  while true; do
    clear_screen
    print_banner
    print_section_header "SELECT YOUR OPERATING SYSTEM" "$BCYAN"
    echo ""

    [ "$detected_os" != "unknown" ] && \
      echo -e "  ${DIM}auto-detected:${RESET} ${BGREEN}${BOLD}$detected_os${RESET}\n"

    echo -e "  ${DIM}${BG_BLACK} ↑↓/jk ${RESET}${DIM} navigate   ${BG_BLACK} enter ${RESET}${DIM} confirm   ${BG_BLACK}  q  ${RESET}${DIM} quit${RESET}"
    echo ""

    for i in "${!OS_OPTIONS[@]}"; do
      IFS=':' read -r os_id os_name pkg_mgr <<< "${OS_OPTIONS[$i]}"
      if [ $i -eq $current ]; then
        echo -e "  ${BMAGENTA}${BOLD}❯ $(printf '%-38s' "$os_name")${RESET}  ${YELLOW}$pkg_mgr${RESET}"
      else
        echo -e "    ${DIM}$(printf '%-38s' "$os_name")  $pkg_mgr${RESET}"
      fi
    done

    echo ""
    print_divider
    echo ""
    key=$(read_key)
    case "$key" in
      up|alt-p|left|shift-tab)
        current=$((current - 1)); [ $current -lt 0 ] && current=$((total - 1)) ;;
      down|alt-n|tab|right)
        current=$((current + 1)); [ $current -ge $total ] && current=0 ;;
      enter)
        show_cursor; stty echo
        IFS=':' read -r OS OS_NAME PKG_MANAGER <<< "${OS_OPTIONS[$current]}"
        return 0 ;;
      quit)
        show_cursor; stty echo
        echo -e "\n  ${YELLOW}Installation cancelled.${RESET}\n"; exit 0 ;;
    esac
  done
}

# ─────────────────────────────────────────────────────────────
#  Install
# ─────────────────────────────────────────────────────────────
spinner_frames=('⠋' '⠙' '⠹' '⠸' '⠼' '⠴' '⠦' '⠧' '⠇' '⠏')

install_packages() {
  clear_screen
  print_banner
  print_section_header "INSTALLING DOTFILES" "$BMAGENTA"
  echo ""

  # NixOS warning
  if [ "$OS" = "nixos" ]; then
    echo -e "  ${BYELLOW}${BOLD}NixOS detected — declarative mode only${RESET}"
    echo ""
    echo -e "  ${DIM}Add to ${BOLD}/etc/nixos/configuration.nix${RESET}${DIM}:${RESET}"
    echo ""
    echo -e "  ${DIM}${BG_BLACK}  environment.systemPackages = with pkgs; [ git stow ];  ${RESET}"
    echo ""
    echo -e "  Then rebuild: ${CYAN}${BOLD}sudo nixos-rebuild switch${RESET}"
    echo ""
    read -p "  Press Enter to continue..." _
    echo ""
  else
    if ! command -v stow >/dev/null 2>&1; then
      echo -e "  ${BYELLOW}⚡${RESET} Installing GNU Stow..."
      if [ -n "$INSTALL_CMD" ]; then
        eval "$INSTALL_CMD stow"
      else
        echo -e "  ${BRED}✖  Cannot install stow — unknown package manager${RESET}"; exit 1
      fi
    fi
  fi

  local installed=0 failed=0 skipped=0 idx=0
  local total_sel=0
  for v in "${SELECTED[@]}"; do total_sel=$((total_sel + v)); done

  for i in "${!PACKAGES[@]}"; do
    [ ${SELECTED[$i]} -eq 1 ] || continue
    IFS=':' read -r dir file desc cat <<< "${PACKAGES[$i]}"
    local ccolor; ccolor=$(cat_color "$cat")
    local cicon;  cicon=$(cat_icon  "$cat")
    idx=$((idx + 1))

    # Progress header
    echo -e "  ${DIM}[$idx/$total_sel]${RESET}  ${ccolor}$cicon${RESET}  ${BOLD}$dir${RESET}  ${DIM}$desc${RESET}"

    if [ -d "$dir" ]; then
      if output=$(stow "$dir" 2>&1); then
        echo -e "  ${BGREEN}    ✔  Symlinks created${RESET}"
        installed=$((installed + 1))
      else
        echo -e "  ${BRED}    ✖  Stow failed${RESET}  ${DIM}$output${RESET}"
        echo ""
        echo -e "  ${DIM}  Options:${RESET}"
        echo -e "  ${BYELLOW}  [1]${RESET} ${DIM}Continue${RESET}   ${BYELLOW}[2]${RESET} ${DIM}Backup & retry${RESET}   ${BYELLOW}[3]${RESET} ${DIM}Skip${RESET}"
        printf "  ${CYAN}Choice [1]: ${RESET}"
        read -r choice
        case "$choice" in
          2)
            if backup_dir=$(mktemp -d); then
              if cp -r "$HOME/.config/$dir" "$backup_dir/" 2>/dev/null; then
                echo -e "  ${BGREEN}    ✔  Backed up → $backup_dir${RESET}"
                rm -rf "$HOME/.config/$dir"
                if stow "$dir" 2>/dev/null; then
                  echo -e "  ${BGREEN}    ✔  Installed after backup${RESET}"
                  installed=$((installed + 1))
                else
                  echo -e "  ${BRED}    ✖  Still failed${RESET}"
                  failed=$((failed + 1))
                fi
              else
                echo -e "  ${BRED}    ✖  Backup failed${RESET}"
                failed=$((failed + 1))
              fi
            fi ;;
          3)
            echo -e "  ${YELLOW}    ⊘  Skipped${RESET}"
            skipped=$((skipped + 1)) ;;
          *)
            failed=$((failed + 1)) ;;
        esac
      fi
    else
      echo -e "  ${BRED}    ✖  Directory not found${RESET}"
      failed=$((failed + 1))
    fi
    echo ""
  done

  # ── Summary ─────────────────────────────────────────────
  print_divider
  echo ""
  echo -e "  ${BOLD}${BWHITE}Summary${RESET}"
  echo ""
  [ $installed -gt 0 ] && echo -e "  ${BGREEN}✔${RESET}  ${BOLD}$installed${RESET} ${DIM}installed${RESET}"
  [ $skipped  -gt 0 ] && echo -e "  ${YELLOW}⊘${RESET}  ${BOLD}$skipped${RESET}  ${DIM}skipped${RESET}"
  [ $failed   -gt 0 ] && echo -e "  ${BRED}✖${RESET}  ${BOLD}$failed${RESET}  ${DIM}failed${RESET}"
  echo ""

  if [ $installed -gt 0 ] && [ $failed -eq 0 ]; then
    echo -e "  ${BGREEN}${BOLD}All done!${RESET}  ${DIM}Restart your shell to apply changes.${RESET}"
  elif [ $failed -gt 0 ]; then
    echo -e "  ${BYELLOW}Completed with errors.${RESET}  ${DIM}Review output above.${RESET}"
  fi
  echo ""
}

# ─────────────────────────────────────────────────────────────
#  Entry point
# ─────────────────────────────────────────────────────────────
main() {
  if [ ! -f "README.md" ] || [ ! -d "nixvim" ]; then
    echo -e "\n  ${BRED}✖  Run this script from your dotfiles directory.${RESET}\n"
    exit 1
  fi
  check_requirements
  select_os
  INSTALL_CMD=$(get_install_cmd "$PKG_MANAGER")
  menu_loop
  install_packages
}

main "$@"
