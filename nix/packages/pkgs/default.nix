{ lib, newScope }:
lib.makeScope newScope (self:
{
  netron = self.callPackage ./netron { };
})
