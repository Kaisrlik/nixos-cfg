# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ pkgs, ... }:
let
  username = "jkaisrli";
in {
  imports =
    [
      ./hardware-configuration.nix
      ../../modules/common.nix
      ../../modules/devel.nix
      ../../modules/sway.nix
      ../../modules/mail.nix
      ../../modules/builder.nix
      ../../modules/dns.nix
      ../../modules/firefox.nix
      ../../modules/office.nix
    ];

  environment.systemPackages = with pkgs; [
    # sops
    age
    sops

    github-copilot-cli
  ];

  # sops configuration
  sops = {
    defaultSopsFile = secrets/secrets.yaml;
    defaultSopsFormat = "yaml";
    age = {
      keyFile = "/home/jkaisrli/.config/sops/age/keys.txt";
    };
    secrets = {
      "mg-token" = {
        owner = "jkaisrli";
        group = "users";
        mode = "0400";
      };
    };
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.${username} = {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = [ "wheel" "docker" "dialout" "disk" "input" "video" "network" "audio" ];
  };

  intelize = {
    user = {
      idsid = "jkaisrli";
      email = "jan.kaisrlik@intel.com";
    };
    feature = {
      cert.enable = true;
      email-oauth2-proxy.enable = true;
      firefox.enable = true;
      fonts.enable = true;
      fleet.enable = true;
      krb.enable = true;
      vpn.enable = true;
      falcon.enable = true;
    };
  };

  networking.nameservers = [ "1.1.1.1" "8.8.8.8"];

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
