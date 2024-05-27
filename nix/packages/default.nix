{ pkgs, lib, ... }:
lib.makeScope pkgs.newScope (
  self:
  {
    localPython3Packages = self.callPackage ./python {
      buildTimeAppleSDK = pkgs.darwin.apple_sdk;
    };
    localPkgs = self.callPackage ./pkgs {};
  }
)
