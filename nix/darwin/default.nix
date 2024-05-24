{ self, inputs, ... }@flake:
{
  flake.darwinConfigurations = {
    air =
      inputs.darwin.lib.darwinSystem {
        specialArgs = { inherit self inputs; };
        modules = [
          inputs.home-manager.darwinModules.home-manager
          ./configuration.nix
          ./users.nix
          {
            nixpkgs.hostPlatform = "aarch64-darwin";
            home-manager = {
              sharedModules = [
                self.homeModules.default
              ];
              extraSpecialArgs = {
                inherit inputs;
                inherit (self.utils) dot;
              };
              useUserPackages = true;
            };
          }
        ];
      };
  };
}
