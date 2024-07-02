{ ... }: # universe
self: super:
let
  inherit (self.pkgs) pkgs lib stdenv darwin;
  buildTimeAppleSDK = darwin.apple_sdk;
  apple_libffi = stdenv.mkDerivation {
    name = "apple-libffi";
    dontUnpack = true;
    installPhase = ''
      mkdir -p $out/include $out/lib
      cp -r ${buildTimeAppleSDK.MacOSX-SDK}/usr/include/ffi $out/include/
      cp -r ${buildTimeAppleSDK.MacOSX-SDK}/usr/lib/libffi.* $out/lib/
    '';
  };
  commonPreBuildDarwinMinVersion = ''
    # Force it to target our ‘darwinMinVersion’, it’s not recognized correctly:
    grep -RF -- '-DPyObjC_BUILD_RELEASE=%02d%02d' | cut -d: -f1 | while IFS= read -r file ; do
      sed -r '/-DPyObjC_BUILD_RELEASE=%02d%02d/{s/%02d%02d/${
        lib.concatMapStrings (lib.fixedWidthString 2 "0") (
          lib.splitString "." buildTimeAppleSDK.stdenv.targetPlatform.darwinMinVersion
        )
      }/;n;d;}' -i "$file"
    done
    # impurities:
    ( grep -RF '/usr/bin/xcrun' || true ; ) | cut -d: -f1 | while IFS= read -r file ; do
      sed -r "s+/usr/bin/xcrun+$(${lib.getExe pkgs.which} xcrun)+g" -i "$file"
    done
    ( grep -RF '/usr/bin/python' || true ; ) | cut -d: -f1 | while IFS= read -r file ; do
      sed -r "s+/usr/bin/python+$(${lib.getExe pkgs.which} python)+g" -i "$file"
    done
  '';
in
{
  pyobjc-core = self.callPackage ./pyobjc-core {
    inherit apple_libffi commonPreBuildDarwinMinVersion;
    inherit (darwin) cctools;
    inherit (buildTimeAppleSDK) objc4 xcodebuild;
    inherit (buildTimeAppleSDK.libs) simd;
    inherit (buildTimeAppleSDK.frameworks) Foundation GameplayKit MetalPerformanceShaders;
  };
  pyobjc-framework-cocoa = self.callPackage ./pyobjc-framework-Cocoa {
    inherit (buildTimeAppleSDK.frameworks) Foundation AppKit;
    inherit (darwin) cctools;
    inherit (buildTimeAppleSDK) xcodebuild;
    inherit commonPreBuildDarwinMinVersion;
  };
  pyobjc-framework-core-bluetooth = self.callPackage ./pyobjc-framework-CoreBluetooth {
    inherit (buildTimeAppleSDK.frameworks) CoreBluetooth;
    inherit (darwin) cctools;
    inherit (buildTimeAppleSDK) xcodebuild;
    inherit commonPreBuildDarwinMinVersion;
  };
  pyobjc-framework-libdispatch = self.callPackage ./pyobjc-framework-libdispatch {
    inherit (buildTimeAppleSDK.frameworks) Foundation;
    inherit (darwin) cctools;
    inherit (buildTimeAppleSDK) xcodebuild;
    inherit commonPreBuildDarwinMinVersion;
  };
  bleak = super.bleak.overrideAttrs (attrs: {
    postPatch = lib.optional stdenv.isLinux attrs.postPatch;
    propagatedBuildInputs = (with super; [
      async-timeout
      typing-extensions
    ]) ++ (lib.optionals stdenv.isLinux (with super; [
      dbus-fast
    ])) ++ (lib.optionals stdenv.isDarwin (with self; [
      pyobjc-core
      pyobjc-framework-core-bluetooth
      pyobjc-framework-libdispatch
    ]));
    meta = attrs.meta // {
      platforms = with lib; platforms.linux ++ platforms.darwin;
    };
  });
  ledgerblue = super.ledgerblue.overrideAttrs (attrs: {
    propagatedBuildInputs = attrs.propagatedBuildInputs ++ [ self.bleak ];
  });
}
