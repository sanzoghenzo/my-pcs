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

  silverbullet = pkgs.silverbullet.overrideAttrs (attrs: {
    version = "0.10.1";
    src = pkgs.fetchurl {
      url = "https://github.com/silverbulletmd/silverbullet/releases/download/0.10.1/silverbullet.js";
      hash = "sha256-4ZnA5cmLDlEUpeTBgz6Wg3XK3JJpgdt9bf9Eg7o82T8=";
    };
  });
}
