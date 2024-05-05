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
        languagetool
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
      linux = with pkgs; [
        cntr
      ];
    in
    lib.flatten [
      fonts
      formatters
      utilities
      programs
      (lib.optionals isLinux linux)
    ];

}
