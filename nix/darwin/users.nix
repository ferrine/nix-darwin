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
    home.activation.fix-lsregister =
      let
        lsregister = "/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister";
      in
      ''
        # unregister all from the previous generation
        ${lsregister} -dump | /usr/bin/grep /nix/store | /usr/bin/awk '{ print $2 }' | /usr/bin/xargs ${lsregister} -f -u
        # refresh with new generation
        /usr/bin/find $(realpath $HOME/Applications/Home\ Manager\ Apps) -name '*.app' | /usr/bin/xargs ${lsregister} -f
      '';
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
