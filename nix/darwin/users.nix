{ self, pkgs, ... }:
let
  user = "ferres";
in
{
  users.users.${user} = {
    name = user;
    home = "/Users/${user}";
  };
  home-manager.users.${user} = {
    stuff.profiles.desktop.enable = true;
    home = {
      stateVersion = "24.05";
      packages = with self.legacyPackages.${pkgs.system}; [
        localPkgs.netron
      ];
      sessionVariables = {
        EDITOR="emacsclient -c -n -a ''";
      };
    };
  };
}
