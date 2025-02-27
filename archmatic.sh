#!/usr/bin/env bash
# Created by Liam Powell (gfelipe099)
# A compilation of all the files from ArchMatic's repository
# Made for ChrisTitusTech

#-------------------------------------------------------------------------
#      _          _    __  __      _   _
#     /_\  _ _ __| |_ |  \/  |__ _| |_(_)__
#    / _ \| '_/ _| ' \| |\/| / _` |  _| / _|
#   /_/ \_\_| \__|_||_|_|  |_\__,_|\__|_\__|
#  Arch Linux Post Install Setup and Config
#-------------------------------------------------------------------------

# Verify Arch Linux is running
if [ ! -f /usr/bin/pacman ]; then
    echo "Pacman Package Manager was not found in this system, execution aborted."
    exit
    else
        sudo pacman -Syy
        sudo pacman -S lsb-release --noconfirm --needed &>/dev/null
        os=$(lsb_release -ds | sed 's/"//g')
fi

if [ "${os}" != "Arch Linux" ]; then
    echo "You must be using Arch Linux to execute this script."
    exit 1
fi

function baseSetup {
    PKGS=(

        # --- XORG Display Rendering
            'xorg'                  # Base Package
            'xorg-drivers'          # Display Drivers 
            'xterm'                 # Terminal for TTY
            'xorg-server'           # XOrg server
            'xorg-apps'             # XOrg apps group
            'xorg-xinit'            # XOrg init
            'xorg-xinput'           # Xorg xinput
            'mesa'                  # Open source version of OpenGL

        # --- Setup Desktop
            'awesome'               # Awesome Desktop
            'xfce4-power-manager'   # Power Manager 
            'rofi'                  # Menu System
            'picom'                 # Translucent Windows
            'xclip'                 # System Clipboard
            'gnome-polkit'          # Elevate Applications
            'lxappearance'          # Set System Themes

        # --- Login Display Manager
            'sddm'                  # Base Login Manager

        # --- Networking Setup
            'wpa_supplicant'            # Key negotiation for WPA wireless networks
            'dialog'                    # Enables shell scripts to trigger dialog boxes
            'openvpn'                   # Open VPN support
            'networkmanager-openvpn'    # Open VPN plugin for NM
            'network-manager-applet'    # System tray icon/utility for network connectivity
            'libsecret'                 # Library for storing passwords
        
        # --- Audio
            'alsa-utils'        # Advanced Linux Sound Architecture (ALSA) Components https://alsa.opensrc.org/
            'alsa-plugins'      # ALSA plugins
            'pulseaudio'        # Pulse Audio sound components
            'pulseaudio-alsa'   # ALSA configuration for pulse audio
            'pavucontrol'       # Pulse Audio volume control
            'pnmixer'           # System tray volume control

        # --- Bluetooth
        #    'bluez'                 # Daemons for the bluetooth protocol stack
        #    'bluez-utils'           # Bluetooth development and debugging utilities
        #    'bluez-firmware'        # Firmwares for Broadcom BCM203x and STLC2300 Bluetooth chips
        #    'blueberry'             # Bluetooth configuration tool
        #    'pulseaudio-bluetooth'  # Bluetooth support for PulseAudio
        
        # --- Printers
        #    'cups'                  # Open source printer drivers
        #    'cups-pdf'              # PDF support for cups
        #    'ghostscript'           # PostScript interpreter
        #    'gsfonts'               # Adobe Postscript replacement fonts
        #    'hplip'                 # HP Drivers
        #    'system-config-printer' # Printer setup  utility
    )

    for PKG in "${PKGS[@]}"; do
        echo "-------------------------------------------------"
        echo "     Installing package "$PKG
        echo "-------------------------------------------------"
        sudo pacman -S "$PKG" --noconfirm --needed
        clear
    done
}

