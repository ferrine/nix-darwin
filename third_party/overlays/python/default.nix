{ ... }: # universe
self: super:
let
  inherit (super) lib stdenv;
  buildTimeAppleSDK = super.darwin.apple_sdk;
  apple_libffi = super.stdenv.mkDerivation {
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
      sed -r "s+/usr/bin/xcrun+$(${lib.getExe super.which} xcrun)+g" -i "$file"
    done
    ( grep -RF '/usr/bin/python' || true ; ) | cut -d: -f1 | while IFS= read -r file ; do
      sed -r "s+/usr/bin/python+$(${lib.getExe super.which} python)+g" -i "$file"
    done
  '';
  inherit (super) python3Packages;
in
{
  python3Packages = python3Packages.overrideScope (py-self: py-super: {
    pyobjc-core = py-self.callPackage ./pyobjc-core {
      inherit apple_libffi commonPreBuildDarwinMinVersion;
      inherit (super.darwin) cctools;
      inherit (buildTimeAppleSDK) objc4 xcodebuild;
      inherit (buildTimeAppleSDK.libs) simd;
      inherit (buildTimeAppleSDK.frameworks) Foundation GameplayKit MetalPerformanceShaders;
    };
    pyobjc-framework-cocoa = py-self.callPackage ./pyobjc-framework-Cocoa {
      inherit (buildTimeAppleSDK.frameworks) Foundation AppKit;
      inherit (super.darwin) cctools;
      inherit (buildTimeAppleSDK) xcodebuild;
      inherit commonPreBuildDarwinMinVersion;
    };
    pyobjc-framework-core-bluetooth = py-self.callPackage ./pyobjc-framework-CoreBluetooth {
      inherit (buildTimeAppleSDK.frameworks) CoreBluetooth;
      inherit (super.darwin) cctools;
      inherit (buildTimeAppleSDK) xcodebuild;
      inherit commonPreBuildDarwinMinVersion;
    };
    pyobjc-framework-libdispatch = py-self.callPackage ./pyobjc-framework-libdispatch {
      inherit (buildTimeAppleSDK.frameworks) Foundation;
      inherit (super.darwin) cctools;
      inherit (buildTimeAppleSDK) xcodebuild;
      inherit commonPreBuildDarwinMinVersion;
    };
    bleak = py-super.bleak.overrideAttrs (attrs: {
      postPatch = lib.optional stdenv.isLinux attrs.postPatch;
      propagatedBuildInputs = (with py-super; [
        async-timeout
        typing-extensions
      ]) ++ (lib.optionals stdenv.isLinux (with py-super; [
        dbus-fast
      ])) ++ (lib.optionals stdenv.isDarwin (with py-self; [
        pyobjc-core
        pyobjc-framework-core-bluetooth
        pyobjc-framework-libdispatch
      ]));
      meta = attrs.meta // {
        platforms = with lib; platforms.linux ++ platforms.darwin;
      };
    });
    ledgerblue = py-super.ledgerblue.overrideAttrs (attrs: {
      propagatedBuildInputs = attrs.propagatedBuildInputs ++ [ py-self.bleak ];
    });
  });
}
