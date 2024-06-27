{ }: # import the sources
let
  readTree = import ./nix/kit/readTree {};
  fix = f: (let x = f x; in x);
in
  fix (self: readTree {
    path = ./.;
    args = {
      universe = self;
    };
  })