function softwareSetup {
    PACMANPKGS=(

        # SYSTEM --------------------------------------------------------------

        'linux-lts'             # Long term support kernel

        # TERMINAL UTILITIES --------------------------------------------------

        'bash-completion'       # Tab completion for Bash
        'bleachbit'             # File deletion utility
        'cronie'                # cron jobs
        'curl'                  # Remote content retrieval
        'file-roller'           # Archive utility
        'gtop'                  # System monitoring via terminal
        'gufw'                  # Firewall manager
        'hardinfo'              # Hardware info app
        'htop'                  # Process viewer
        'neofetch'              # Shows system info when you launch terminal
        'ntp'                   # Network Time Protocol to set time via network.
        'numlockx'              # Turns on numlock in X11
        'openssh'               # SSH connectivity tools
        'p7zip'                 # 7z compression program
        'rsync'                 # Remote file sync utility
        'speedtest-cli'         # Internet speed via terminal
        'terminus-font'         # Font package with some bigger fonts for login terminal
        'tlp'                   # Advanced laptop power management
        'unrar'                 # RAR compression program
        'unzip'                 # Zip compression program
        'wget'                  # Remote content retrieval
        'terminator'            # Terminal emulator
        'vim'                   # Terminal Editor
        'zenity'                # Display graphical dialog boxes via shell scripts
        'zip'                   # Zip compression program
        'zsh'                   # ZSH shell
        'zsh-completions'       # Tab completion for ZSH

        # DISK UTILITIES ------------------------------------------------------

        'autofs'                # Auto-mounter
        'btrfs-progs'           # BTRFS Support
        'dosfstools'            # DOS Support
        'exfat-utils'           # Mount exFat drives
        'gparted'               # Disk utility
        'gvfs-mtp'              # Read MTP Connected Systems
        'gvfs-smb'              # More File System Stuff
        'nautilus-share'        # File Sharing in Nautilus
        'ntfs-3g'               # Open source implementation of NTFS file system
        'parted'                # Disk utility
        'samba'                 # Samba File Sharing
        'smartmontools'         # Disk Monitoring
        'smbclient'             # SMB Connection 
        'xfsprogs'              # XFS Support
        'krusader'              # Total Commander like 2-panel file manager

        # GENERAL UTILITIES ---------------------------------------------------

        'flameshot'             # Screenshots
        'freerdp'               # RDP Connections
        'libvncserver'          # VNC Connections
        'nautilus'              # Filesystem browser
        'remmina'               # Remote Connection
        'veracrypt'             # Disc encryption utility
        'variety'               # Wallpaper changer

        # DEVELOPMENT ---------------------------------------------------------

        'kate'                  # Text editor
        'clang'                 # C Lang compiler
        'cmake'                 # Cross-platform open-source make system
        'code'                  # Visual Studio Code
        'electron'              # Cross-platform development using Javascript
        'gcc'                   # C/C++ compiler
        'glibc'                 # C libraries
        'meld'                  # File/directory comparison
        'nodejs'                # Javascript runtime environment
        'npm'                   # Node package manager
        'python'                # Scripting language
        'yarn'                  # Dependency management (Hyper needs this)

        # MEDIA ---------------------------------------------------------------

        'kdenlive'              # Movie Render
        'obs-studio'            # Record your screen
        'celluloid'             # Video player
        'musescore'             # Scoring
        'spotify'               # Streaming
        
        # GRAPHICS AND DESIGN -------------------------------------------------

        'gcolor2'               # Colorpicker
        'gimp'                  # GNU Image Manipulation Program
        'ristretto'             # Multi image viewer
        'krita'                 # Image processing

        # PRODUCTIVITY --------------------------------------------------------

        'hunspell'              # Spellcheck libraries
        'hunspell-de'           # English spellcheck library
        'xpdf'                  # PDF viewer

    )

    AURPKGS=(

        # UTILITIES -----------------------------------------------------------

        'i3lock-fancy'              # Screen locker
        'synology-drive'            # Synology Drive
        'libreoffice'               # Office Suite
        
        # MEDIA ---------------------------------------------------------------

        'screenkey'                 # Screencast your keypresses
        'lbry-app-bin'              # LBRY Linux Application

        # COMMUNICATIONS ------------------------------------------------------

        'chromium'                  # Chromium browser
        'discord'                   # Chat

        # THEMES --------------------------------------------------------------

        'materia-gtk-theme'             # Desktop Theme
        'papirus-icon-theme'            # Desktop Icons
        'capitaine-cursors'             # Cursor Themes
    
    )

    for PAC in "${PACMANPKGS[@]}"; do
        echo "-------------------------------------------------"
        echo "     Installing package "$PAC
        echo "-------------------------------------------------"
        sudo pacman -S "$PAC" --noconfirm --needed
        clear
    done

    # Clone yay repository and install it
    echo "-------------------------------------------------"
    echo "     Installing yay"
    echo "-------------------------------------------------"
    cd ${HOME}
    git clone "https://aur.archlinux.org/yay.git"
    cd ${HOME}/yay
    makepkg -si --noconfirm --needed
    clear

    for AUR in "${AURPKGS[@]}"; do
        echo "-------------------------------------------------"
        echo "     Installing package "$AUR
        echo "-------------------------------------------------"
        sudo pacman -S "$AUR" --noconfirm --needed
        clear
    done
}

