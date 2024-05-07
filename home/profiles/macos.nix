{ lib, ... }:
{
  options.stuff.profiles.macos.enable = lib.mkEnableOption "MacOS Configuration";
}
