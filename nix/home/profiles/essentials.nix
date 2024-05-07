{ lib, config, pkgs, ... }:
let
  inherit (pkgs.stdenv) isLinux;
  cfg = config.stuff.profiles.essentials;
in
{
  options.stuff.profiles.essentials.enable = lib.mkEnableOption "Essential Tools";
  config = lib.mkIf cfg.enable {
    home.packages = (with pkgs; [
      tmux
      git
      rsync
      cmake
      fzf
      silver-searcher
      clang-tools
    ]) ++ (lib.optionals isLinux (with pkgs; [ cntr ]));
  };
}
