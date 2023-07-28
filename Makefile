switch:
	nixos-rebuild switch -I nixos-config=./configuration.nix

flake:
	nixos-rebuild switch --impure --flake .#intel
