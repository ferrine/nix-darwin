{ inputs, self, ... }:
let
  mkHome = { username, tag, system ? "x86_64-linux", modules ? [ ] }:
    inputs.home-manager.lib.homeManagerConfiguration {
      pkgs = inputs.nixpkgs.legacyPackages.${system};
      extraSpecialArgs = {
        inherit inputs; inherit (self.utils) dot;
      };
      # Specify your home configuration modules here, for example,
      # the path to your home.nix.
      modules = [
        self.homeModules.default
        rec {
          stuff.profiles.development.enable = true;
          stuff.home-update = {
            enable = true;
            attr = tag;
          };
          programs.home-manager.enable = true;
          home.stateVersion = "24.05";
          home.username = username;
          home.homeDirectory = "/home/${home.username}";
        }
      ] ++ modules;
    };
in
{
  flake.homeConfigurations = {
    c1-s1 = mkHome { username = "ferres"; tag = "c1-s1"; };
    mkochurov = mkHome { username = "mkochurov"; tag = "mkochurov"; };
  };
}
