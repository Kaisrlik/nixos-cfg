{
  description = "Xeris NIXOS";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable-small";
    nixify-cfg = {
        url = "git+file:///home/jkaisrli/devel/nixos-cfg/nixify-cfg";
        inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, ... }@inputs:
  let
    system = "x86_64-linux";
    lib = nixpkgs.lib;
    pkgs = nixpkgs.legacyPackages.${system};
  in {
    nixosConfigurations = {
      intel = lib.nixosSystem {
        inherit system;
        inherit (nixpkgs) lib;
        modules = [
          ./machine/intel/configuration.nix
          inputs.nixify-cfg.nixosModules.intelize
          inputs.sops-nix.nixosModules.sops
        ];
      };
      beast = lib.nixosSystem {
        inherit system;
        modules = [ ./machine/beast/configuration.nix ];
      };
      monika = lib.nixosSystem {
        inherit system;
        modules = [ ./machine/monika/configuration.nix ];
      };
    };

    # devShells
    devShells.x86_64-linux.docs = import ./devshells/docs.nix { inherit pkgs; };
  };
}
