{ ... }:
{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  stuff.profiles.desktop.enable = true;
  home.sessionVariables = {
    EDITOR = "emacs";
  };
}
