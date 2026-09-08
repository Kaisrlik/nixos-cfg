{ pkgs }:
pkgs.mkShell {
  packages = with pkgs; [
    tinymist
    typst
  ];
}
