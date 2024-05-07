{ ... }:
{
  programs.home-manager.enable = true;
  stuff = {
    utility.enable = true;
    fonts.enable = true;
    formatters.enable = true;
    lsp.enable = true;
    nixvim.enable = true;
    zsh.enable = true;
  };
}