function postInstallation {
    # Generate the .xinitrc file so we can launch Awesome from the
    # terminal using the "startx" command
    printf '#!/bin/bash
# Disable bell
xset -b

# Disable all Power Saving Stuff
xset -dpms
xset s off

# X Root window color
xsetroot -solid darkgrey

# Merge resources (optional)
#xrdb -merge $HOME/.Xresources

# Caps to Ctrl, no caps
setxkbmap -layout de -option ctrl:nocaps
if [ -d /etc/X11/xinit/xinitrc.d ] ; then
    for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
        [ -x "\$f" ] && . "\$f"
    done
unset f
fi' > ${HOME}/.xinitrc

    # ------------------------------------------------------------------------

    echo "-------------------------------------------------"
    echo "     Cloning awesome configuration"
    echo "-------------------------------------------------"
    
    cd ${HOME}
    if [ ! -d "${HOME}/.config" ]; then
        mkdir .config
    fi
    cd .config
    git clone https://github.com/gramms/awesome.git
    cd ~

    # ------------------------------------------------------------------------

    echo "-------------------------------------------------"
    echo "     Updating /bin/startx to use the correct path"
    echo "-------------------------------------------------"

    # By default, startx incorrectly looks for the .serverauth file in our HOME folder.
    sudo sed -i 's|xserverauthfile=\$HOME/.serverauth.\$\$|xserverauthfile=\$XAUTHORITY|g' /bin/startx

    # ------------------------------------------------------------------------

    echo "-------------------------------------------------"
    echo "     Configuring LTS Kernel as a"
    echo "     secondary boot option"
    echo "-------------------------------------------------"

    sudo cp /boot/loader/entries/arch.conf /boot/loader/entries/arch-lts.conf
    sudo sed -i 's|Arch Linux|Arch Linux LTS Kernel|g' /boot/loader/entries/arch-lts.conf
    sudo sed -i 's|vmlinuz-linux|vmlinuz-linux-lts|g' /boot/loader/entries/arch-lts.conf
    sudo sed -i 's|initramfs-linux.img|initramfs-linux-lts.img|g' /boot/loader/entries/arch-lts.conf

    # ------------------------------------------------------------------------

    echo "-------------------------------------------------"
    echo "     Configure X11 keyboard layout"
    echo "-------------------------------------------------"

    localectl --no-ask-password set-x11-keymap de pc105 deadgraveacute

    echo "setxkbmap -layout de" >> /usr/share/sddm/scripts/Xsetup

    if [ ! -f "/etc/X11/xorg.conf.d/00-keyboard.conf" ]; then
        cat <<EOF >> /etc/X11/xorg.conf.d/00-keyboard.conf
Section "InputClass"
        Identifier "system-keyboard"
        MatchIsKeyboard "on"
        Option "XkbLayout" "de"
        Option "XkbVariant" "deadgraveacute"
EndSection
EOF
    fi

    echo "-------------------------------------------------"
    echo "     Disabling buggy cursor inheritance"
    echo "-------------------------------------------------"

    # When you boot with multiple monitors the cursor can look huge. This fixes it.
    printf '[Icon Theme]
#Inherits=Theme' > /usr/share/icons/default/index.theme

    # ------------------------------------------------------------------------

    echo "-------------------------------------------------"
    echo "     Increasing file watcher count"
    echo "-------------------------------------------------"

    # This prevents a "too many files" error in Visual Studio Code
    echo fs.inotify.max_user_watches=524288 | sudo tee /etc/sysctl.d/40-max-user-watches.conf && sudo sysctl --system

    # ------------------------------------------------------------------------

    echo "-------------------------------------------------"
    echo "     Disabling Pulse .esd_auth module"
    echo "-------------------------------------------------"

    # Pulse audio loads the `esound-protocol` module, which best I can tell is rarely needed.
    # That module creates a file called `.esd_auth` in the home directory which I'd prefer to not be there. So...
    sudo sed -i 's|load-module module-esound-protocol-unix|#load-module module-esound-protocol-unix|g' /etc/pulse/default.pa

    # ------------------------------------------------------------------------

    echo "-------------------------------------------------"
    echo "     Enabling Login Display Manager"
    echo "-------------------------------------------------"

    sudo systemctl enable --now sddm.service

    # ------------------------------------------------------------------------

    echo "-------------------------------------------------"
    echo "     Enabling bluetooth daemon and"
    echo "     setting it to auto-start"
    echo "-------------------------------------------------"

    #sudo sed -i 's|#AutoEnable=false|AutoEnable=true|g' /etc/bluetooth/main.conf
    #sudo systemctl enable --now bluetooth.service

    # ------------------------------------------------------------------------

    echo "-------------------------------------------------"
    echo "     Enabling the cups service daemon "
    echo "     so we can print"
    echo "-------------------------------------------------"

    #systemctl enable --now org.cups.cupsd.service

    echo "-------------------------------------------------"
    echo "     Configuring NTP, DHCP and NetworkManager"
    echo "-------------------------------------------------"
    sudo ntpd -qg
    sudo systemctl enable --now ntpd
    sudo systemctl disable dhcpcd
    sudo systemctl stop dhcpcd
    sudo systemctl enable --now NetworkManager

    # Remove no password sudo rights
    #sed -i 's/^%wheel ALL=(ALL) NOPASSWD: ALL/# %wheel ALL=(ALL) NOPASSWD: ALL/' /etc/sudoers
    # Add sudo rights
    #sed -i 's/^# %wheel ALL=(ALL) ALL/%wheel ALL=(ALL) ALL/' /etc/sudoers

    # Clean orphans pkg
    if [[ ! -n $(pacman -Qdt) ]]; then
        echo "No orphans to remove."
    else
        pacman -Rns $(pacman -Qdtq)
    fi

    # Replace in the same state
    cd $pwd
}

clear
echo -n "Starting base setup ... "
sleep 5
clear
baseSetup
echo -n "Starting software setup ... "
sleep 5
clear
softwareSetup
echo -n "Starting post installation setup ... "
sleep 5
clear
postInstallation
clear
echo -n "ArchMatic finished the installation and configuration of the system!"
reboot