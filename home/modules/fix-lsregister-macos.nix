{ pkgs, lib, config, ... }:
let cfg = config.stuff.fix-macbook-lsregister;
in
{
  options.stuff.fix-macbook-lsregister.enable = lib.mkOption {
    type = lib.types.bool;
    default = pkgs.stdenv.isDarwin;
    description = ''
      Fixes lsregister issue on macbook
    '';
  };
  config = lib.mkIf cfg.enable {
    home.activation.fixLsregister =
      let
        lsregister = "/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister";
        xargs = "${pkgs.findutils}/bin/xargs";
        find = "${pkgs.findutils}/bin/find";
        grep = "${pkgs.gnugrep}/bin/grep";
        awk = "${pkgs.gawk}/bin/awk";
        realpath = "${pkgs.coreutils}/bin/realpath";
      in
      lib.hm.dag.entryAfter [ "linkGeneration" ] ''
        # unregister all from the previous generation
        ${lsregister} -dump | ${grep} /nix/store | ${awk} '{ print $2 }' | ${xargs} ${lsregister} -f -u
        # refresh with new generation
        ${find} $(${realpath} $HOME/Applications/Home\ Manager\ Apps) -name '*.app' | ${xargs} ${lsregister} -f
      '';
  };
}
