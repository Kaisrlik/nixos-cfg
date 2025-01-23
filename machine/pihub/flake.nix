{
  description = "Pi hub";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    raspberry-pi-nix.url = "github:nix-community/raspberry-pi-nix/v0.4.1";
  };

  nixConfig = {
    # Only during the first build, otherwise I don't want to allow such a binary cache
    extra-substituters = [ "https://nix-community.cachix.org" ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

  outputs = { self, nixpkgs, raspberry-pi-nix }:
    let
      inherit (nixpkgs.lib) nixosSystem;
      basic-config = { pkgs, lib, ... }: {
        raspberry-pi-nix.board = "bcm2712";
        time.timeZone = "Europe/Prague";
        users.users.root = {
          initialPassword = "root";
        };
        # Define a user account. Don't forget to set a password with ‘passwd’.
        users.users.xeri = {
          isNormalUser = true;
          extraGroups = [ "wheel" ];
          initialPassword = "xeri";
          openssh.authorizedKeys.keys = [
            # beast
            "AAAAB3NzaC1yc2EAAAADAQABAAABgQCqo5qym7gpyFrfoUzWW8v48ovVL/oI5TC0wdhnH0ZTp1OpAhWUlF96EHHmVCi0Agrx5Blf86/hbx07vzzrS+MVsg+dRkaaaMcn3JoBrUykvkttey8SseRFJJmP4+Upu1fyBv3CzVqrn5SZ2jhw2Ti1EbCz82gVIeA5cJhRb+i+VckEOfkOQT4VnS175b+U5+/TZl3jfTf9cyoVXziaS7jHEh2/yWE60Cdzdbje6VZuxM/zVSf7TZsQ/tTqnP7uWEDC9d0La7cfSHzYZnh2mULpcr1M6F+gukIZHk2UOhuPiC/SIk3B1xElPz1azi3QxW0KKRI4gvgplh6Ft+jVbtkYQHVE0cvrFu98EuUTm96kg/dQ1T6O5XohyKop930MMic5raNdcAXj4a0eYrN9GnMklYUhP2XQO3b+z81QgSO3dXBJyjeX1oazEpx6kAPaNYpsleyJO6gXjAnZpRyUypQUayKTttsg7XtPKwKWYpjsZtC771AJfptiBdKd4a+xGVk="
          ];
        };

        networking = {
          hostName = "pihub";
        };
        environment.systemPackages = with pkgs; [
          vim
          wget
        ];
        services.openssh = {
          enable = true;
        };
        system.stateVersion = "24.11";
      };
    in
      {
        nixosConfigurations = {
          pihub = nixpkgs.lib.nixosSystem {
            system = "aarch64-linux";
            modules = [
              raspberry-pi-nix.nixosModules.raspberry-pi
              basic-config
              ({ pkgs, modulesPath, ... }: {
                nixpkgs = {
                  localSystem = {
                    system = "x86_64-linux";
                  };
                  crossSystem = {
                    system = "aarch64-linux";
                  };
                # workaround for breaking linux kernel changes https://github.com/NixOS/nixpkgs/issues/154163#issuecomment-1350599022
                 overlays = [
                    (final: super: {
                       makeModulesClosure = x: super.makeModulesClosure (x // { allowMissing = true; });
                     })
                 ];
               }; # nixpkgs end
            })
          ];
        };
      };
    };
}
