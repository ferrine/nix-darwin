{ universe, ... }:
let
  nixpkgs = universe.third_party.sources.nixpkgs;
in
import nixpkgs {
  config = {
    allowUnfree = true;
  };
}
