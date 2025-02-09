sd_image:
	nix build '.#nixosConfigurations.pihub.config.system.build.sdImage'

config:
	nix build '.#nixosConfigurations.pihub.config.hardware.raspberry-pi.config-output'
	cat result

build:
	nix build '.#nixosConfigurations.pihub.config.system.build.toplevel'

deploy: build
	nix-copy-closure --to pi $(shell readlink -f result/)
	ssh -t pi sudo $(shell readlink -f result/)/bin/switch-to-configuration switch
	# Does not work due to cross compilation
	# nixos-rebuild --target-host pihub --use-remote-sudo switch --flake .
