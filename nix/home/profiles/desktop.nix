{ pkgs, lib, config, ... }:
let
  inherit (pkgs.stdenv) isDarwin;
  cfg = config.stuff.profiles.desktop;
in
{
  options.stuff.profiles.desktop.enable = lib.mkEnableOption "Desktop Profile";
  config = lib.mkIf cfg.enable {
    stuff.emacs.enable = lib.mkDefault true;
    stuff.profiles = {
      development.enable = lib.mkDefault true;
      macos.enable = lib.mkDefault isDarwin;
      fonts.enable = lib.mkDefault true;
    };
    home.packages = with pkgs; [
      gephi
    ];
  };
}
