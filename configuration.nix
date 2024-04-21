{ self, pkgs, inputs, ... }: {
  imports = [ ];
  nixpkgs = {
    hostPlatform = "aarch64-darwin";
    overlays = with inputs; [
      # 2. use `package` overlay provided by nix-community/emacs-overlay
      darwin-emacs.overlays.emacs
      darwin-emacs-packages.overlays.package
      # do not ocasionally reference old emacs
      (self: super: { emacs = super.emacs-29; })
    ];
  };
  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages =
    with pkgs; [
      (callPackage ./apps/emacs {})
    ];

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;
  # nix.package = pkgs.nix;

  # Necessary for using flakes on this system.
  nix.settings.experimental-features = "nix-command flakes";

  # Create /etc/zshrc that loads the nix-darwin environment.
  programs.zsh.enable = true; # default shell on catalina
  # programs.fish.enable = true;

  # Set Git commit hash for darwin-version.
  system.configurationRevision = self.rev or self.dirtyRev or null;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;

  # The platform the configuration will be used on.
  users.users.ferres = {
    name = "ferres";
    home = "/Users/ferres";
  };
}
