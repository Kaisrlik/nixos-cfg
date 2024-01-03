{ lib, stdenv, pkgs, python3Packages }:

stdenv.mkDerivation rec {
	pname = "email-oauth2-proxy";
	version = "2023-12-19-intel";
	src = ./applications.provisioning.linux-at-intel.email-oauth2-proxy-2023-12-19-intel;

	# runtime dependecies
	buildInputs = with python3Packages; [ cryptography ];
	# build env dependecies
	nativeBuildInputs = with pkgs; [ makeWrapper ];

	buildPhase = '' '';
	installPhase = ''
		install -D -m 0755 $src/emailproxy.py $out/bin/emailproxy
	'';

	postFixup = ''
		wrapProgram $out/bin/emailproxy \
			--set PYTHONPATH $PYTHONPATH
	'';
}
