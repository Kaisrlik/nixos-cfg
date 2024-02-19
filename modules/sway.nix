{ pkgs, ... }:
{
  services.xserver = {
    enable = true;
    # Configure keymap in X11
    xkb.layout = "us";
    xkb.options = "eurosign:e";
    displayManager.gdm.enable = true;
    displayManager.gdm.wayland = true;
    # Enable touchpad support (enabled default in most desktopManager).
    libinput.enable = true;
  };

  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    extraPackages = with pkgs; [
      swaylock
      swayidle
      wl-clipboard
      wlr-randr
      bemenu
      i3blocks
      mako # notification daemon
      sysstat # cpu_stats script
      slurp grim # screen capturing
    ];
  };

  xdg.portal = {
    enable = true;
    # enable share sreen
    wlr.enable = true;
    extraPortals = with pkgs; [
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal-wlr
    ];
  };

  security.polkit.enable = true;

  services.pipewire.enable = true;
  environment.sessionVariables = {
    MOZ_ENABLE_WAYLAND = "1";
    XDG_CURRENT_DESKTOP = "sway";
  };
}
