{ self, pkgs, ... }:
let
  user = "ferres";
in
{
  users.users.${user} = {
    name = user;
    home = "/Users/${user}";
  };
  home-manager.users.${user} = { lib, ... }: {
    home.stateVersion = "24.05";
    home.packages = [
      self.legacyPackages.${pkgs.system}.localPython3Packages.ledger-agent
    ];
    home.activation.fix-lsregister =
      let
        lsregister = "/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister";
        xargs = "${pkgs.findutils}/bin/xargs";
        find = "${pkgs.findutils}/bin/find";
        grep = "${pkgs.gnugrep}/bin/grep";
        awk = "${pkgs.gawk}/bin/awk";
        realpath = "${pkgs.coreutils}/bin/realpath";
      in
      lib.hm.dag.entryAfter [ "linkGeneration" ] ''
        # unregister all from the previous generation
        ${lsregister} -dump | ${grep} /nix/store | ${awk} '{ print $2 }' | ${xargs} ${lsregister} -f -u
        # refresh with new generation
        ${find} $(${realpath} $HOME/Applications/Home\ Manager\ Apps) -name '*.app' | ${xargs} ${lsregister} -f
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
