IMAGE=intel
-include Makefile.local

flake:
	nixos-rebuild switch --impure --flake .#$(IMAGE)
