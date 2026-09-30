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
      ../../modules/mail.nix
      ../../modules/dns.nix
      ../../modules/firefox.nix
      ../../modules/mdns.nix
      (import ../../modules/sshd.nix {inherit username;})
    ];

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.${username} = {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = [ "wheel" "docker" "dialout" "disk" "input" "video" "network" "audio" "dialout" ];
  };

  boot.supportedFilesystems = [ "ext4" ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # networking.hostName = "nixos"; # Define your hostname.

  # Configure network connections interactively with nmcli or nmtui.
  networking.networkmanager.enable = true;

  system.stateVersion = "26.05"; # Did you read the comment?
}
