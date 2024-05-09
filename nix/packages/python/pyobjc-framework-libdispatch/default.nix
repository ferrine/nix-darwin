{ lib
, buildPythonPackage
, fetchPypi
, setuptools
, wheel
, pyobjc-core
, pyobjc-framework-cocoa
, cctools
, xcodebuild
, Foundation
, commonPreBuildDarwinMinVersion
}:

buildPythonPackage rec {
  pname = "pyobjc-framework-libdispatch";
  version = "10.2";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-rhdgLvvmKPoEMrz0Nu6BN9IjmnBmn6761CDNUn461Wc=";
  };

  nativeBuildInputs = [
    setuptools
    wheel
    xcodebuild
    cctools
  ];

  buildInputs = [
    Foundation
  ];

  propagatedBuildInputs = [
    pyobjc-core
    pyobjc-framework-cocoa
  ];

  preBuild = commonPreBuildDarwinMinVersion;

  pythonImportsCheck = [ "dispatch" "libdispatch" ];

  meta = with lib; {
    description = "Wrappers for libdispatch on macOS";
    homepage = "https://pypi.org/project/pyobjc-framework-libdispatch";
    license = licenses.mit;
    platforms = platforms.darwin;
  };
}
