{ universe, nixpkgsConfig, localSystem, crossSystem, ... }:
let
  nixpkgsSrc = universe.third_party.sources.nixpkgs;
in
import nixpkgsSrc {
  config = {
    allowUnfree = true;
    # e.g. JAX marked broken
    allowBroken = true;
  } // nixpkgsConfig;
  inherit localSystem crossSystem;
  overlays = [
    universe.third_party.overlays.python
  ];
}
