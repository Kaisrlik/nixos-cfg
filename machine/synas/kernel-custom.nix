{ pkgs, ... }:

let
  myCustomKernel = pkgs.linuxManualConfig {
    version = "6.12.47";
    src = pkgs.fetchurl {
      url = "mirror://kernel/linux/v6.x/linux-6.12.47.tar.xz";
      sha256 = "sha256-6C/kCHF0MEgiaYe9NJ7xBxaLFaq5AUDocspO1HCSLiU=";
    };
    configfile = ./.config;
  };
in
pkgs.linuxPackagesFor myCustomKernel
