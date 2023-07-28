{
	description = "Xeris NIXOS";

	inputs.nixpkgs.url = "nixpkgs/nixos-23.05";

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
					modules = [ ./configuration.nix ];
				};
			};
		};
}
