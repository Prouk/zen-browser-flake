{ pkgs, ... }:
let
  version = builtins.fromJSON(builtins.readFile ./version.json);
in
rec  {
  beta = pkgs.callPackage ./zen-beta.nix {
    inherit version;
  };
  twilight = pkgs.callPackage ./zen-twilight.nix {
    inherit version;
  };
  default = beta;
}
