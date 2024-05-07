{ lib, ...}:
{
  imports = [
    ./packages.nix
    ./emacs.nix
    ./nvim.nix
    ./zsh.nix
  ];
  home.sessionVariables = {
    LC_ALL = lib.mkDefault "en_US.UTF-8";
    LANG = lib.mkDefault "en_US.UTF-8";
  };

}
