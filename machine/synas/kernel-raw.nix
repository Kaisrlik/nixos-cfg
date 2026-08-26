{ pkgs, lib }:

# Build kernel directly without NixOS's config modifications
pkgs.stdenv.mkDerivation rec {
  pname = "linux-synas";
  version = "6.12.47";

  src = pkgs.fetchurl {
    url = "mirror://kernel/linux/v6.x/linux-${version}.tar.xz";
    sha256 = "099fj9qd8knafbl400drm8aqn5h7y6g39gc7d4i4hc3lf44f8bz8";
  };

  nativeBuildInputs = with pkgs; [
    bc
    bison
    flex
    openssl
    perl
    elfutils
    pahole
  ];

  # Use our exact config
  configurePhase = ''
    runHook preConfigure

    # Copy our config
    cp ${./.config} .config

    # Don't let kernel modify our config
    make olddefconfig

    runHook postConfigure
  '';

  buildPhase = ''
    runHook preBuild

    make -j$NIX_BUILD_CORES bzImage

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cp arch/x86/boot/bzImage $out/bzImage
    cp .config $out/config
    cp System.map $out/System.map

    # Make it compatible with linuxPackagesFor
    echo "${version}" > $out/kernel-version

    runHook postInstall
  '';

  passthru = {
    inherit version;
    modDirVersion = version;
    isZen = false;
    isLibre = false;
    kernelOlder = lib.versionOlder version;
    kernelAtLeast = lib.versionAtLeast version;
  };

  enableParallelBuilding = true;
}
