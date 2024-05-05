{pkgs, config, lib, dot, ...} :
let
  inherit (pkgs.stdenv) isDarwin;
  in
  {
    config = lib.mkIf config.programs.emacs.enable {
      programs = {
        emacs = {
          package = if isDarwin then pkgs.emacs29-macport else pkgs.emacs29;
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
      home.packages = with pkgs; [ibm-plex];
      home.file = {
        ".emacs.d" = {
          source = (dot ".emacs.d");
          recursive = true;
        };
      };
    };
}
