{pkgs}: {
  horus = pkgs.kodi-gbm.packages.callPackage ./horus {};
  protobuf-kodi = pkgs.kodi-gbm.packages.callPackage ./protobuf {};
  hyperion-kodi = pkgs.kodi-gbm.packages.callPackage ./hyperion-kodi {};
  mpv-acestream = pkgs.callPackage ./mpv-acestream {};
  openthread-border-router = pkgs.callPackage ./openthread-border-router {};
}
