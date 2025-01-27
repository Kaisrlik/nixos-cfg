{ ... }:
{
  nix = {
    buildMachines = [{
      hostName = "esc-host";
      system = "x86_64-linux";
      protocol = "ssh-ng";
      maxJobs = 3;
      speedFactor = 2;
      supportedFeatures = [ "nixos-test" "benchmark" "big-parallel" "kvm" ];
      mandatoryFeatures = [ ];
    }];
    # required, otherwise remote buildMachines above aren't used
    distributedBuilds = true;
    # optional, useful when the builder has a faster internet connection than yours
    settings = {
      builders-use-substitutes = true;
    };

    settings = {
      trusted-substituters = [
        "http://nix-cache.dssaesc.igk.intel.com"
        "https://cache.nixos.org"
      ];
      trusted-public-keys = [
        "nix-cache.dssaesc.igk.intel.com:Z+oi5yvZU1IZlO08ial9nqH8+93aX3sibxo9Uja5Aug="
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      ];
  };
  };
}
