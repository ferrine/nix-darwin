{ lib
, buildPythonPackage
, fetchPypi
, setuptools
, wheel
, pyobjc-core
, pyobjc-framework-cocoa
, CoreBluetooth
, cctools
, xcodebuild
, commonPreBuildDarwinMinVersion
}:

buildPythonPackage rec {
  pname = "pyobjc-framework-core-bluetooth";
  version = "10.2";
  pyproject = true;

  src = fetchPypi {
    pname = "pyobjc-framework-CoreBluetooth";
    inherit version;
    hash = "sha256-+2nSxhCCk1srEoJ8G6S7IhRus9JRaV+h1Yu9WDUmByk=";
  };

  buildInputs = [
    CoreBluetooth
  ];

  nativeBuildInputs = [
    setuptools
    wheel
    xcodebuild
    cctools
  ];

  propagatedBuildInputs = [
    pyobjc-core
    pyobjc-framework-cocoa
  ];

  preBuild = commonPreBuildDarwinMinVersion;

  pythonImportsCheck = [ "CoreBluetooth" ];

  hardeningDisable = [ "strictoverflow" ];

  meta = with lib; {
    description = "Wrappers for the framework CoreBluetooth on macOS";
    homepage = "https://pypi.org/project/pyobjc-framework-CoreBluetooth";
    license = licenses.mit;
    platforms = platforms.darwin;
  };
}
