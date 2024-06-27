{ universe, nixpkgsConfig, localSystem, crossSystem, ... }:
let
  nixpkgsSrc = universe.third_party.sources.nixpkgs;
in
import nixpkgsSrc {
  config = {
    allowUnfree = true;
  } // nixpkgsConfig;
  inherit localSystem crossSystem;
}
