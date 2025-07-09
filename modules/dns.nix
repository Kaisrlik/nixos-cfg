{ pkgs, ... }:
{
  networking.networkmanager.dns = "systemd-resolved";

  services.resolved = {
    enable = true;
    # dnssec = "true";
    domains = [ "~." ];
    fallbackDns = [ "1.1.1.1" "1.0.0.1" ];
    # dnsovertls = "true";
  };
}
