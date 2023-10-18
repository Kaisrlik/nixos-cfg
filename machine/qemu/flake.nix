{
	outputs = { self, nixpkgs, }:
	{
		nixosModules.base = {pkgs, ...}: {
			imports = [
					./configuration.nix
				];
		};

		nixosModules.vm = {...}: {
			virtualisation.vmVariant.virtualisation.graphics = false;
		};
		nixosConfigurations.linuxVM = nixpkgs.lib.nixosSystem {
			system = "x86_64-linux";
			modules = [
				self.nixosModules.base
				self.nixosModules.vm
			];
		};
	};
}
