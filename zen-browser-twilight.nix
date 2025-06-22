{ pkgs, fetchzip, version, ... }:
pkgs.stdenv.mkDerivation {
  pname = "zen-browser";
  version = version.twilight.name;

  src = fetchzip {
    url = version.twilight.zipball_url;
    sha256 = version.twilight.zipball_sha;
    extension = "zip";
  };

  installPhase = ''
    mkdir -p $out/bin
    ls -la
    chmod +x zen zen-bin
    cp -r * $out/bin
    ./$out/bin/zen
  '';

}
