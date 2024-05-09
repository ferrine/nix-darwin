{ pkgs, lib, newScope, buildTimeSDK, python3Packages }:
let
  apple_libffi = pkgs.stdenv.mkDerivation {
    name = "apple-libffi";
    dontUnpack = true;
    installPhase = ''
      mkdir -p $out/include $out/lib
      cp -r ${buildTimeSDK.MacOSX-SDK}/usr/include/ffi $out/include/
      cp -r ${buildTimeSDK.MacOSX-SDK}/usr/lib/libffi.* $out/lib/
    '';
  };
  commonPreBuildDarwinMinVersion = ''
    # Force it to target our ‘darwinMinVersion’, it’s not recognized correctly:
    grep -RF -- '-DPyObjC_BUILD_RELEASE=%02d%02d' | cut -d: -f1 | while IFS= read -r file ; do
      sed -r '/-DPyObjC_BUILD_RELEASE=%02d%02d/{s/%02d%02d/${
        lib.concatMapStrings (lib.fixedWidthString 2 "0") (
          lib.splitString "." buildTimeSDK.stdenv.targetPlatform.darwinMinVersion
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
lib.makeScope python3Packages.newScope (self:
{
  pyobjc-core = self.callPackage ./pyobjc-core {
    inherit apple_libffi commonPreBuildDarwinMinVersion;
    inherit (pkgs.darwin) cctools;
    inherit (buildTimeSDK) objc4 xcodebuild;
    inherit (buildTimeSDK.libs) simd;
    inherit (buildTimeSDK.frameworks) Foundation GameplayKit MetalPerformanceShaders;
  };
})