{
  stdenv,
  version,
  autoPatchelfHook,
  patchelfUnstable,
  gtk3,
  libva,
  alsa-lib,
  pciutils,
  libGL,
  ...
}:
stdenv.mkDerivation {
  pname = "Zen Browser";
  version = version.beta.tag_name;

  desktopSrc = ./zen-twilight.desktop;

  src = builtins.fetchurl {
    url = version.beta.browser_download_url;
    sha256 = version.beta.digest;
    name = "zen-linux.tar.xz";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    patchelfUnstable
  ];

  buildInputs = [
    alsa-lib
    gtk3
  ];

  runtimeDependencies = [
    libva
    pciutils
    libGL
  ];

  installPhase = ''
    mkdir -p "$prefix/lib/zen-${version.beta.tag_name}"
    cp -r * "$prefix/lib/zen-${version.beta.tag_name}"

    mkdir -p $out/bin
    ln -s "$prefix/lib/zen-${version.beta.tag_name}/zen" $out/bin/zen
  '';

  patchelfFlags = [ "--no-clobber-old-sections" ];

  meta = {
    mainProgram = "zen";
    description = ''
      Zen is a privacy-focused browser that blocks trackers, ads, and other unwanted content while offering the best browsing experience!
    '';
  };

  passthru = {
    libName = "zen-${version.beta.tag_name}";
    binaryName = "zen";
    gssSupport = true;
    ffmpegSupport = true;
  };
}
