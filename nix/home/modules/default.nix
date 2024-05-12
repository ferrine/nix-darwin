{ ... }: {
  imports = [
    ./emacs.nix
    ./nvim.nix
    ./zsh.nix
    ./home-update.nix
    ./git
  ];
}
