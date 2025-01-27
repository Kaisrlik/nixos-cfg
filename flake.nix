{
  description = "Xeris NIXOS";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable-small";
#     nixify-cfg = {
#         url = "git+file:./nixify-cfg";
#         inputs.nixpkgs.follows = "nixpkgs";
#     };
  };

  outputs = { self, nixpkgs, ... }@inputs:
  let
    system = "x86_64-linux";
    lib = nixpkgs.lib;
  in {
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
