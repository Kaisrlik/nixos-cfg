{ ... }:
{
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
    settings = {
      server = {
        use-ipv4 = true;
        use-ipv6 = true;
      };
      publish = {
        disable-publishing = false;
        publish-addresses = true;
        publish-workstation = true;
      };
    };
  };
}
