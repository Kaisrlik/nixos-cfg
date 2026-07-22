{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    ccls
    ctags
    ripgrep
    ltex-ls
    nil
    shellcheck
    tree-sitter nodejs-slim

    cmake
    meson
    ninja
    gcc

    pi-coding-agent
  ];

  # libraries and dev utils may provide additional documentation/man-pages
  documentation.dev.enable = true;
}
