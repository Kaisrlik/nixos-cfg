{ pkgs, ... }:
{
  services = {
    desktopManager.plasma6.enable = true;

    # Default display manager for Plasma
    displayManager.plasma-login-manager.enable = true;
  };
  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    plasma-browser-integration
    konsole
    elisa
  ];

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
      xdg-desktop-portal-wlr
    ];
  };

  security.polkit.enable = true;
  services.pipewire.enable = true;
}
