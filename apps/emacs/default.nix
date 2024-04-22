{ pkgs }:
let
  max-emacs = pkgs.emacs29-macport;
  emacsWithPackages = (pkgs.emacsPackagesFor max-emacs).emacsWithPackages;
in
emacsWithPackages (
  epkgs: (
    with epkgs; [
      magit # ; Integrate git <C-x g>
      darcula-theme # ; Nice theme
      treesit-grammars.with-all-grammars
  ]) ++ (
    # Smth else
    []
  )
)
