{ pkgs, ... }:
{
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;

  # To disable installing GNOME's suite of applications
  # and only be left with GNOME shell.
  services.gnome.core-apps.enable = false;
  services.gnome.core-developer-tools.enable = false;
  services.gnome.games.enable = false;
  services.gnome.gcr-ssh-agent.enable =false;
  environment.gnome.excludePackages = with pkgs; [ gnome-tour gnome-user-docs ];
  # environment.systemPackages = with pkgs; [
  #   gnomeExtensions.arc-menu
  # ];

  qt = {
    enable = true;
    platformTheme = "gnome";
    style = "adwaita-dark";
  };

  programs.dconf.profiles.user.databases = [{
    settings = { "org/gnome/desktop/interface" = { color-scheme = "prefer-dark"; }; };
  }];

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
