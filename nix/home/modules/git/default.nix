{ config, lib, ... }:
let
  cfg = config.stuff.git;
in
{
  options.stuff.git.enable = lib.mkEnableOption "Enable git with personal defaults";
  config = lib.mkIf cfg.enable {
    programs.git = {
      lfs.enable = lib.mkDefault true;
      enable = lib.mkDefault true;
      userEmail = lib.mkDefault "justferres@yandex.ru";
      userName = lib.mkDefault "ferres";
      ignores = [
	"*~"
	"\\#*\\#"
	"*.swp"
	".\\#*"
      ];
      extraConfig = {
        merge.conflictStyle = "diff3";
      };
    };
  };
}
