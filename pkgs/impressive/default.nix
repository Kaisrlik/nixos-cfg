{ pkgs ? import <nixpkgs> {} }:
with pkgs;

stdenv.mkDerivation rec {
	pname = "impressive0131";
	version = "0.13.1";
	src = fetchTarball {
		url = "http://downloads.sourceforge.net/impressive/Impressive-0.13.1.tar.gz";
		sha256 = "158gnm96xg15d769y91s6ksy845vnngc45nskh2i26db9k70nyw3";
	};

	# runtime dependecies
	# buildInputs = [ SDL2 mupdf python3Packages.pillow python3Packages.pygame ];
	buildInputs = [ SDL2 mupdf ];
	# build env dependecies
	nativeBuildInputs = [ ];
	buildPhase = '' '';
	installPhase = ''
		mkdir -p $out/bin
		install -m 0755 $src/impressive.py $out/bin/impressive
	'';
}
