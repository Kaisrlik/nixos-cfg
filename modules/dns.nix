{ ... }:
{
  networking.networkmanager.dns = "systemd-resolved";

  services.resolved = {
    enable = true;
    settings = {
      Resolve = {
        Domains = [ "~." ];
        FallbackDNS = [ "1.1.1.1" "1.0.0.1" ];
        # DNSSEC = "true";
        # DNSOverTLS = "true";
      };
    };
  };
}
