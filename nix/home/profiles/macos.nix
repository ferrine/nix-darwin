{ lib, pkgs, config, ... }:
let
  cfg = config.stuff.profiles.macos;
in
{
  options.stuff.profiles.macos.enable = lib.mkEnableOption "MacOS Configuration";
  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      raycast
    ];
  };
}
