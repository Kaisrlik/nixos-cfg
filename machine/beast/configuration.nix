# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, modulesPath, ... }:
let
  username = "xeri";
in {
  imports =
    [
      ./hardware-configuration.nix
      ../../modules/common.nix
      ../../modules/devel.nix
      ../../modules/firefox.nix
      ../../modules/sway.nix
      ../../modules/gaming.nix
      ../../modules/mail.nix
      ../../modules/photo.nix
      ../../modules/dns.nix
      ../../modules/firefox.nix
      ../../modules/mdns.nix
      ../../modules/home-printing.nix
      (import ../../modules/sshd.nix {inherit username;})
    ];

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.${username} = {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = [ "wheel" "docker" "dialout" "disk" "input" "video" "network" "audio" "dialout" ];
  };

  gaming.enable = true;

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
      configurationLimit = 15;
    };
  };
}
