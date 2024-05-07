{ lib, config, pkgs, ...}:
let
  cfg = config.stuff.profiles.fonts;
  in
  {
    options.stuff.profiles.fonts.enable = lib.mkEnableOption "Fonts configuration";
    config = lib.mkIf cfg.enable {
      home.packages = with pkgs; [
	ibm-plex
	inconsolata
      ];
    };
  }
