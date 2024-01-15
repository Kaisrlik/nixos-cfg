{ pkgs, ... }:
{
  # TODO: If flakes are used following lines are not needed
  # imports = [
  #   ./hardware-configuration.nix
  # ];
  # system.copySystemConfiguration = true;


  system.stateVersion = "23.11";

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
    # TODO: with troubles with login, please remove qcow2 file
    # Generated via `mkpasswd -m sha-512 root`
    #hashedPassword = "$6$0VDLplrus3SJr0Q7$U3N4kcBBMJVJ4MDK5Ys8xKYfkuTT.YFGsra.j/ipmz92sCyCD0v7ICRuZ8dRWihEys7ZY79xDPI0Ho3EnvXzz.";
    extraGroups = [ "wheel" ];
  # openssh.authorizedKeys.keyFiles = [ ./machine_rsa.pub ];
  };
  services.getty.autologinUser = "dev";

  security.sudo = {
    enable = true;
    wheelNeedsPassword = false;
  };
}
