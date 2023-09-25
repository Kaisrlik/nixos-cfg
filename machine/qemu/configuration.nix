{ hostName, pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
  ];

  networking.hostName = hostName;
  system.copySystemConfiguration = true;

  environment.systemPackages = with pkgs; [
    iputils
    strace
    tcpdump
    traceroute
    vim
  ];

  services.ntp = {
    enable = true;
    servers = [ "time.google.com" ];
  };

  services.openssh.enable = true;
  programs.bash.enableCompletion = true;
  security.sudo.enable = true;

  users.users.dev = {
    isNormalUser = true;
    initialPassword = "";
    extraGroups = [ "wheel" ];
    # openssh.authorizedKeys.keyFiles = [ ./machine_rsa.pub ];
  };

  system.stateVersion = "23.05";
}
