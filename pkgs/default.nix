{ pkgs }:
# let
#   inherit (pkgs.libretro) mame2003-plus parallel-n64;
# in
rec {
  kdrive = pkgs.callPackage ./kdrive { };
  kodi-py311 = pkgs.kodi-gbm.override { python3Packages = pkgs.python311Packages; };
  horus = kodi-py311.packages.callPackage ./horus { };
  protobuf-kodi = kodi-py311.packages.callPackage ./protobuf { };
  hyperion-kodi = kodi-py311.packages.callPackage ./hyperion-kodi { };
}
