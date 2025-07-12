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
      ../../modules/firefox.nix
      ../../modules/sway.nix
      ../../modules/gaming.nix
      ../../modules/mail.nix
      ../../modules/photo.nix
      ../../modules/dns.nix
      ../../modules/mdns.nix
      ../../modules/home-printing.nix
    ];

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.${username} = {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = [ "wheel" "docker" "disk" "input" "video" "network" "audio" "dialout" ]; # Enable ‘sudo’ for the user.
  };

  gaming.enable = true;

}
