{ lib, config, pkgs, ... }:
let
  inherit (lib) mkOption mkEnableOption types;
  cfg = config.stuff.home-update;
in
{
  options.stuff.home-update = {
    enable = mkEnableOption "Add home-update script to fetch flake from github";
    url = mkOption {
      type = types.str;
      default = "github:ferrine/nix-darwin";
      description = ''
        flake url
      '';
    };
    attr = mkOption {
      type = types.str;
      description = ''
        flake attr
      '';
    };
  };
  config.home.packages =
    let
      attr = cfg.attr;
      url = cfg.url;
      home-update = pkgs.writeShellScriptBin "home-update" ''
        home-manager switch --refresh --flake ${url}#${attr}
      '';
    in
    lib.mkIf cfg.enable [ home-update ];
}
