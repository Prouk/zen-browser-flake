{
  stdenv,
  version,
  autoPatchelfHook,
  patchelfUnstable,
  gtk3,
  alsa-lib,
  dbus-glib,
  libva,
  pciutils,
  adwaita-icon-theme,
  libXtst,
  curl,
  libGL,
  pipewire,
  ...
}:
stdenv.mkDerivation {
  pname = "Zen Browser";
  version = version.twilight.tag_name;

  desktopSrc = ./zen-twilight.desktop;

  src = builtins.fetchurl {
    url = version.twilight.browser_download_url;
    sha256 = version.twilight.digest;
    name = "zen-linux.tar.xz";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    patchelfUnstable
  ];

  buildInputs = [
    gtk3
    alsa-lib
    dbus-glib
    adwaita-icon-theme
    libXtst
  ];

  runtimeDependencies = [
    libGL
    curl
    libva
    pciutils
  ];

  appendRunpaths = [
    "${pipewire}/lib"
  ];

  installPhase = ''
    mkdir -p "$prefix/lib/zen-${version.twilight.tag_name}"
    cp -r * "$prefix/lib/zen-${version.twilight.tag_name}"

    mkdir -p $out/bin
    ln -s "$prefix/lib/zen-${version.twilight.tag_name}/zen" $out/bin/zen
  '';

  patchelfFlags = [ "--no-clobber-old-sections" ];

  meta = {
    mainProgram = "zen";
    description = ''
      Zen is a privacy-focused browser that blocks trackers, ads, and other unwanted content while offering the best browsing experience!
    '';
  };

  passthru = {
    libName = "zen-${version.twilight.tag_name}";
    binaryName = "zen";
    gssSupport = true;
    ffmpegSupport = true;
  };
}
