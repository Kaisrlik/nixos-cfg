# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:
{
  nix = {
    # package = pkgs.nixUnstable;
    extraOptions = "experimental-features = nix-command flakes";
  };
  imports =
    [ # Include the results of the hardware scan.
      # ./machine/beast/hardware-configuration.nix
      ./machine/intel/hardware-configuration.nix
      ./modules/common.nix
      ./modules/sway.nix
      # ./modules/gaming.nix
      # ./modules/media.nix
      ./modules/mail.nix
    ];

  boot.supportedFilesystems = [ "ext4" ];
  boot.loader = {
    # systemd-boot.enable = true;
    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot";
    };

    # Use the GRUB 2 boot loader.
    grub = {
      enable = true;
      efiSupport = true;
      # boot is located on encrypted partition
      # efiInstallAsRemovable = true;
      # Define on which hard drive you want to install Grub.
      device = "nodev"; # or "nodev" for efi only
    };
  };

  # enabled in later version
  # nixpkgs.overlays = [ (self: super: {
  #   isync = super.isync.override { withCyrusSaslXoauth2 = true; };
  # })];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim
    neovim
    ccls
    ctags

    file
    foot
    fzf
    git
    htop
    lnav
    ltex-ls
    shellcheck
    tig
    tree
    zsh

    # nix specific
    home-manager
    direnv

    gnumake
    cmake
    meson
    ninja
    gcc
    jq

    (callPackage ./pkgs/impressive { })
    evince
    vlc
    lynx # html/text

    # email
    notmuch
    neomutt
    abook

    libnotify
    curl
    firefox-wayland
    perl # required by some i3 scripts
    # required by nvim and other tools
    (python3.withPackages (p: with p; [
      # impressive dep
      pillow pygame
    ]))
    bash
    acpi # see battery status
    pavucontrol

    # vpn, certs, proxies
    cacert
    keychain
    netcat-openbsd
    openconnect
    openssl # expiration of certs
    pinentry-curses # gpg requires

    # windows rdp
    remmina

    man-pages
    man-pages-posix
  ];
}
