{ lib
, stdenv
, async-timeout
, bluez
, buildPythonPackage
, dbus-fast
, fetchFromGitHub
, poetry-core
, pytest-asyncio
, pytestCheckHook
, pythonOlder
, typing-extensions
, pyobjc-core
, pyobjc-framework-core-bluetooth
, pyobjc-framework-libdispatch
}:

buildPythonPackage rec {
  pname = "bleak";
  version = "0.22.1";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "hbldh";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-kBKNBVbEq1xHLu/gKUL2SwlA2WKjzqFVC5o4N+qnqLM=";
  };

  postPatch = lib.optional stdenv.isLinux ''
    # bleak checks BlueZ's version with a call to `bluetoothctl --version`
    substituteInPlace bleak/backends/bluezdbus/version.py \
      --replace \"bluetoothctl\" \"${bluez}/bin/bluetoothctl\"
  '';

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    async-timeout
    typing-extensions
  ] ++ (lib.optionals stdenv.isLinux [
    dbus-fast
  ]) ++ (lib.optionals stdenv.isDarwin [
    pyobjc-core
    pyobjc-framework-core-bluetooth
    pyobjc-framework-libdispatch
  ]);

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "bleak"
  ];

  meta = {
    description = "Bluetooth Low Energy platform agnostic client";
    homepage = "https://github.com/hbldh/bleak";
    changelog = "https://github.com/hbldh/bleak/blob/v${version}/CHANGELOG.rst";
    license = lib.licenses.mit;
    platforms = with lib; platforms.linux ++ platforms.darwin;
    maintainers = with lib.maintainers; [ oxzi ];
  };
}
