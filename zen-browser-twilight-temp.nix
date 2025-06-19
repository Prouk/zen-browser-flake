{ pkgs, src, ... }:

pkgs.stdenv.mkDerivation {
  pname = "zen-browser-twilight-temp";
  version = "0.1";

  src = fetchTarball {
    url = src.url;
    sha256 = src.sha256;
  };

  installPhase = ''
    mkdir -p $out/bin
    ls -la
    chmod +x zen zen-bin
    cp -r * $out/bin
    ./$out/bin/zen
  '';

}
