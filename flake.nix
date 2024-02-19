{
	description = "Xeris NIXOS";

	inputs.nixpkgs.url = "nixpkgs/nixos-unstable-small";

	outputs = { self, nixpkgs }:
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
					modules = [ ./machine/intel/configuration.nix ];
				};
				beast = lib.nixosSystem {
					inherit system;
					modules = [ ./machine/beast/configuration.nix ];
				};
			};
		};
}
