# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running 'nixos-help').

{ config, pkgs, ... }:

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
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  
  
  systemd.services.NetworkManager-wait-online.enable = false;
  networking.hostName = "lappy";

  # Enable networking
  networking.networkmanager.enable = true;

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

  # Enable the X11 windowing system and GNOME
  services.xserver = {
    enable = true;
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
    layout = "us";
    xkbVariant = "";
  };

  # Important for screen sharing
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gnome ];
    config.common.default = "*";
  };

  services.udev.extraRules = ''
    KERNEL=="uinput", GROUP="input", MODE="0660", OPTIONS+="static_node=uinput"
    KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{name}=="Nintendo Switch Right Joy-Con", MODE="0666", GROUP="input"
  '';

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enhanced PipeWire configuration for screen sharing
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
    wireplumber.enable = true;
  };

  hardware.pulseaudio.enable = false;

  # User configuration
  users.users.johnb = {
    shell = pkgs.zsh;
    isNormalUser = true;
    description = "John Bezark";
    extraGroups = [ "networkmanager" "wheel" "adbusers" "input" "dialout" "tty"];
    packages = with pkgs; [
      firefox
    ];

    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPO+EUNqgNbbEDwM2vWKVxY3Fa5GF8X7UWm9ciu1QJ4p johnb@lappy"
    ];
  };

  programs.adb.enable = true;
  nixpkgs.config.allowUnfree = true;

  # Packages
  environment.systemPackages = with pkgs; [
    # Screen sharing essentials

    systemd
    
    wireplumber
    xdg-desktop-portal
    xdg-desktop-portal-gnome
    
    python3
    dbus
    nodejs_22
    temurin-bin
    jdk17
    android-studio
    android-udev-rules
    android-tools
    appimage-run
    fprintd
    ungoogled-chromium
    espeak
    piper-tts
    mycorrhiza
    helix
    markdown-oxide
    pandoc
    texliveSmall

    caddy
    nss

    
    slides
    todoman
    khal
    vdirsyncer
    nnn
    yazi
    broot
    obsidian
    xclip
    xsel
    tree
    ripgrep
    fzf
    # godot_4_3
    godot
    blender
    unityhub
    nmap
    gdtoolkit_4
    obs-studio
    livecaptions
    showmethekey
    krita
    whatsapp-for-linux 
    discord
    dorion
    zoom-us
    kooha
    ffmpeg_7
    libsForQt5.kdenlive
    video-trimmer
    steam-run
    patchelf
    wget 
    gnome-sound-recorder
    gnome-network-displays    
    gnome-tweaks
    gnome-software
    gnome-pomodoro
    # gnome-extension-manager
    libreoffice-fresh
    xournalpp
    gtg
    errands
    blanket
    gcc
    amberol
    spotify
    xemu
    git
    github-desktop
    gh
    hut
    arduino-ide
    gcc-arm-embedded
    zsh
    liblo
    xrdp
    syncthing
    qemu
    popsicle


    keymapp
    xwiimote
    cwiid
    wiiuse
    # libudev0-shim
    joycond-cemuhook
    bluez
    blueman
    unetbootin
    nixos-generators
    nix-search-cli
    gnome-keyring
    kitty
    ghostty
    alacritty
    gnome-terminal
  ];


  services.xserver.desktopManager.gnome.extraGSettingsOverrides = ''
    [org.gnome.desktop.default-applications.terminal]
    exec='ghostty' 
  '';

  # Steam configuration
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
  };

  # ZSH configuration
  programs.zsh = {
    enable = true;
    ohMyZsh = {
      enable = true;
      theme = "robbyrussell";
    };
  };

  # Environment variables
  environment.sessionVariables = {
    JAVA_HOME = "${pkgs.jdk11}/lib/openjdk";
    LD_LIBRARY_PATH = [ "${pkgs.systemd}/lib" ];
    ANDROID_SDK_ROOT = "${pkgs.android-studio}/libexec/android-sdk";
  };


  # Shell aliases
  programs.bash.shellAliases = {
    choose_date = "/home/johnb/Nextcloud/4Tinker/Tinkering/bashdemos/choice.sh";
  };
  
  programs.zsh.shellAliases = {
    choose_date = "/home/johnb/Nextcloud/4Tinker/Tinkering/bashdemos/choice.sh";
    numen_start = "/home/johnb/Nextcloud/System/Scripts/numen.sh";
    br = "broot";
    yz = "yazi";
  };

  environment.interactiveShellInit = ''
    alias gs='git status'
  '';


  # Services
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };


  
  services.syncthing = {
    enable = true;
    user = "johnb";
  };


  services.tailscale.enable = true;
  services.openssh.enable = true;

  # Firewall configuration
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 7236 8080 8060 443];  # 7236 is for GNOME Network Displays
    allowedUDPPorts = [ 7236 8080 8060 7878 4242 26761];
  };

  # Update to latest stable NixOS version
  system.stateVersion = "23.11";
}
