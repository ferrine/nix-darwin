{ pkgs, lib, config, ... }:
let
  # inherit (pkgs.stdenv) isDarwin;
  inherit (pkgs.stdenv) isLinux;
  cfg = config.stuff;
  in
  {
    options = {
      stuff = {
        utility.enable = lib.mkEnableOption {default = true;};
        fonts.enable = lib.mkEnableOption {default = true;};
        formatters.enable = lib.mkEnableOption {default = true;};
        lsp.enable = lib.mkEnableOption {default = true;};
      };
    };
    config = {
      home.packages =
        let
          utility = (with pkgs; [
            zsh
            git
            rsync
            cmake
            fzf
            silver-searcher
            clang-tools
          ]) ++ (lib.optionals isLinux (with pkgs;[cntr]));
          fonts = with pkgs; [
            inconsolata
            ibm-plex
          ];
          formatters = with pkgs; [
            nixpkgs-fmt
            black
            jsonfmt
            yamlfmt
            cmake-format
          ];
          lsp = with pkgs; [
            nixd
            elixir-ls
            python3Packages.python-lsp-server
            ccls
            csharp-ls
          ];
          in
          lib.flatten [
            (lib.optionals cfg.lsp.enable lsp)
            (lib.optionals cfg.fonts.enable fonts)
            (lib.optionals cfg.formatters.enable formatters)
            (lib.optionals cfg.utility.enable utility)
          ];
    };
  }
