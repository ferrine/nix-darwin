{pkgs, lib, config, ...} :
let
  cfg = config.stuff.lsp;
  in
{
  options = {
    stuff.lsp.enable = lib.mkEnableOption {};
  };
  config = lib.mkIf cfg.enable {
    home.packages =  with pkgs; [
      nixd
      elixir-ls
      python3Packages.python-lsp-server
      ccls
      csharp-ls
    ];
  };
}
