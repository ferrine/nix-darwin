{ pkgs }: pkgs.emacsWithPackagesFromUsePackage {
  # Emacs config file.
  #
  # Supported formats:
  # + elisp source code - `*.el`
  # + org-mode babel files - `*.org`
  #
  # Note:
  # Config files cannot contain unicode characters, since they're being parsed in nix,
  # which lacks unicode support.
  #
  # org-mode babel files
  config = ./emacs.org;

  
  # Whether to include your config as a default init file.
  # If being bool, the value of config is used.
  # Its value can also be a derivation like this if you want to do some
  # substitution:
  #   defaultInitFile = pkgs.substituteAll {
  #     name = "default.el";
  #     src = ./emacs.el;
  #     inherit (config.xdg) configHome dataHome;
  #   };
  defaultInitFile = true;

  # Package is optional, defaults to pkgs.emacs-unstable
  package = pkgs.emacs-29;

  # By default emacsWithPackagesFromUsePackage will only pull in
  # packages with `:ensure`, `:ensure t` or `:ensure <package name>`.

  # For Org mode babel files, by default only code blocks with
  # `:tangle yes` are considered. Setting `alwaysTangle` to `true`
  # will include all code blocks missing the `:tangle` argument,
  # defaulting it to `yes`.
  # Note that this is NOT recommended unless you have something like
  # `#+PROPERTY: header-args:emacs-lisp :tangle yes` in your config,
  # which defaults `:tangle` to `yes`.
  alwaysTangle = true;

  # Optionally provide extra packages not in the configuration file.
  extraEmacsPackages = epkgs: with epkgs; [
    darcula-theme
  ];
}
