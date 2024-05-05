{home-version, user} : { config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  imports = [
    ./home/packages.nix
  ];
  home.username = user;
  home.homeDirectory = "/home/${user}";

  home.stateVersion = home-version; # Please read the comment before changing.
  programs.home-manager.enable = true;
}

