{ ... }:
{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  imports = [
    ./home
  ];
  stuff = {
    utility.enable = true;
    fonts.enable = true;
    formatters.enable = true;
    lsp.enable = true;
    nixvim.enable = true;
    emacs.enable = true;
    zsh.enable = true;
  };
  home.sessionVariables = {
    EDITOR = "emacs";
  };
}
