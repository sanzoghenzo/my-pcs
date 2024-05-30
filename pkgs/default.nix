{ pkgs }:
{
  upnext = pkgs.kodi-gbm.packages.callPackage ./upnext {};
  horus = pkgs.kodi-gbm.packages.callPackage ./horus {};
}
