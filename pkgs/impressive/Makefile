all:
	nix build --impure --expr '{pkgs ? import <nixpkgs> {} }: {stable = with pkgs; callPackage ./default.nix {};}'
