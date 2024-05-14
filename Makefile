IMAGE=intel
-include Makefile.local

flake:
	nixos-rebuild switch --impure --flake .#$(IMAGE)

nixify-cfg/.git:
	mkdir nixify-cfg
	echo "{ }" > nixify-cfg/flake.nix
	cd nixify-cfg; git init; git add flake.nix; git commit -m "tmp"
