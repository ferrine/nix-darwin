{lib, config, inputs, ... }:
let
  cfg = config.stuff.nixvim;
  in
  {
    imports = [
      inputs.nixvim.homeManagerModules.nixvim
    ];
    options = {
      stuff.nixvim.enable = lib.mkEnableOption "nixvim configuration";
    };
    config = lib.mkIf cfg.enable {
      programs.nixvim = {
	enable = lib.mkDefault true;
      };
      home.sessionVariables = {
	EDITOR = lib.mkDefault "nvim";
      };
    };
  }
