{ pkgs,  version, ... }:
pkgs.stdenv.mkDerivation {
  pname = "zen-browser";
  version = version.twilight.name;

  src = pkgs.fetchFromGitHub {
    owner = "zen-browser";
    repo = "desktop";
    rev = version.twilight.commit.sha;
    sha256 = version.twilight.zipball_sha;
  };

  installPhase = ''
    mkdir -p $out/bin
    ls -la
    chmod +x zen zen-bin
    cp -r * $out/bin
    ./$out/bin/zen
  '';

}
