{ config, pkgs, lib, modulesPath, ... }:

let
  username = "synas";

  # Build custom kernel with exact .config (without NixOS modifications)
  # Using raw kernel builder that doesn't add extra config options
  # Note: We're not using boot.kernelPackages because NixOS modifies the config.
  # Instead, we build the kernel separately and reference it in the image.
  kernel-raw = import ./kernel-raw.nix { inherit pkgs lib; };
in {
  imports = [
    ./hardware-configuration.nix
    ../../modules/mdns.nix
    ../../modules/zsh.nix
    (modulesPath + "/profiles/headless.nix")
    (modulesPath + "/profiles/minimal.nix")
  ];

  disabledModules = [
    (modulesPath + "/profiles/all-hardware.nix")
    (modulesPath + "/profiles/base.nix")
  ];

  # Minimal configuration - disable unnecessary features
  environment.defaultPackages = [];
  xdg.icons.enable = false;
  xdg.mime.enable = false;
  xdg.sounds.enable = false;
  programs.nano.enable = false;

  time.timeZone = "UTC";

  users.users.root = {
    initialPassword = "root";
  };

  # Disable bootloader for rootfs build
  boot.loader.grub.enable = false;

  # Enable serial console on ttyS0 at 115200 baud
  systemd.services."serial-getty@ttyS0" = {
    enable = true;
    wantedBy = [ "getty.target" ];
    serviceConfig.Restart = "always";
  };

  boot.kernelParams = [ "console=ttyS0,115200" ];

  # Disable kernel modules completely
  boot.initrd.enable = false;
  boot.postBootCommands = lib.mkForce "";
  boot.initrd.includeDefaultModules = false;
  boot.initrd.availableKernelModules = lib.mkForce [];
  boot.kernelModules = lib.mkForce [];
  boot.extraModulePackages = lib.mkForce [];

  # Don't include firmware
  hardware.enableAllFirmware = false;
  hardware.enableRedistributableFirmware = false;

  networking = {
    hostName = "synas";
    firewall = {
      enable = true;
      allowedTCPPorts = [ 22 ];
    };
  };

  # Exclude documentation and kernel sources to minimize image size
  documentation.enable = false;
  documentation.nixos.enable = false;
  documentation.man.enable = false;
  documentation.info.enable = false;
  documentation.doc.enable = false;

  environment.systemPackages = with pkgs; [
    vim
    wget
    htop
    rsync
  ];

  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "yes";
    };
  };

  # Define a user account
  users.users.${username} = {
    uid = 1000;
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = [ "wheel" ];
    initialPassword = "synas";
  };

  nix.settings.trusted-users = [ "${username}" ];

  # To make even smaller we can disable nix, this would prevent pulling deps
  # such 66MB of boost
  # nix.enable = false;
  # Disable Nix channels and registry to avoid including nixpkgs source
  nix.channel.enable = false;
  nix.settings.auto-optimise-store = true;
  nix.registry = lib.mkForce {};
  nix.nixPath = lib.mkForce [];

  # Override to not build kernel modules package
  system.modulesTree = lib.mkForce [];

  # Remove system tools that depend on Python/Perl
  system.disableInstallerTools = true;

  # Exclude kernel sources and build artifacts from the image
  system.extraDependencies = [];

  # Don't include kernel modules in the system closure
  system.replaceDependencies.replacements = lib.mkForce [];

  # Build a raw ext4 partition image using make-ext4-fs
  system.build.ext4Image = pkgs.callPackage "${toString modulesPath}/../lib/make-ext4-fs.nix" {
    storePaths = [ config.system.build.toplevel ];
    volumeLabel = "NIXOS_SYNAS";
    populateImageCommands = ''
      # Create init symlink for easy booting
      ln -s ${config.system.build.toplevel}/init ./files/init

      # Add custom kernel bzImage to /boot (built with exact .config)
      mkdir -p ./files/boot
      cp ${kernel-raw}/bzImage ./files/boot/bzImage
    '';
  };

  system.stateVersion = "24.11";
}
