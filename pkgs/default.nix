{pkgs}:
# let
#   inherit (pkgs.libretro) mame2003-plus parallel-n64;
# in
rec {
  kdrive = pkgs.callPackage ./kdrive {};
  horus = pkgs.kodi-gbm.packages.callPackage ./horus {};
  protobuf-kodi = pkgs.kodi-gbm.packages.callPackage ./protobuf {};
  hyperion-kodi = pkgs.kodi-gbm.packages.callPackage ./hyperion-kodi {};
  mpv-acestream = pkgs.callPackage ./mpv-acestream {};

  silverbullet = pkgs.silverbullet.overrideAttrs (attrs: {
    version = "0.10.1";
    src = pkgs.fetchurl {
      url = "https://github.com/silverbulletmd/silverbullet/releases/download/0.10.1/silverbullet.js";
      hash = "sha256-4ZnA5cmLDlEUpeTBgz6Wg3XK3JJpgdt9bf9Eg7o82T8=";
    };
  });
}
