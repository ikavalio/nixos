# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

let
  tmuxConfig = (pkgs.callPackage ./tmux.nix {});
  zshConfig  = (pkgs.callPackage ./zsh.nix {});
  tabnine    = (pkgs.callPackage ./tabnine.nix {});
in
{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix

    "${builtins.fetchGit { url="https://github.com/rycee/home-manager"; ref="master"; }}/nixos"
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.cleanTmpDir = true;

  nixpkgs.config.allowUnfree = true;

  networking.hostName = "ikavalio-laptop-nixos"; # Define your hostname.
  networking.wireless.enable = false;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n = {
  #   consoleFont = "Lat2-Terminus16";
  #   consoleKeyMap = "us";
  #   defaultLocale = "en_US.UTF-8";
  # };

  # Set your time zone.
  time.timeZone = "Europe/Dublin";

  fonts = {
    enableFontDir = true;
    fonts = with pkgs; [
      corefonts
      inconsolata
      iosevka
      terminus_font
      dejavu_fonts
      ubuntu_font_family
      fira
      source-code-pro
      source-sans-pro
      source-serif-pro
      roboto-mono
      roboto
      overpass
      libre-baskerville
    ];
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    binutils patchelf
    acpi
    killall git
    wget curl nettools
    tree
    fzf jq zip unzip fpp
    nixops
    alacritty vscode
    firefox spotify
    plasma-nm
    blueman
    tabnine
    (callPackage ./neovim.nix {tabnine = tabnine; })
    tmux zsh
    mesa freeglut
  ]
  ++ tmuxConfig.plugins
  ++ zshConfig.plugins;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.mtr.enable = true;
  programs.gnupg.agent = { enable = true; enableSSHSupport = true; };

  # global tmux configuration
  programs.tmux = tmuxConfig.config;

  # zsh configuration
  programs.zsh = zshConfig.config;

  # List services that you want to enable:

  # custom udev rules for QMK
  services.udev.extraRules = (pkgs.callPackage ./udev-kb.nix {});

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio = {
    enable = true;
    daemon.config = { flat-volumes = "no"; };
    package = pkgs.pulseaudioFull;
  };

  services.dbus.packages = [ pkgs.blueman ];

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.layout = "us";
  services.xserver.xkbOptions = "eurosign:e, ctrl:nocaps";

  # Enable touchpad support.
  services.xserver.libinput.enable = true;
  services.xserver.multitouch.enable = true;

  # Enable the KDE Desktop Environment.
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.ikavalio = {
    isNormalUser = true;
    uid = 1000;
    group = "users";
    extraGroups = [ "wheel" "networkmanager" "video" "audio"];
    createHome = true;
    home = "/home/ikavalio";
    shell = pkgs.zsh;
  };

  home-manager.users = (x: let commons = x; in {
    ikavalio = {
      inherit (commons) home;
    };
  }) (pkgs.callPackage ./home.nix {});

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "unstable"; # Did you read the comment?
}
