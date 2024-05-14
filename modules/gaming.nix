{ config, lib, pkgs, ... }:
let
  proton-ge-custom = (import ../pkgs/proton-ge-custom { inherit pkgs; });
in {

  options = {
    gaming.enable = lib.mkEnableOption "enables gaming module";
  };

  config = lib.mkIf config.gaming.enable {
    environment.systemPackages = with pkgs; [
      discord
      mangohud
      gamescope
      proton-ge-custom
    ];

    programs.steam = {
      enable = true;
      # Open ports in the firewall for Steam Remote Play
      remotePlay.openFirewall = true;
      # Open ports in the firewall for Source Dedicated Server
      dedicatedServer.openFirewall = true;
    };
    programs.gamemode.enable = true;

    environment.variables.STEAM_EXTRA_COMPAT_TOOLS_PATHS = "${proton-ge-custom}";
  };
}
