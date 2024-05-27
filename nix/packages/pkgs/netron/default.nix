{ lib
, fetchurl
, stdenv
, nix-update-script
, unzip
}:

stdenv.mkDerivation rec {
  pname = "netron";
  version = "7.6.9";

  src = fetchurl {
    url = "https://github.com/lutzroeder/netron/releases/download/v${version}/Netron-${version}-mac.zip";
    hash = "sha256-zx0vMyYVc1t1I9s9pswaEUo7d6pX8t+c7PF6vRrmTU8=";
  };
  nativeBuildInputs = [ unzip ];
  sourceRoot = "Netron.app";

  installPhase = ''
    mkdir -p "$out/Applications/Netron.app"
    cp -R . "$out/Applications/Netron.app"
  '';

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    homepage = "https://netron.app/";
    description = "Visualizer for neural network, deep learning and machine learning models";
    platforms = platforms.darwin;
    license = licenses.mit;
    maintainers = with maintainers; [ ferrine ];
  };
}
