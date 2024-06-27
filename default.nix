{ localSystem ? builtins.currentSystem
, crossSystem ? null
, nixpkgsConfig ? { }
}: # import the sources
let
  readTree = import ./nix/kit/readTree { };
  fix = f: (let x = f x; in x);
in
fix (self: readTree {
  path = ./.;
  args = {
    inherit localSystem crossSystem nixpkgsConfig;
    universe = self;
    pkgs = self.third_party.nixpkgs;
    lib = self.third_party.nixpkgs.lib;
  };
})
