# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, modulesPath, ... }:
let
  username = "jkaisrli";
in {
  imports =
    [
      ./hardware-configuration.nix
      ../../modules/common.nix
      ../../modules/sway.nix
      ../../modules/mail.nix
      ../../modules/builder.nix
      ../../modules/dns.nix
    ];

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.${username} = {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = [ "wheel" "docker" "disk" "input" "video" "network" "audio" ]; # Enable ‘sudo’ for the user.
  };

  intelize-vpn.enable = true;
  intelize-mail.enable = true;
  intelize-cert.enable = true;
  intelize-firefox.enable = true;
  intelize-email-oauth2-proxy.enable = true;

  networking.nameservers = [ "1.1.1.1" "8.8.8.8"];
}
