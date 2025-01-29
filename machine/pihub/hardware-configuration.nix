{ pkgs, ... }:
{
  hardware.raspberry-pi.config.all = {
    options = {
      # Automatically load overlays for detected cameras
      camera_auto_detect.enable = false;
      # Disable compensation for displays with overscan
      disable_overscan.enable = false;
      # Automatically load overlays for detected DSI displays
      display_auto_detect.enable = false;
    };
    dt-overlays.vc4-kms-v3d.enable = false;
    base-dt-params = {
      # Enable the PCIe external connector
      pciex1.enable = true;
      # Force Gen 3.0 speeds
      # WARNING The Raspberry Pi 5 is not certified for Gen 3.0 speeds, and
      # connections to PCIe devices at these speeds may be unstable. You should
      # then reboot your Raspberry Pi for these settings to take effect.
      pciex1_gen = {
        enable = true;
        value = 3;
      };
    };
  };

  raspberry-pi-nix.board = "bcm2712";

  # only add strictly necessary modules
  boot.initrd.includeDefaultModules = false;
  boot.initrd.availableKernelModules = [
    "nvme"
    "usb_storage"
    "usbhid"
    "xhci_pci"
  ];
}
