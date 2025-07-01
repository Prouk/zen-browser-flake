{
  pkgs ? import <nixpkgs> { },
  version, libGL,
}:

let
  zenPkg = pkgs.stdenv.mkDerivation {
    pname = "zen-browser";
    version = version.twilight.tag_name;

    src = pkgs.fetchurl {
      url = version.twilight.browser_download_url;
      sha256 = version.twilight.digest;
    };

    installPhase = ''
      mkdir -p $out
      # Copy all extracted content into $out/zen
      cp -r . $out
    '';
  };
in

pkgs.buildFHSEnvBubblewrap {
  name = "zen-twilight-fhs";
  targetPkgs =
    pkgs:
    (with pkgs; [
      gtk3
      glib
      gdk-pixbuf
      pango
      atk
      alsa-lib
      pciutils
      libGL
      cairo
      # Xorg dependencies
      xorg.libXcursor
      xorg.libXrandr
      xorg.libX11
      xorg.libXi
      xorg.libXdamage
      xorg.libXfixes
      xorg.libxcb
      xorg.libXext
      xorg.libXcomposite
    ]);
  profile = "export LD_LIBRARY_PATH=/run/opengl-driver/lib\n";

  # Find the right path to the Zen binary inside the extracted directory.
  # If the tarball contains a subdirectory, adjust the path accordingly.
  # For example, if it unpacks to zen-x.y.z/zen, use $zenPkg/zen-x.y.z/zen
  runScript = "${zenPkg}/zen";
}
