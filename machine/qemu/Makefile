# Running this will yield 2 'result' directories, one with a wrapper to run
# a qemu test vm to try out the configurtion and the other containing a sanitary
# qcow2 image.

build:
	nix-build
	# NIX_PATH=$NIX_PATH:nixos-config=./configuration.nix nix-build

# Runner is using following variables
# export QEMU_OPTS="-nographic -serial mon:stdio"
# export QEMU_KERNEL_PARAMS=console=ttyS0
# export QEMU_NET_OPTS="hostfwd=tcp::2222-:22"
build_qemu_in_runner:
	nixos-rebuild -I nixos-config=./configuration.nix build-vm

flake:
	nixos-rebuild --flake .#linuxVM build-vm
