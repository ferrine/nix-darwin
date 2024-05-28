{ sources ? import ./nix/sources.nix }: # import the sources
let
  pkgs = import sources.nixpkgs {
    overlays = [
      (import ./nix/packages/overlay.nix)
    ];
    config = { allowUnfree = true; };
  };
  darwin = import sources.darwin {
    inherit (sources) nixpkgs;
    inherit pkgs;
  };
in
{
  inherit pkgs darwin;
}
