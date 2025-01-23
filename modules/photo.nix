{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    darktable
    gphoto2
    hdrmerge
    rawtherapee
  ];
}
