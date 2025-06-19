{
  description = "zen-brwoser twilight flake that should have working hardware acceleration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs =
    { self, nixpkgs }@inputs:
    let
      system = "x86_64-linux";
      version = {
        "beta" = {
          url = "";
        };
        "beta-temp" = {
          url = "https://github.com/zen-browser-auto/www-temp/archive/refs/tags/1.13.2b.tar.gz";
          sha256 = "0hmb3zxjn961nd6c0ry5mbcr2iq38i1rvqs31qg99c7mcsv6zjal";
        };
        "twilight" = {
          url = "";
        };
        "twilight-temp" = {
          url = "https://github.com/zen-browser-auto/www-temp/releases/download/twilight/zen.linux-x86_64.tar.xz";
          sha256 = "";
        };
      };
      pkgs = import nixpkgs {
        inherit system;
      };
    in
    {
      packages.${system} = {
        zen-browser-beta-temp = pkgs.callPackage ./zen-browser-beta-temp.nix {src = version.beta-temp;};
        zen-browser-twilight-temp = pkgs.callPackage ./zen-browser-twilight-temp.nix {src = version.twilight-temp;};
      };
    
      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixfmt-tree;
    };
}
