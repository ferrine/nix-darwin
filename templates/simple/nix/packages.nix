{ ... } @flake:
{
  perSystem = { ... } @localFlake:
    {
      legacyPackages = { };
    };
}