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
    home.stateVersion = "24.05";
    home.packages = [
      self.legacyPackages.${pkgs.system}.localPython3Packages.ledger-agent
    ];
    imports = [
      {
        stuff.profiles.desktop.enable = true;
        home.sessionVariables = {
          EDITOR = "emacs";
        };
      }
    ];
  };
}
