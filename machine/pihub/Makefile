all:
	nix build '.#nixosConfigurations.pihub.config.system.build.sdImage'

config:
	nix build '.#nixosConfigurations.pihub.config.hardware.raspberry-pi.config-output'
	cat result
