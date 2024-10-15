{ config, pkgs, ... }:
{
  nix.buildMachines = [{
    hostName = "esc-host";
    system = "x86_64-linux";
    protocol = "ssh-ng";
    maxJobs = 3;
    speedFactor = 2;
    supportedFeatures = [ "nixos-test" "benchmark" "big-parallel" "kvm" ];
    mandatoryFeatures = [ ];
  }];
  # required, otherwise remote buildMachines above aren't used
  nix.distributedBuilds = true;
  # optional, useful when the builder has a faster internet connection than yours
  nix.settings = {
    builders-use-substitutes = true;
  };
}
