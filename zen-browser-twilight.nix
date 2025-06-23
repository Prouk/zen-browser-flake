{ pkgs, version, ... }:
pkgs.stdenv.mkDerivation {
  pname = "zen-browser";
  version = version.twilight.name;

  src = fetchTarball {
    url = version.twilight.tarball_url;
    sha256 = version.twilight.tarball_sha;
  };

  installPhase = ''
    mkdir -p $out/bin
    ls -la
    chmod +x zen zen-bin
    cp -r * $out/bin
    ./$out/bin/zen
  '';

}
