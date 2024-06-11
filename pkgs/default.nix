{ pkgs }:
{
  upnext = pkgs.kodi-gbm.packages.callPackage ./upnext {};
  horus = pkgs.kodi-gbm.packages.callPackage ./horus {};
  plugin-cache = pkgs.kodi-gbm.packages.callPackage ./plugin-cache {};
  simplecache = pkgs.kodi-gbm.packages.callPackage ./simplecache {};
  raiplay = pkgs.kodi-gbm.packages.callPackage ./raiplay {};
  formula1 = pkgs.kodi-gbm.packages.callPackage ./formula1 {};
  skyvideoitalia = pkgs.kodi-gbm.packages.callPackage ./skyvideoitalia {};
  kdrive = pkgs.callPackage ./kdrive {};
}

# plugin.video.wltvhelper
# script.program.homeassistant