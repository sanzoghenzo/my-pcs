{ pkgs }:
{
  horus = pkgs.kodi-gbm.packages.callPackage ./horus {};
  protobuf-kodi = pkgs.kodi-gbm.packages.callPackage ./protobuf {};
  hyperion-kodi = pkgs.kodi-gbm.packages.callPackage ./hyperion-kodi {};
  kdrive = pkgs.callPackage ./kdrive {};
}

# TODO: add kodi plugin.video.wltvhelper
