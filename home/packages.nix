{ pkgs, lib, ... }:
let
  # inherit (pkgs.stdenv) isDarwin;
  inherit (pkgs.stdenv) isLinux;
in
{
  home.packages =
    let
      programs = with pkgs; [
        zsh
        git
        rsync
        cmake
        fzf
        silver-searcher
      ];
      utilities = with pkgs; [
        fzf
        silver-searcher
        clang-tools
      ];
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
        languagetool
        nixd
        elixir-ls
        python3Packages.python-lsp-server
        ccls
        csharp-ls
      ];
      linux = with pkgs; [
        cntr
        python3Packages.gpustat
      ];
    in
    lib.flatten [
      fonts
      formatters
      lsp
      utilities
      programs
      (lib.optionals isLinux linux)
    ];

}
