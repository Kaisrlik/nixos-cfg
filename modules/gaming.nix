{ config, lib, pkgs, ... }:
let
  proton-ge-custom = (import ../pkgs/proton-ge-custom { inherit pkgs; });
in {
  environment.systemPackages = with pkgs; [
    discord
    proton-ge-custom
  ];

  programs.steam = {
    enable = true;
    # Open ports in the firewall for Steam Remote Play
    remotePlay.openFirewall = true;
    # Open ports in the firewall for Source Dedicated Server
    dedicatedServer.openFirewall = true;
  };

  environment.variables.STEAM_EXTRA_COMPAT_TOOLS_PATHS = "${proton-ge-custom}";
}
