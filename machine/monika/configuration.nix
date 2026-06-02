{ pkgs, ... }:
let
  username = "monika";
in {
  imports =
    [
      ./hardware-configuration.nix
      ../../modules/common.nix
      ../../modules/firefox.nix
      ../../modules/kde.nix
      ../../modules/gaming.nix
      ../../modules/photo.nix
      ../../modules/dns.nix
      ../../modules/mdns.nix
      # ../../modules/home-printing.nix
      (import ../../modules/sshd.nix {inherit username;})
    ];

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.${username} = {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = [ "wheel" "disk" "input" "video" "network" "audio" ];
  };

  gaming.enable = true;

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "monika-ntb";

  environment.systemPackages = with pkgs; [
    libreoffice-qt
    google-chrome
    xnviewmp
  ];

}
