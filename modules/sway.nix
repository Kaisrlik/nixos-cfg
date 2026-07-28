{ pkgs, ... }:
{
  nixpkgs.overlays = [
    (final: prev: {
      xdg-desktop-portal-wlr = prev.xdg-desktop-portal-wlr.overrideAttrs (oldAttrs: {
        version = "0.8.4";
        src = oldAttrs.src.override {
          rev = "v0.8.4";
          sha256 = "sha256-8Ohgkz13FcG8ddjjgreXkvFD2Q+zUDZnAM4Oh+C9P/s=";
        };
      });
    })
  ];


  services.displayManager.ly.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;

  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    extraPackages = with pkgs; [
      swaylock
      swayidle
      wl-clipboard
      wlr-randr
      wlr-which-key
      bemenu
      i3blocks
      mako # notification daemon
      sysstat # cpu_stats script
    ];
  };

  xdg.portal = {
    enable = true;
    # enable share sreen
    wlr = {
      enable = true;
      settings.screencast = {
        # max_fps = 30;
        chooser_type = "dmenu";
        chooser_cmd = "${pkgs.bemenu}/bin/bemenu -l 12 --center --width-factor 0.5 -p \"Share window:\" -i -B 3";
        # exec_before = "${pkgs.swaynotificationcenter}/bin/swaync-client --dnd-on";
        # exec_after = "${pkgs.swaynotificationcenter}/bin/swaync-client --dnd-off";
      };
    };
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
      xdg-desktop-portal-wlr
    ];
  };

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
    wireplumber.enable = true;
  };

  environment.sessionVariables = {
    MOZ_ENABLE_WAYLAND = "1";
    XDG_CURRENT_DESKTOP = "sway";
  };
}
