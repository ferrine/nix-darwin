{ inputs, ... } @flake:
{
  perSystem = { system, ... } @localFlake: {
    _module.args.pkgs = import inputs.nixpkgs {
      inherit system;
      overlays = [ ];
      config = { };
    };
  };
}
