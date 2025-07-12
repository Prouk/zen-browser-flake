{ pkgs, ... }:
let
  version = builtins.fromJSON(builtins.readFile ./version.json);
in
rec  {
  beta-unwrapped = pkgs.callPackage ./zen-beta-unwrapped.nix {
    infos = version.beta;
  };
  twilight-unwrapped = pkgs.callPackage ./zen-twilight-unwrapped.nix {
    infos = version.twilight;
  };

  beta = pkgs.wrapFirefox beta-unwrapped {};
  twilight = pkgs.wrapFirefox twilight-unwrapped {};
  
  default = beta;
}
