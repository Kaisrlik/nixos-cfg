IMAGE=intel
-include Makefile.local

flake:
	# Following cmds do: nixos-rebuild switch --flake .#$(IMAGE)
	# Avoid running nix build under root user
	nix build .#nixosConfigurations.$(IMAGE).config.system.build.toplevel
	sudo result/bin/switch-to-configuration switch

nixify-cfg/.git:
	mkdir nixify-cfg
	echo "{ }" > nixify-cfg/flake.nix
	cd nixify-cfg; git init; git add flake.nix; git commit -m "tmp"
