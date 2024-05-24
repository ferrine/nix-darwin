{ lib, config, pkgs, ... }:
let
  cfg = config.stuff.profiles.essentials;
in
{
  options.stuff.profiles.essentials.enable = lib.mkEnableOption "Essential Tools";
  config = lib.mkIf cfg.enable {
    stuff.nixvim.enable = true;
    stuff.zsh.enable = true;
    stuff.git.enable = true;
    programs.atuin.enable = true;
    home.packages = (with pkgs; [
      tree
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
