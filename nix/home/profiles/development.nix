{ lib, config, pkgs, ... }:
let cfg = config.stuff.profiles.development;
in
{
  options.stuff.profiles.development.enable = lib.mkEnableOption "Development Profile";
  config = lib.mkIf cfg.enable {
    stuff.profiles.essentials.enable = lib.mkDefault true;
    programs.direnv.enable = true;
    home.shellAliases = {
      bug = "EDITOR=nvim git-bug";
    };
    programs.zsh.initExtra = ''
      # TODO: micromamba deserves its own module for configuration
      export MAMBA_ROOT_PREFIX=~/micromamba
      eval "$(${pkgs.micromamba}/bin/micromamba shell hook --shell zsh)"
    '';
    home.packages = (with pkgs; [
      pixi
      graphviz
      git-bug
      git-repo
      age
      ripgrep
      micromamba
      poetry
      nix-init
      nixpkgs-fmt
      black
      jsonfmt
      yamlfmt
      cmake-format
      nixd
      elixir-ls
      python3Packages.python-lsp-server
      ccls
      csharp-ls
      clang-tools
      cmake
      multimarkdown
    ]) ++ (lib.optionals pkgs.stdenv.isLinux (with pkgs; [ cntr ]));
  };
}
