IMAGE=intel
-include Makefile.local

flake:
	# Following cmds do: nixos-rebuild switch --flake .#$(IMAGE)
	# Avoid running nix build under root user
	nix build .#nixosConfigurations.$(IMAGE).config.system.build.toplevel
	# Workaround to isntall to bootloader
	# https://github.com/NixOS/nixpkgs/issues/82851
	sudo nix-env -p /nix/var/nix/profiles/system --set ./result
	sudo result/bin/switch-to-configuration switch

home:
	home-manager switch --flake .

nixify-cfg/.git:
	mkdir nixify-cfg
	echo "{ }" > nixify-cfg/flake.nix
	cd nixify-cfg; git init; git add flake.nix; git commit -m "tmp"

monika:
	nixos-rebuild --target-host monika --use-remote-sudo switch --flake .#monika --ask-elevate-password

synas:
	nix build .#nixosConfigurations.$@.config.system.build.ext4Image -o result-synas-img
