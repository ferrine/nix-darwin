{ home-version }: { config, pkgs, lib, ... }:
{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.

  # The home.packages option allows you to install Nix packages into your
  # environment.

  home.stateVersion = home-version;
  home.packages =
    let
      fonts = with pkgs; [
        inconsolata
        ibm-plex
      ];
      develop = with pkgs; [
      ];
    in
    fonts ++ develop;
  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    ".emacs.d/init.el".source = ./dotfiles/.emacs.d/init.el;
  };
}
