{
  description = "zen-brwoser twilight flake that should have working hardware acceleration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs =
    { self, nixpkgs }@inputs:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
      };
    in
    {
      packages.${system} = {
        zen-browser-beta= pkgs.callPackage ./zen-browser-beta-temp.nix {};
        zen-browser-twilight = pkgs.callPackage ./zen-browser-twilight-temp.nix {};
      };
    
      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixfmt-tree;
    };
}
