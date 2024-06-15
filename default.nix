{ sources ? import ./nix/sources.nix }: # import the sources
let
  pkgs = import sources.nixpkgs {
    config = { allowUnfree = true; };
  };
  inherit (pkgs) lib;
in
lib.makeScope pkgs.newScope (self: {
  inherit pkgs lib sources;
  third-party = lib.packagesFromDirectoryRecursive {
    inherit (self) callPackage;
    directory = ./third_party;
  };
  repo = lib.packagesFromDirectoryRecursive {
    inherit (self) callPackage;
    directory = ./src;
  };
})
