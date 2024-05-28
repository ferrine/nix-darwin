{ ... } @flake:
{
  flake.homeModules.default = { lib, ... }:
    {
      imports = [
        ./profiles
        ./modules
      ];
      home.sessionVariables = {
        LC_ALL = lib.mkDefault "en_US.UTF-8";
        LANG = lib.mkDefault "en_US.UTF-8";
      };
    };
}

