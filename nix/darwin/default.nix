{ self, inputs, ... }@flake:
{
  flake.darwinConfigurations = {
    air =
      let
        user = "ferres";
      in
      inputs.darwin.lib.darwinSystem {
        specialArgs = { inherit self inputs; };
        modules = [
          inputs.home-manager.darwinModules.home-manager
          ./configuration.nix
          {
            nixpkgs.hostPlatform = "aarch64-darwin";
            users.users.${user} = {
              name = user;
              home = "/Users/${user}";
            };
            home-manager = {
              extraSpecialArgs = {
                inherit inputs;
                inherit (self.utils) dot;
              };
              useGlobalPkgs = true;
              useUserPackages = true;
              users.${user} = { ... }: {
                home.stateVersion = "24.05";
                imports = [
                  self.homeModules.default
                  {
                    stuff.profiles.desktop.enable = true;
                    home.sessionVariables = {
                      EDITOR = "emacs";
                    };
                  }
                ];
              };
            };
          }
        ];
      };
  };
}
