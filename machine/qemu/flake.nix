{
	inputs = {
		nixpkgs.url = "nixpkgs/nixos-unstable";
		nixos-generators = {
			url = "github:nix-community/nixos-generators";
			inputs.nixpkgs.follows = "nixpkgs";
		};
	};

	outputs = { self, nixpkgs, nixos-generators, ... }:
	let
		system = "x86_64-linux";
		pkgs = nixpkgs.legacyPackages.${system};
		my_qemu = pkgs.qemu.overrideAttrs (old: {
			version = "git";
			src = pkgs.fetchFromGitHub {
				owner = "";
				repo = "";
				rev = "";
				sha256 = pkgs.lib.fakeSha256;
			};
		});
	in {
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

		packages.x86_64-linux = {
			qcow = nixos-generators.nixosGenerate {
				system = "x86_64-linux";
				modules = [
					./configuration.nix
				];
				format = "qcow";
			};
		};
		devShells.x86_64-linux.default = pkgs.mkShell {
			packages = with pkgs; [
				my_qemu
			];
		};
	};
}
