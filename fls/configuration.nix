# Optimized Configuration.nix for NixOS
{ config, lib, pkgs, ... }:

{
  # --- Imports ---
  imports = [
    ./hardware-configuration.nix          # Hardware settings
    <home-manager/nixos>                  # Home Manager as a module
  ];

  # --- System Version ---
  system.stateVersion = "24.05";           # Matches your NixOS release version
systemd.sleep.extraConfig = ''
  HibernateDelaySec=1h
'';

  # --- Bootloader ---
  boot.loader = {
    systemd-boot.enable = true;            # EFI system bootloader
    efi.canTouchEfiVariables = true;       # Allow EFI variable changes
  };

  # --- Networking ---
  networking = {
    hostName = "nixos";                    # Hostname
    wireless.enable = true;               # Enable Wi-Fi
  };

  # --- Localization ---
  time.timeZone = "Asia/Kolkata";          # Timezone
  i18n.defaultLocale = "en_US.UTF-8";     # Locale
  console = {
    font = "Lat2-Terminus16";              # Console font
    keyMap = "us";                         # Keyboard layout
  };

  # --- Graphics and Display ---
  services.xserver = {
    enable = true;                         # Enable X11
    xkb = {
      layout = "us";                       # Keyboard layout
# options = "caps:escape";             # Remap Caps Lock to Escape
    };
    windowManager.dwm = {
      enable = true;                       # Enable DWM
      package = pkgs.dwm.overrideAttrs (old: rec {
        src = /home/turtle/.suckless/dwm;  # Custom DWM source
      });
    };
  };

  # --- Permissions for Backlight ---
  services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEM=="backlight", RUN+="${pkgs.coreutils}/bin/chmod 0660 /sys/class/backlight/%k/brightness"
    ACTION=="add", SUBSYSTEM=="backlight", RUN+="${pkgs.coreutils}/bin/chown root:backlight /sys/class/backlight/%k/brightness"

    # Disable wake-up for USB controller (XHC)
  ACTION=="add", SUBSYSTEM=="pci", ATTR{power/wakeup}="disabled", KERNEL=="0000:00:14.0"
  '';

  # --- Essential Packages ---
  environment.systemPackages = with pkgs; [
    # System utilities
    git unzip file neovim keychain eza
    alacritty zsh dmenu tmux htop fd ripgrep bat figlet toilet xxd bottom ffmpeg-full libvdpau fdk-aac-encoder libva libvdpau vdpauinfo vulkan-loader ytfzf fzf aria2 ffmpegthumbnailer chafa libva-utils powertop lm_sensors 

    # Fonts and themes
      nordic 

    # Applications
    firefox discord gimp flameshot mpv redshift nitrogen feh
    vdhcoapp brave freetube zathura lxappearance yt-dlp obs-studio 
    # Audio and power tools
    pipewire wireplumber alsa-utils tlp acpi light

    # Zsh plugins and tools
    thefuck zsh-autosuggestions zsh-syntax-highlighting zsh-powerlevel10k

    # Network tools
    wpa_supplicant dhcpcd wirelesstools curl wget xclip xsel

    # Development
    gcc python3 python3Packages.pip
  ];

environment.variables = {
  PATH = "/run/current-system/sw/bin";
};

  # --- Fonts Setting ---
  fonts.enableDefaultPackages = true;
  fonts.enableGhostscriptFonts = true; 
  
  fonts.packages = with pkgs; [
  nerdfonts
];



  # --- Audio (PipeWire) ---
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
    wireplumber.enable = true;
  };

  # --- Bluetooth ---
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;          # GUI for Bluetooth management

  # --- Thunar and Filesystem ---
  programs.thunar = {
    enable = true;
    plugins = with pkgs.xfce; [
      thunar-archive-plugin
      thunar-volman
    ];
  };

  services.gvfs.enable = true;            # Enable drive mounting
  programs.xfconf.enable = true;      # Thunar configuration service
  services.tumbler.enable = true;         # Enable thumbnails

  # --- Input Devices ---
  services.libinput.enable = true;         # Enable touchpad support

  # --- Nix Settings ---
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;       # Allow unfree packages

  # --- User Configuration ---
  users.users.turtle = {
    isNormalUser = true;
    extraGroups = [ "wheel" "audio" "video" "bluetooth" "backlight" ];
  };

  # --- Enable zsh ---
  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;

# --- CPU performance scaling ---
services.thermald.enable = true;

# --- tlp ---
services.tlp = {
      enable = true;
      settings = {
        CPU_SCALING_GOVERNOR_ON_AC = "balance_performance"; # set 'performance' or 'balanced' if you want high power

        CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

        CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
        CPU_ENERGY_PERF_POLICY_ON_AC = "performance";

        CPU_MIN_PERF_ON_AC = 0;
        CPU_MAX_PERF_ON_AC = 50; # you can also set this to 100
        CPU_MIN_PERF_ON_BAT = 0;
        CPU_MAX_PERF_ON_BAT = 20;

       #Optional helps save long term battery health
       START_CHARGE_THRESH_BAT0 = 40; # 40 and bellow it starts to charge
       STOP_CHARGE_THRESH_BAT0 = 80; # 80 and above it stops charging

      };
};

# --- Powertop ---
powerManagement.powertop.enable = true;

# Specify the swap device
swapDevices = [
  {
    device = "/dev/sda2";
  }
];

# Specify the swap device for hibernation
boot.resumeDevice = "/dev/sda2";
}

