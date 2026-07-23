{ pkgs }:
pkgs.mkShell {
  packages = [
    pkgs.typst
  ];
}
