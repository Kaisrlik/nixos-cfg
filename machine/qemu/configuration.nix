{ pkgs, ... }:
{
  # TODO: If flakes are used following lines are not needed
  # imports = [
  #   ./hardware-configuration.nix
  # ];
  # system.copySystemConfiguration = true;


  system.stateVersion = "23.05";

  networking.firewall.enable = false;

  environment.systemPackages = with pkgs; [
    iputils
    strace
    tcpdump
    traceroute
    vim
  ];

  virtualisation.vmVariant = {
    # following configuration is added only when building VM with build-vm
    virtualisation = {
      memorySize = 2048; # Use 2048MiB memory.
      cores = 3;
      graphics = false;
    };
  };

  services.openssh.enable = true;
  programs.bash.enableCompletion = true;

  users.users.dev = {
    isNormalUser = true;
    initialPassword = "";
    extraGroups = [ "wheel" ];
  # openssh.authorizedKeys.keyFiles = [ ./machine_rsa.pub ];
  };
  services.getty.autologinUser = "dev";

  security.sudo = {
    enable = true;
    wheelNeedsPassword = false;
  };
}
