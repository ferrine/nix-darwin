{ universe, nixpkgsConfig, localSystem, crossSystem, ... }:
let
  nixpkgsSrc = universe.third_party.sources.nixpkgs;
  pythonOverlay = self: super: {
    python3Packages =
      super.python3Packages.overrideScope
        universe.third_party.overlays.python;
  };
in
import nixpkgsSrc {
  config = {
    allowUnfree = true;
    # e.g. JAX marked broken
    allowBroken = true;
  } // nixpkgsConfig;
  inherit localSystem crossSystem;
  overlays = [
    pythonOverlay
  ];
}
