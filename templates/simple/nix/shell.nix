{ ... } @flake:
{
  perSystem = { pkgs, ... } @localFlake:
    let
      # inherit (self'.legacyPackages);
    in
    {
      devShells.default = pkgs.mkShell rec {
        name = "default shell";
        packages = with pkgs; [ nixpgks-fmt ];
      };
    };
}
