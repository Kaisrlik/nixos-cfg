# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, modulesPath, ... }:
let
  username = "xeri";
in {
  imports = [
      ./hardware-configuration.nix
#     <nixpkgs/nixos/modules/profiles/headless.nix>
#     <nixpkgs/nixos/modules/profiles/minimal.nix>
  ];

  # only add strictly necessary modules
  # boot.initrd.includeDefaultModules = false;
  # boot.initrd.kernelModules = [ "ext4" ... ];
  # disabledModules =
  # [
  #   <nixpkgs/nixos/modules/profiles/all-hardware.nix>
  #   <nixpkgs/nixos/modules/profiles/base.nix>
  # ];

  # disable useless software
  environment.defaultPackages = [];
  xdg.icons.enable  = false;
  xdg.mime.enable   = false;
  xdg.sounds.enable = false;

  time.timeZone = "Europe/Prague";
  users.users.root = {
      initialPassword = "root";
  };

  networking = {
      hostName = "pihub";
  };
  # nfs
  networking.firewall = {
    enable = true;
      # for NFSv3; view with `rpcinfo -p`
    allowedTCPPorts = [ 111 2049 4000 4001 4002 20048 ];
    allowedUDPPorts = [ 111 2049 4000 4001 4002 20048 ];
  };

  environment.systemPackages = with pkgs; [
      nginx
      pciutils
      vim
      wget
  ];
  services.nfs.server = {
    enable = true;
    # fixed rpc.statd port; for firewall
    lockdPort = 4001;
    mountdPort = 4002;
    statdPort = 4000;
    extraNfsdConfig = '''';
  };
  services.nfs.server.exports = ''
    /export         192.168.1.0/24(insecure,rw,sync,no_subtree_check,crossmnt,fsid=0)
    /export/data    192.168.1.0/24(insecure,rw,sync,no_subtree_check)
  '';

  services.openssh = {
      enable = true;
  };
  system.stateVersion = "24.11";

  programs.zsh.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.${username} = {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = [ "wheel" "docker" "disk" "input" "video" "network" "audio" ]; # Enable ‘sudo’ for the user.
    initialPassword = "xeri";
    openssh.authorizedKeys.keys = [
    # beast
    "AAAAB3NzaC1yc2EAAAADAQABAAABgQCqo5qym7gpyFrfoUzWW8v48ovVL/oI5TC0wdhnH0ZTp1OpAhWUlF96EHHmVCi0Agrx5Blf86/hbx07vzzrS+MVsg+dRkaaaMcn3JoBrUykvkttey8SseRFJJmP4+Upu1fyBv3CzVqrn5SZ2jhw2Ti1EbCz82gVIeA5cJhRb+i+VckEOfkOQT4VnS175b+U5+/TZl3jfTf9cyoVXziaS7jHEh2/yWE60Cdzdbje6VZuxM/zVSf7TZsQ/tTqnP7uWEDC9d0La7cfSHzYZnh2mULpcr1M6F+gukIZHk2UOhuPiC/SIk3B1xElPz1azi3QxW0KKRI4gvgplh6Ft+jVbtkYQHVE0cvrFu98EuUTm96kg/dQ1T6O5XohyKop930MMic5raNdcAXj4a0eYrN9GnMklYUhP2XQO3b+z81QgSO3dXBJyjeX1oazEpx6kAPaNYpsleyJO6gXjAnZpRyUypQUayKTttsg7XtPKwKWYpjsZtC771AJfptiBdKd4a+xGVk="
    ];
  };
}
