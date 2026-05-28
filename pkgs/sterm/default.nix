{ stdenv, pkgs, fetchFromGitHub }:
stdenv.mkDerivation {
  name = "sterm";
  src = fetchFromGitHub {
    owner = "wentasah";
    repo = "sterm";
    rev = "257375b8ee481e07562002eb4c2f5979a68a8317";
    sha256 = "sha256-/Ob7BzrJ2EZH8UOYjZmKAGG3+9Z3yB2ErWB4NtuxO1w=";
  };

  nativeBuildInputs = [ pkgs.installShellFiles ];

  installPhase = ''
    make install PREFIX=$out NO_COMP=1
    installShellCompletion --bash --name sterm completion.bash
    installShellCompletion --zsh --name _sterm completion.zsh
    installShellCompletion --fish --name sterm.fish completion.fish
  '';
}
