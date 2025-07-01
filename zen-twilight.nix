{
  version,
  pkgs ? import <nixpkgs> {}
}:
let
  libs = with pkgs; [
  ];
in
pkgs.stdenv.mkDerivation {
  pname = "zen";
  version = version.twilight.tag_name;

  src = pkgs.fetchurl {
    url = version.twilight.browser_download_url;
    sha256 = version.twilight.digest;
  };

  phases = [
    "unpackPhase"
    "installPhase"
    "fixupPhase"
  ];

  buildInputs = with pkgs; [
    makeWrapper
    patchelf
  ];

  installPhase = ''
    mkdir -p $out/bin
    cp -r ./ $out/bin

    isntall -D 
  '';

  meta = with pkgs.lib; {
    description = "Zen Twilight";
    homepage = "https://zen-browser.app/download/?twilight";
    maintainers = with maintainers; [ Prouk ];
    paltforms = platforms.linux;
  };
}
