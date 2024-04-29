{
	description = "Xeris NIXOS";

	inputs = {
		nixpkgs.url = "nixpkgs/nixos-unstable-small";
		nixify-cfg.url = "/home/jkaisrli/devel/nixos-cfg/nixify-cfg";
	};

	outputs = { self, nixpkgs, nixify-cfg, ... }:
		let
			system = "x86_64-linux";
			lib = nixpkgs.lib;
			pkgs = import nixpkgs {
				inherit system;
			};
		in {
			nixosConfigurations = {
				intel = lib.nixosSystem {
					inherit system;
					inherit (nixpkgs) lib;
					modules = [
						./machine/intel/configuration.nix
						nixify-cfg.nixosModules.intelize
					];
				};
				beast = lib.nixosSystem {
					inherit system;
					modules = [ ./machine/beast/configuration.nix ];
				};
			};
		};
}
