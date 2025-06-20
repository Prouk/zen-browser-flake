{
  description = "zen-brwoser twilight flake that should have working hardware acceleration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs =
    { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
      };
      version = builtins.fromJSON ./version.json;
    in
    {
      packages.${system} = {
        zen-browser-beta= pkgs.callPackage ./zen-browser-beta.nix {version = version;};
        zen-browser-twilight = pkgs.callPackage ./zen-browser-twilight.nix {version = version;};
      };
    
      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixfmt-tree;
    };
}
