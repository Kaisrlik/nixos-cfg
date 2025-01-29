{
  description = "Pi hub";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11-small";
    raspberry-pi-nix.url = "github:nix-community/raspberry-pi-nix/v0.4.1";
  };

  nixConfig = {
    # Only during the first build, otherwise I don't want to allow such a binary cache
    extra-substituters = [ "https://nix-community.cachix.org" ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

  outputs = { self, nixpkgs, raspberry-pi-nix }: {
    nixosConfigurations = {
      pihub = nixpkgs.lib.nixosSystem {
        system = "aarch64-linux";
        modules = [
          raspberry-pi-nix.nixosModules.raspberry-pi
          ./configuration.nix
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
           };
          })
        ];
      };
    };
  };
}
