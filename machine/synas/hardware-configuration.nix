{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [ ];

  # Minimal configuration - no kernel modules, no initrd
  boot.initrd.enable = lib.mkForce false;
  boot.initrd.availableKernelModules = lib.mkForce [ ];
  boot.initrd.kernelModules = lib.mkForce [ ];
  boot.kernelModules = lib.mkForce [ ];
  boot.extraModulePackages = lib.mkForce [ ];

  # Since this is a rootfs, we don't define filesystems here
  # They will be configured on the target system
  fileSystems."/" = lib.mkDefault {
    device = "/dev/disk/by-label/nixos";
    fsType = "ext4";
  };

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
