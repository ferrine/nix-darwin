self: super:
let
  pkgsOverlay = import ./pkgs/overlay.nix;
  pythonOverlay =
    let
      pythonPackagesOverlay = import ./python/overlay.nix;
    in
    self: super: {
      python3Packages = super.python3Packages.overrideScope pythonPackagesOverlay;
    };
in
(super.lib.composeManyExtensions [
  pkgsOverlay
  pythonOverlay
] self super )
