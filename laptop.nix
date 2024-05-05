{ home-version }: { ... }:
{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  imports = [
    ./home/packages.nix
    ./home/emacs.nix
  ];
  programs.emacs.enable = true;
  home.stateVersion = home-version;
  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
}
