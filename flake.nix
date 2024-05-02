{
  description = "Example Darwin system flake";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    darwin = {
      url = "github:lnl7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    emacs-packages = {
      url = "github:nix-community/emacs-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = inputs@{ self, home-manager, darwin, emacs-packages, nixpkgs }:
    let
      home-version = "24.05";
    in
    {
      # Build darwin flake using:
      # $ darwin-rebuild build --flake .#air
      darwinConfigurations.air = darwin.lib.darwinSystem {
        modules = [
          ./configuration.nix
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.ferres = import ./home.nix {inherit home-version;};
          }
        ];
        specialArgs = { inherit inputs self; };
      };

      # Expose the package set, including overlays, for convenience.
      darwinPackages = self.darwinConfigurations.air.pkgs;
      homeConfigurations.dev = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages."x86_64-linux";

        # Specify your home configuration modules here, for example,
        # the path to your home.nix.
        modules = [ (import ./dev.nix {inherit home-version; user = "ferres";})];

        # Optionally use extraSpecialArgs
        # to pass through arguments to home.nix
      };
    };
}
