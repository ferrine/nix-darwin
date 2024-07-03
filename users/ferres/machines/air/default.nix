{ universe, ... }:
{ pkgs, ... }:
{
  nix = {
    package = pkgs.nixVersions.latest;
    settings.experimental-features = "nix-command flakes";
    nixPath = [
      "nixpkgs=${universe.third_party.sources.nixpkgs}"
      "darwin=${universe.third_party.sources.darwin}"
    ];
  };
  imports = [
    ./configuration.nix
  ];
}
