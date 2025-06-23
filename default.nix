{ pkgs, ... }:
let
  version = builtins.fromJSON (builtins.readFile ./version.json);
in
rec {
  zen-beta-unwrapped = pkgs.callPackage ./zen-browser-beta.nix {
    inherit version;
  };
  zen-twilight-unwrapped = pkgs.callPackage ./zen-browser-twilight.nix {
    inherit version;
  };
  default = zen-twilight-unwrapped;
}
