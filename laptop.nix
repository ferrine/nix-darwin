{ home-version }: { inputs, ... }:
{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  imports = [
    inputs.nixvim.homeManagerModules.nixvim
    ./home/packages.nix
    ./home/emacs.nix
    ./home/nvim.nix
  ];
  programs.emacs.enable = true;
  programs.nixvim.enable = true;
  stuff = {
    utility.enable = true;
    fonts.enable = true;
    formatters.enable = true;
    lsp.enable = true;
  };
  home.stateVersion = home-version;
  home.sessionVariables = {
    LC_ALL = "en_US.UTF-8";
    LANG = "en_US.UTF-8";
  };
  programs.zsh = {
    enable = true;
    oh-my-zsh = {
      enable = true;
      theme = "nebirhos";
      plugins = [ "git" "sudo" ];
    };
  };
}
