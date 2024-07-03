{ lib, config, ... }:
let cfg = config.stuff.zsh;
in
{
  options.stuff.zsh.enable = lib.mkEnableOption "Zsh configuration";
  config = lib.mkIf cfg.enable {
    programs.zsh = {
      enable = lib.mkDefault true;
      oh-my-zsh = {
        enable = lib.mkDefault true;
        theme = lib.mkDefault "nebirhos";
        plugins = [ "git" "sudo" ];
      };
    };
  };
}
