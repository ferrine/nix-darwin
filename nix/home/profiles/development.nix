{ lib, config, pkgs, ... }:
let cfg = config.stuff.profiles.development;
in
{
  options.stuff.profiles.development.enable = lib.mkEnableOption "Development Profile";
  config = lib.mkIf cfg.enable {
    stuff.profiles.essentials.enable = lib.mkDefault true;
    programs.direnv.enable = true;
    home.packages = (with pkgs; [
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
    ]) ++ (lib.optionals pkgs.stdenv.isLinux (with pkgs; [ cntr ]));
  };
}
