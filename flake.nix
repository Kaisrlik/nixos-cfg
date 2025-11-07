{
  description = "Xeris NIXOS";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable-small";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    dot-files = {
      url = "git+file:///home/xeri/devel/configs";
      flake = false;
    };
#     nixify-cfg = {
#         url = "git+file:./nixify-cfg";
#         inputs.nixpkgs.follows = "nixpkgs";
#     };
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs:
  let
    system = "x86_64-linux";
    lib = nixpkgs.lib;
  in {
    homeConfigurations.xeri = home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages.${system};
      modules = [ ./modules/home.nix ];
      extraSpecialArgs = { inherit inputs; };
    };

    nixosConfigurations = {
      intel = lib.nixosSystem {
        inherit system;
        inherit (nixpkgs) lib;
        modules = [
          ./machine/intel/configuration.nix
          inputs.nixify-cfg.nixosModules.intelize
        ];
      };
      beast = lib.nixosSystem {
        inherit system;
        modules = [ ./machine/beast/configuration.nix ];
      };
    };
  };
}
