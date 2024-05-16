{ ... } @flake:
{
  perSystem = { pkgs, ... }: {
    legacyPackages = pkgs.callPackage ./default.nix { };
  };
}
