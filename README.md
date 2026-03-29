# Dotfiles

A collection of configuration files for various tools and applications, managed with GNU Stow.

## Quick Start

### 1. Clone the repository

```bash
git clone https://github.com/ImStyrene/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
```

### 2. Run the interactive installer

```bash
./installer.sh
```

The installer will:
- Detect your operating system automatically
- Let you select which configurations to install
- Preview changes with dry-run mode (`d` key) before applying
- Handle file conflicts gracefully
- Symlink your configs using GNU Stow

**Keyboard shortcuts:**
- `↑↓` / `hjkl` / `Tab` / `Ctrl-n,p` / `Alt-n,p` — Navigate
- `Space` — Select/deselect package
- `a` — Toggle all packages
- `d` — Preview changes (dry-run mode)
- `Enter` — Install selected packages
- `q` — Quit

## Requirements

The installer automatically checks for:
- **Git** — for cloning and version control
- **GNU Stow** — for managing symlinks

If either is missing, the installer will guide you through installation for your system.

## Manual Installation

If you prefer to install dependencies manually:

### Arch Linux / Manjaro / EndeavourOS
```bash
sudo pacman -S git stow
```

### Debian / Ubuntu / Linux Mint / Pop!_OS
```bash
sudo apt install git stow
```

### Fedora / RHEL / CentOS
```bash
sudo dnf install git stow
```

### openSUSE
```bash
sudo zypper install git stow
```

### Void Linux
```bash
sudo xbps-install -S git stow
```

### Gentoo
```bash
sudo emerge --ask dev-vcs/git app-admin/stow
```

### Alpine Linux
```bash
sudo apk add git stow
```

### NixOS (Declarative - Recommended)

Add to `/etc/nixos/configuration.nix`:
```nix
environment.systemPackages = with pkgs; [
  git
  stow
];
```

Rebuild your system:
```bash
sudo nixos-rebuild switch
```

### macOS

**Homebrew:**
```bash
brew install git stow
```

**MacPorts:**
```bash
sudo port install git stow
```

### FreeBSD
```bash
sudo pkg install git stow
```

## Manual Configuration

After installing dependencies, manage configs manually with Stow:

### Install a package
```bash
cd ~/.dotfiles
stow <package-name>
```

### Uninstall a package
```bash
stow -D <package-name>
```

### Verbose output (see what gets symlinked)
```bash
stow -v <package-name>
```

Each package directory contains configuration files that Stow symlinks to your home directory.

## Dry-Run Mode

Preview what will be installed before committing:

1. Select your packages in the installer
2. Press `d` to enter dry-run mode
3. Review the symlinks that will be created
4. No files are modified—return to menu to proceed or cancel

## Troubleshooting

### Conflict during installation

If files already exist at the symlink location, the installer will:
1. Display the error details
2. Offer to back up existing files to a temporary directory
3. Allow you to retry, skip, or continue with other packages

### Stow shows "target already exists"

This usually means a file or directory conflicts with the symlink. Options:
- Use the installer's conflict resolution (`d` key → select → `Enter`)
- Manually back up the file and remove it
- Use `stow -D <package-name>` to uninstall first, then reinstall

### Check what Stow will do
```bash
cd ~/.dotfiles
stow -v --dry-run <package-name>
```

### Restore from backup

If the installer created a backup, restore it from the temporary directory shown in the output.

## Tips & Best Practices

- **Start small** — Install one or two packages first to test the workflow
- **Use dry-run** — Always preview changes before installing, especially for critical configs
- **Keep backups** — The installer backs up conflicting files, but maintaining your own backups is recommended
- **Version control** — Commit your changes to track dotfile modifications over time

## License

This project is licensed under the MIT License — see the LICENSE file for details.
