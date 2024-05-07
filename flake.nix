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
  };
  outputs = inputs@{ self, home-manager, darwin, nixpkgs, ...}:
    let
      extraSpecialArgs = {
        inherit inputs;
        dot = path: "${./dotfiles}/${path}";
      };
      home-version = "24.05";
    in
    {
      # Build darwin flake using:
      # $ darwin-rebuild build --flake .#air
      darwinConfigurations.air = darwin.lib.darwinSystem {
        modules = [
          {
            nixpkgs = {
              hostPlatform = "aarch64-darwin";
            };
          }
          ./configuration.nix
          home-manager.darwinModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users.ferres = {...} : {
		home.stateVersion = home-version;
		imports = [
		  ./home
		  ./laptop.nix
		];
	      };
              inherit extraSpecialArgs;
            };
          }
        ];
        specialArgs = {
          # to set revision
          inherit self inputs;
        };

      };

      homeConfigurations.dev = home-manager.lib.homeManagerConfiguration {

        pkgs = nixpkgs.legacyPackages."x86_64-linux";

        # Specify your home configuration modules here, for example,
        # the path to your home.nix.
        modules = [
	  ./home
          ./dev.nix
	  rec {
	    home.stateVersion = home-version;
	    home.username = "ferres";
	    home.homeDirectory = "/home/${home.username}";
	  }
        ];

        # Optionally use extraSpecialArgs
        # to pass through arguments to home.nix
        inherit extraSpecialArgs;
      };
    };
}
