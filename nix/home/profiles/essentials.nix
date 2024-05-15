{ lib, config, pkgs, ... }:
let
  inherit (pkgs.stdenv) isLinux;
  cfg = config.stuff.profiles.essentials;
in
{
  options.stuff.profiles.essentials.enable = lib.mkEnableOption "Essential Tools";
  config = lib.mkIf cfg.enable {
    stuff.nixvim.enable = true;
    stuff.zsh.enable = true;
    stuff.git.enable = true;
    home.packages = (with pkgs; [
      findutils
      coreutils-full
      ripgrep
      gawk
      tmux
      rsync
      fzf
      silver-searcher
      htop
    ]);
  };
}
