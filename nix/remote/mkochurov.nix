{ self, inputs, ... } @flake:
{
  flake.homeConfigurations."mkochurov" = inputs.home-manager.lib.homeManagerConfiguration {
    pkgs = inputs.nixpkgs.legacyPackages."x86_64-linux";
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
          attr = "mkochurov";
        };
        programs.home-manager.enable = true;
        home.stateVersion = "24.05";
        home.username = "mkochurov";
        home.homeDirectory = "/home/${home.username}";
      }
    ];
  };
}
