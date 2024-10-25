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
      initExtraFirst = ''
        vterm_printf() {
          if [ -n "$TMUX" ] && ([ "''${TERM%%-*}" = "tmux" ] || [ "''${TERM%%-*}" = "screen" ]); then
              # Tell tmux to pass the escape sequences through
              printf "\ePtmux;\e\e]%s\007\e\\" "$1"
          elif [ "''${TERM%%-*}" = "screen" ]; then
              # GNU screen (screen, screen-256color, screen-256color-bce)
              printf "\eP\e]%s\007\e\\" "$1"
          else
              printf "\e]%s\e\\" "$1"
          fi
        }
        if [[ $TERM = dumb ]]; then
          unsetopt zle
          PS1='$ '
          return 0
        fi
      '';
    };
  };
}
