{ lib, pkgs, ... }:
{
  options.stuff.profiles.macos.enable = lib.mkEnableOption "MacOS Configuration";
  config = {
    nixpkgs.config.allowUnfree = true;
    home.packages = with pkgs; [
      raycast
    ];
  };
}
