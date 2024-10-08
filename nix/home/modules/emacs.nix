{ pkgs, config, lib, dot, inputs, ... }:
let
  cfg = config.stuff.emacs;
in
{
  options.stuff.emacs = {
    enable = lib.mkEnableOption "Emacs configuration";
  };
  config = lib.mkIf cfg.enable {
    programs = {
      emacs = {
        enable = lib.mkDefault true;
        package = pkgs.emacs29;
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
          ]
        ) ++ (
          # Smth else
          with epkgs.melpaPackages; [
            languagetool
          ]
        );
      };
    };
    home.file = {
      ".emacs.d" = {
        source = (dot ".emacs.d");
        recursive = true;
      };
    };
  };
}
