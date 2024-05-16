{ ... } @flake:
{
  perSystem = { pkgs, config, ... } @localFlake:
    {
      devShells.default = pkgs.mkShell {
	inputsFrom = [ config.flake-root.devShell ];
        name = "default shell";
        packages = with pkgs; [ nixpkgs-fmt ];
      };
    };
}
