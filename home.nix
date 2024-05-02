{ home-version }: { config, pkgs, lib, stdenv, ... }:
let
  inherit (stdenv) isDarwin;
in
{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  programs = {
    emacs = {
      enable = true;
      package = pkgs.emacs29-macport;
      extraConfig = ''
      (setq languagetool-java-arguments '("-Dfile.encoding=UTF-8"
                                          "-cp" "${pkgs.languagetool}/share/languagetool-server.jar:${pkgs.languagetool}/share/languagetool-commandline.jar")
            languagetool-java-bin "${pkgs.jdk17_headless}/bin/java"
            languagetool-console-command "org.languagetool.commandline.Main"
            languagetool-server-command "org.languagetool.server.HTTPServer")
    '';
      extraPackages = epkgs: (
        with epkgs; [
          magit # ; Integrate git <C-x g>
          treesit-grammars.with-all-grammars
        ]) ++ (
          # Smth else
          with epkgs.melpaPackages; [
            nix-ts-mode
            elixir-ts-mode
            telega
            projectile
            helm
            vterm
            languagetool
            s
            ag
          ]) ++ (with pkgs; [
            jdk17_headless
            languagetool
          ]);
    };
  };
  home.stateVersion = home-version;
  home.packages =
    let
      programs = with pkgs; [
      ];
      utilities = with pkgs; [
        fzf
        silver-searcher
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
      ];
      lsp = with pkgs; [
        languagetool
        nixd
        elixir-ls
        python3Packages.python-lsp-server
        ccls
        csharp-ls
      ];
    in
    fonts ++ formatters ++ lsp ++ utilities ++ programs;
  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    ".emacs.d" = {
      source = ./dotfiles/.emacs.d;
      recursive = true;
    };
  };
}
