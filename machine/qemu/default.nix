{ pkgs ? import <nixpkgs> { } , system ? builtins.currentSystem }:
let
  lib = pkgs.lib;
  nixos =  <nixpkgs/nixos>;
  hostName = "qemu";
  configuration = import ./configuration.nix { inherit hostName pkgs; };

  # Image config
  config = (import nixos { inherit system configuration; });
  make-disk-image = import <nixpkgs/nixos/lib/make-disk-image.nix>;
in
rec {
  runner = config.vm;
  image = make-disk-image {
    inherit pkgs lib;
    config = config.config;

    name = "${hostName}-image";
    format = "qcow2";
    diskSize = 8 * 1024; # megabytes
    postVM = ''
      mv $diskImage ''${diskImage/nixos/${hostName}}
    '';
  };
}
