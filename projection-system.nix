{ config, pkgs, lib, ... }:

{
  system.copySystemConfiguration = true;
  #Experimental Features
  nix = {
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      # ./flake.nix
    ];



  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.initrd.kernelModules = ["amdgpu"];


  boot.kernelModules = [ "v4l2loopback" ];

  boot.extraModulePackages = with config.boot.kernelPackages; [ v4l2loopback ];  # :contentReference[oaicite:0]{index=0}

  # Pass parameters for one device, /dev/video1
  boot.extraModprobeConfig = ''
    options v4l2loopback devices=1 max_buffers=2 video_nr=4 exclusive_caps=0 max_open=2 card_label="VirtualCam #0"
  '';


  systemd.services.ffmpeg-v4l2 = {
    description = "UDP→/dev/video4 (low-latency)";
    wants       = [ "network-online.target" ];
    after       = [ "network-online.target" ];
    serviceConfig = {
      ExecStart = ''
        ${pkgs.ffmpeg}/bin/ffmpeg \
          -fflags nobuffer -flags low_delay \
          -i udp://@:8080?fifo_size=5000000 \
          -c:v rawvideo \
          -pix_fmt yuyv422 \
          -f v4l2 /dev/video4
      '';
      Restart    = "always";
      RestartSec = "5s";
      StandardOutput = "journal";
      StandardError  = "journal";
    };
    wantedBy   = [ "multi-user.target" ];
  };




  # systemd.services.ffmpeg-v4l2 = {
  #   description = "Stream HTTP camera into /dev/video4 via FFmpeg";
  #   wants       = [ "network-online.target" ];
  #   after       = [ "network-online.target" ];
  #   # if you need group access to /dev/video4, you can add:
  #   # serviceConfig.User = "johnb";
  #   # serviceConfig.Group = "video";

  #   serviceConfig = {
  #     # command to run
  #     ExecStart = "${pkgs.ffmpeg}/bin/ffmpeg"
  #       + " -i http://raspberrypi.taile14a22.ts.net:8080/video"
  #       + " -vf format=yuyv422"
  #       + " -f v4l2 /dev/video4";
  #     Restart    = "always";
  #     RestartSec = "5s";
  #     # optional: log to journal
  #     StandardOutput = "journal";
  #     StandardError  = "journal";
  #   };

  #   # make sure it starts on boot
  #   wantedBy = [ "multi-user.target" ];
  # };

  
  networking.hostName = "nixDesktop"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  systemd.services.tailscaled = {
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
  };

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking with Wake-on-LAN
  networking = {
    networkmanager.enable = true;
    firewall = {
      enable = true;
      allowedTCPPorts = [ 8080 8384 22000 7878 6969 ];
      allowedUDPPorts = [ 8080 51820 7878 4242 22000 21027 6969 9000 9002 39539];

    };
    interfaces = {
      "enp6s0" = {
        wakeOnLan = {
          enable = true;
        };
      };
      "wlp5s0" = {
        wakeOnLan = {
          enable = true;
        };
      };
    };
  };

  systemd.services.NetworkManager-wait-online.enable = false;
  # services.gnome-keyring.enable = true;
  security.pam.services.johnb.enableGnomeKeyring= true;
  #
  #
  security.pam.services.gdm.enableGnomeKeyring = true;
  security.pam.services.greetd.enableGnomeKeyring = true;

  services.gnome.gnome-keyring.enable = true;

  environment.variables.XDG_RUNTIME_DIR = "/run/user/$UID";
  # Set your time zone.
  time.timeZone = "America/New_York";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.videoDrivers = [ "amdgpu" ];

  hardware.opengl.driSupport32Bit = true;
  hardware.opengl.enable = true;
  hardware.opengl = {
  extraPackages = with pkgs; [
    ocl-icd            # the OpenCL ICD loader (provides libOpenCL.so)
    pocl               # a CPU‑only OpenCL runtime
    # intel-compute-runtime  # Intel GPU ICD (Gen8+)
    rocmPackages.clr.icd   # AMD GPU ICD (if you have an AMD card)
  ];
};

  # hardware.opengl.extraPackages = with pkgs[
  #   ocl-icd
    
  # ];

  #For power mode
  services.power-profiles-daemon.enable = true;

  # Enable the GNOME Desktop Environment.
   services.xserver.displayManager.gdm = {
    enable = true; 
    autoLogin = {
      enable = true;
      user = "johnb";  # Your username
    };
  };
  services.xserver.desktopManager.gnome.enable = true;
  services.flatpak.enable = true;
  # Configure keymap in X11
  services.xserver = {
    layout = "us";
    xkbVariant = "";
  };

  # Enable CUPS to print documents.

  hardware.pulseaudio.enable = false; # Use Pipewire, the modern sound subsystem

  security.rtkit.enable = true; # Enable RealtimeKit for audio purposes



  services.joycond.enable = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  #Bluetooth
  hardware.bluetooth = {
    powerOnBoot = true;
    enable = true;
    settings = {
      General = {
        Enable = "Source,Sink,Media,Socket";
      };
    };
  };

  services.udev.extraRules = ''
    KERNEL=="uinput", GROUP="input", MODE="0660", OPTIONS+="static_node=uinput"
    KERNEL=="pcm*", GROUP="audio"
    SUBSYSTEM=="hidraw", ATTRS{idVendor}=="1d6b", ATTRS{idProduct}=="0002", MODE="0666", TAG+="uaccess"
    SUBSYSTEM=="hidraw", ATTRS{idVendor}=="057e", ATTRS{idProduct}=="0306", MODE="0666", TAG+="uaccess"
    SUBSYSTEM=="usb", ATTRS{idVendor}=="1d6b", ATTRS{idProduct}=="0002", MODE="0666", TAG+="uaccess"
    # SUBSYSTEM=="hidraw", ATTRS{idVendor}=="3297", ATTRS{idProduct}=="1969", MODE="0666", TAG+="uaccess"
    # Nintendo Switch Joy-Con (L) rules
    SUBSYSTEM=="input", ATTRS{name}=="*Joy-Con (L)*", ENV{ID_INPUT_JOYSTICK}="1"
    # Nintendo Switch Joy-Con (R) rules
    SUBSYSTEM=="input", ATTRS{name}=="*Joy-Con (R)*", ENV{ID_INPUT_JOYSTICK}="1"
    # Nintendo Switch Pro Controller rules
    SUBSYSTEM=="input", ATTRS{name}=="*Nintendo Switch Pro Controller*", ENV{ID_INPUT_JOYSTICK}="1"

  '';

  # Define a user account. Don't forget to set a password with 'passwd'.
  users.users.johnb = {
    shell = pkgs.zsh;
    isNormalUser = true;
    extraGroups = [ "networkmanager" "wheel" "adbusers" "audio" "dialout" "input"];
    packages = with pkgs; [
      firefox
      chromium
    ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINEZZxARlyPFzz9uIhKQK9tiCywFjjzN3YTF5flKHHvt johnb@nixDesktop"
    ];
  };


  # fileSystems."/boot" = lib.mkForce {
  #   device = "/dev/disk/by-uuid/3486-CD86";  # Matches your blkid output
  #   fsType = "vfat";
  #   options = [ "rw" "relatime" "fmask=0022" "dmask=0022" "codepage=437" "iocharset=iso8859-1" "shortname=mixed" ];
  # };


  # fileSystems."/mnt/trunk" = {
  #   device = "UUID=26937bbe-7cca-4a8c-8d88-f7da61dd5f50";
  #   fsType = "ext4";  # Or whatever filesystem you formatted it with
  #   options = [ "x-initrd.mount" ];
  # };

  systemd.tmpfiles.rules = [
    "d /mnt/trunk 0755 johnb users - -"
  ];
  programs.adb.enable = true;
  programs.java.enable = true;

  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
  # Add the NDI package here
  ndi
  # Add any other required libraries
];

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile
  environment.systemPackages = with pkgs; [
    python3
    python312Packages.httplib2
    nodejs_22
    typescript-language-server
    vscode-langservers-extracted
    nixd
    markdown-oxide

    temurin-bin-17
    jdk17
    android-studio
    android-udev-rules
    android-tools
    appimage-run

    livecaptions
    openai-whisper
    google-cloud-sdk

    # opencl-clhpp
    # opencl-clang
    # opencl-headers
    # ocl-icd
    # stdenv.cc.cc.lib
    # libgcc
    # rocmPackages.clr
    

    certbot


    streamcontroller

    obsidian

    gnome-power-manager
    power-profiles-daemon
    pipewire
    # pamixer
    alsa-plugins
    alsa-utils
    sox

    # godot_4_3
    godot
    gdtoolkit_4
    blender

    slimevr
    slimevr-server
    liblo
    

    krita
    gimp
    orca-c
    obs-studio
    libcamera

    discord
    zoom-us

    haskellPackages.pandoc-cli
    texliveSmall
    ripgrep
    fzf
    tree

    joycond-cemuhook
    bluez
    # bluez-tools
    blueman

    kooha
    ndi
    ffmpeg_7
    libsForQt5.kdenlive
    video-trimmer
    yt-dlp-light
    radeontop
    alvr 
    # ffmpeg
    v4l-utils

    steam-run
    patchelf
    bottles
    popsicle
    libvirt

    wget 
    gnome-tweaks
    gnome-software
    dynamic-wallpaper
    gnome-extension-manager
    nautilus
    gnome-calculator

    # errands
    todoman
    dbus



    blanket
    helix
    nmap
    yazi
    broot
    tmux
    screen

    audacity
    gnome-sound-recorder
    amberol
    shortwave

    wireguard-tools
    # rustdesk

    gcc
    scons

    git
    github-desktop
    gh
    hut

    syncthing
    gnome-system-monitor
    baobab

    arduino-ide
    toybox
    cp210x-program
    gcc-arm-embedded

    postman
    nixos-generators

    # xclip
    # xsel


    keymapp
    
    wl-clipboard
    wtype


    kdePackages.kruler



    
    xdotool
    ydotool
    zsh

    gnome-keyring
    libsecret

    kitty
    ghostty

    # font-awesome
    # material-design-icons
    # nerdfonts
    adwaita-icon-theme-legacy
    adwaita-icon-theme
    # bibata-cursors-translucent
    # bibata-cursors

####HYPRLAND
    waybar
    networkmanager_dmenu
    pavucontrol
    rofi-bluetooth

    nwg-panel
    nwg-dock-hyprland
    nwg-displays

    # dunst
    libnotify
    swaynotificationcenter
    wofi
    # dolphin
    nwg-look
    hyprshot
    hyprpaper
    hyprsunset
    hyprpicker
    hyprpolkitagent
    xdg-desktop-portal-hyprland
    # greetd
    hyprlock
    hypridle

    sassc
    gnome-themes-extra
    gtk-engine-murrine


    
    # (import (pkgs.callPackage (pkgs.fetchFromGitHub {
    #   owner = "MalpenZibo";
    #   repo = "ashell";
    #   rev = "refs/heads/main"; # Or specify the branch/tag you need
    #   sha256 = "sha256-O/Y/l05osLmGgEt+3YtSGaySU5GFxGdNzVGHX6gfc7s="; # Replace with the correct hash
    # }) {}).defaultPackage.x86_64-linux)


    
  ];

  # wayland.windowManager.hyprland.systemd.variables = ["-all"];


  security.polkit.enable = true;

  programs.hyprland.enable = true;
  programs.hyprland.xwayland.enable = true;      # enable Xwayland for X11 apps (if you use X11 apps)<
  programs.hyprland.systemd.setPath.enable = true;
  environment.sessionVariables.NIXOS_OZONE_WL = "1";
  xdg.portal.enable = true;
  xdg.portal.extraPortals = [pkgs.xdg-desktop-portal-gtk];


  programs.zsh = {
    enable = true;
    shellAliases = {
      br = "broot";
      yz = "yazi";
      vs = "vdirsyncer sync";
    };
    ohMyZsh = {
      enable = true;
      theme = "robbyrussell";
    };
  };

  programs.steam.enable = true;

  environment.variables = { EDITOR = "ghostty"; VISUAL = "ghostty"; TERMINAL = "ghostty"; };

  environment.sessionVariables = {
    EDITOR = "ghostty";
  };


  

  programs.bash.shellAliases = {
    br = "broot";
    yz = "yazi";
    dic = "/home/johnb/Nextcloud/System/Scripts/run_dictation.sh";
  };
  
  # virtualisation.docker.enable = true;

  
  programs.zsh.shellAliases = {
    dic = "/home/johnb/Nextcloud/System/Scripts/run_dictation.sh";
  };

  fonts.packages = with pkgs; [
    nerd-fonts.fira-code
    nerd-fonts.droid-sans-mono
    fira-code
    font-awesome
    powerline-fonts
  ];

  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  services.syncthing = {
    enable = true;
    user = "johnb";
  };

  # List services that you want to enable:
  services.tailscale.enable = true;

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  system.stateVersion = "23.05"; 

}


