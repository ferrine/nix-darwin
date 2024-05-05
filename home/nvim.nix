{lib, config, ... }: {
  config = lib.mkIf config.programs.nixvim.enable {
    home.sessionVariables = {
      EDITOR = "nvim";
    };
  };
}
