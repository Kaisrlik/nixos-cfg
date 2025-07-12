{ pkgs, ... }:
{
  services.printing.enable = true;

  hardware.printers = {
    ensureDefaultPrinter = "xerox-ipp";
    ensurePrinters = [
      {
        deviceUri = "dnssd://xerox_b230_printer._ipp._tcp.local/?uuid=027de58c-08f6-46c3-9f2e-c1d47dd422e4";
        location = "home";
        name = "xerox-ipp";
        model = "everywhere";
      }
    ];
  };
}

