{ pkgs, version, fetchurl, ... }:

pkgs.stdenv.mkDerivation {
  pname = "zen-browser";
  applicationName = version.name;
  version = "0.1";

  src = fetchurl {
    url = src.url;
    sha256 = src.sha256;
  };

  installPhase = ''
    mkdir -p $out/bin
    ls -la
    chmod +x zen zen-bin
    cp -r * $out/bin
    ls -la $out/bin
    # $out/bin/zen-bin
  '';
}
