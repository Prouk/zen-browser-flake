{
  version,
  pkgs ? import <nixpkgs> { },
}:
let
  runtimeLibs = pkgs.lib.makeLibraryPath (
    with pkgs;
    [
    ]
    ++ (with pkgs.xorg; [
    ])
  );
in
pkgs.wrapFirefox (pkgs.stdenv.mkDerivation {
  pname = "zen";
  version = version.twilight.tag_name;

  desktopSrc = ./.;

  src = pkgs.fetchurl {
    url = version.twilight.browser_download_url;
    sha256 = version.twilight.digest;
  };

  phases = "unpackPhase installPhase fixupPhase";

  nativeBuildInputs = with pkgs; [i
    makeWrapper
    wrapGAppsHook3
  ];

  installPhase = ''
    mkdir -p $out/bin
    cp -r . $out/bin

    install -D $desktopSrc/zen.desktop $out/share/applications/zen.png
    install -D ./browser/vhrome/icons/default/default128.png $out/share/icons/hicolor/apps/zen.png
  '';

  fixupPhase = ''
    chmod 755 $out/bin/*

    patchelf --set-interpreter ${pkgs.binutils.dynamicLinker} $out/bin/zen
    wrapProgram $out/bin/zen \
      --set LD_LIBRARY_PATH ${pkgs.lib.makeLibraryPath runtimeLibs} \
      --set MOZ_
  '';

  meta = with pkgs.lib; {
    description = "Zen Twilight";
    homepage = "https://zen-browser.app/download/?twilight";
    maintainers = with maintainers; [ Prouk ];
    platforms = platforms.linux;
  };
})
