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
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-parts.url = "github:hercules-ci/flake-parts";
  };
  outputs = inputs@{ self, flake-parts, home-manager, darwin, nixpkgs, ... }:
    let
      extraSpecialArgs = {
        inherit inputs;
      };
    in
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" "aarch64-darwin" ];
      imports = [
	./nix
      ];
      flake = {
	utils.dot = path: "${./dotfiles}/${path}";
        homeConfigurations.dev = home-manager.lib.homeManagerConfiguration {

          pkgs = nixpkgs.legacyPackages."x86_64-linux";

          # Specify your home configuration modules here, for example,
          # the path to your home.nix.
          modules = [
            self.homeModules.default
            ./dev.nix
            rec {
              home.stateVersion = "24.05";
              home.username = "ferres";
              home.homeDirectory = "/home/${home.username}";
            }
          ];

          # Optionally use extraSpecialArgs
          # to pass through arguments to home.nix
          inherit extraSpecialArgs;
        };
      };
    };
}
