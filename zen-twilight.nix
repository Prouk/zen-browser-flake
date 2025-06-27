{
  stdenv,
  fetchurl,
  version,
  wrapGAppsHook3,
  autoPatchelfHook,
  makeWrapper,
  gtk3,
  alsa-lib,
  pciutils,
  libGL,
  ...
}:
stdenv.mkDerivation {
  pname = "zen";
  version = version.twilight.tag_name;

  src = fetchurl {
    url = version.twilight.browser_download_url;
    sha256 = version.twilight.digest;
  };

  nativeBuildInputs = [
    wrapGAppsHook3
    autoPatchelfHook
    makeWrapper
  ];

  buildInputs = [
    gtk3
    alsa-lib
    pciutils
    libGL
  ];

  installPhase = ''
    mkdir -p $out/opt/zen
    cp -r . $out/opt/zen
    mkdir -p $out/bin
    makeWrapper $out/opt/zen/zen $out/bin/zen \
      --set MOZILLA_FIVE_HOME "$out/opt/zen" \
      --set LIBGL_DRIVERS_PATH "/run/opengl-driver/lib/dri" \
      --prefix LD_LIBRARY_PATH : "${pciutils}/lib:${libGL}/lib:${libGL}/lib:/run/opengl-driver/lib"
  '';
}
