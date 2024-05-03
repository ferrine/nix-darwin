{ self, pkgs, inputs, ... }: {
  imports = [ ];
  nixpkgs = {
    hostPlatform = "aarch64-darwin";
    overlays = with inputs; [
      emacs-packages.overlays.package
    ];
  };
  # https://mynixos.com/nix-darwin/options
  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  system = {
    keyboard = {
      # to not become pinky
      enableKeyMapping = true;
      remapCapsLockToControl = true;
    };
    defaults = {
      dock = {
        launchanim = false;
      };
    };
  };
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
  
  system.activationScripts.extraUserActivation.text = ''
    # disable Command Meta D Dict lookup
    defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 70 '<dict><key>enabled</key><false/></dict>'
  '';
}
