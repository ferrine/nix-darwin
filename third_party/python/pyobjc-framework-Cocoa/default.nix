{ lib
, buildPythonPackage
, fetchPypi
, setuptools
, wheel
, pyobjc-core
, Foundation
, AppKit
, cctools
, xcodebuild
, commonPreBuildDarwinMinVersion
}:

buildPythonPackage rec {
  pname = "pyobjc-framework-cocoa";
  version = "10.2";
  pyproject = true;

  src = fetchPypi {
    pname = "pyobjc-framework-Cocoa";
    inherit version;
    hash = "sha256-Y4MUE3ljaxOFXcobOcAydShiuCn5OknX3bNQRqv9wDU=";
  };

  buildInputs = [
    Foundation
    AppKit
  ];

  nativeBuildInputs = [
    setuptools
    wheel
    xcodebuild
    cctools
  ];

  propagatedBuildInputs = [
    pyobjc-core
  ];

  prePatch = ''
    mv PyObjCTest/test_nsgraphics.py PyObjCTest/disable_test_nsgraphics.py
    substituteInPlace PyObjCTest/test_nssavepanel.py \
      --replace test_issue282 disable_test_issue282
  '';

  preBuild = commonPreBuildDarwinMinVersion;

  hardeningDisable = [ "strictoverflow" ];

  pythonImportsCheck = [ "Cocoa" "CoreFoundation" "Foundation" "AppKit" "PyObjCTools" ];
  # setup.py is partially working and causes segfaults on attempt to load NSApplication
  meta = with lib; {
    description = "Wrappers for the Cocoa frameworks on macOS";
    homepage = "https://pypi.org/project/pyobjc-framework-Cocoa";
    license = licenses.mit;
    platforms = platforms.darwin;
  };
}
