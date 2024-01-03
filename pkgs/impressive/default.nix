{ lib, stdenv, pkgs, python3Packages, SDL2, mupdf, coreutils }:

stdenv.mkDerivation rec {
	pname = "impressive0131";
	version = "0.13.1";
	src = fetchTarball {
		url = "http://downloads.sourceforge.net/impressive/Impressive-0.13.1.tar.gz";
		sha256 = "158gnm96xg15d769y91s6ksy845vnngc45nskh2i26db9k70nyw3";
	};

	# runtime dependecies
	buildInputs = [ SDL2 mupdf ] ++ (with python3Packages; [ pillow pygame ]);
	# build env dependecies
	nativeBuildInputs = with pkgs; [
		makeWrapper
	];

	buildPhase = '' '';
	installPhase = ''
		install -D -m 0755 $src/impressive.py $out/bin/impressive
	'';

	postFixup = ''
		# TODO: fix propper passing of SDL2
		# for some reason CDLL does not use LD_LIBRARY_PATH
		sed -i "s#sdl = CDLL(sdl, RTLD_GLOBAL)#sdl = CDLL(\"${lib.makeLibraryPath [ SDL2 ]}/libSDL2.so\", RTLD_GLOBAL)#" $out/bin/impressive
		wrapProgram $out/bin/impressive \
			--set PATH ${pkgs.lib.makeBinPath [ mupdf coreutils ]} \
			--set PYTHONPATH $PYTHONPATH \
			--prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ SDL2 ]}
	'';
}
