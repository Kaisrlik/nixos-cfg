{ pkgs, ...}:
{
  services.xserver = {
    enable = true;
    # Configure keymap in X11
    layout = "us";
    xkbOptions = "eurosign:e";

    desktopManager = {
      xterm.enable = false;
    };
    displayManager = {
      defaultSession = "none+i3";
    };

    windowManager.i3 = {
      enable = true;
      extraPackages = with pkgs; [
        dmenu
        i3blocks
        i3lock
      ];
    };
    # Enable touchpad support (enabled default in most desktopManager).
    libinput.enable = true;
  };
}
