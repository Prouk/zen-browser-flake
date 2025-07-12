{
  infos,
  pkgs ? import <nixpkgs> { },
}:
let
  runtimeLibs =
    with pkgs;
    [
      gtk3
      glib
      dbus-glib
      libgcc.lib
      pango
      atk
      cairo
      gdk-pixbuf
      alsa-lib
      pciutils
      libGL
      libva
      libva-vdpau-driver
      ffmpeg-full
    ]
    ++ (with pkgs.xorg; [
      libxcb
      libX11
      libXext
      libXrandr
      libXcomposite
      libXcursor
      libXdamage
      libXfixes
      libXi
    ]);
in
pkgs.stdenv.mkDerivation {
  pname = "zen";
  applicationName = "Zen Browser";
  version = infos.tag_name;

  desktopSrc = ./.;

  src = pkgs.fetchurl {
    url = infos.browser_download_url;
    sha256 = infos.digest;
  };

  phases = "unpackPhase installPhase fixupPhase";

  nativeBuildInputs = with pkgs; [
    makeWrapper
    wrapGAppsHook3
  ];

  installPhase = ''
    mkdir -p $out/bin
    cp -r . $out/bin

    install -D $desktopSrc/zen.desktop $out/share/applications/zen.png
    install -D ./browser/chrome/icons/default/default128.png $out/share/icons/hicolor/apps/zen.png
  '';

  fixupPhase = ''
    chmod 755 $out/bin/*

    for b in zen zen-bin glxtest vaapitest
    do
      patchelf --set-interpreter ${pkgs.binutils.dynamicLinker} $out/bin/$b
      wrapProgram $out/bin/$b \
        --set LD_LIBRARY_PATH ${pkgs.lib.makeLibraryPath runtimeLibs}
    done

  '';

  meta = {
    mainProgram = "zen";
    description = ''
      Zen is a firefox-based browser with the aim of pushing your productivity to a new level!
    '';
  };

  
    passthru.gtk3 = pkgs.gtk3;
  
}
