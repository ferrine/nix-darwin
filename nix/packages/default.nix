{ ... } @flake:
{
  perSystem = { pkgs, lib, ... }:
    {
      legacyPackages = lib.makeScope pkgs.newScope (
        self:
        {
          localPython3Packages = self.callPackage ./python {
	    buildTimeAppleSDK = pkgs.darwin.apple_sdk;
	  };
        }
      );
    };
}
