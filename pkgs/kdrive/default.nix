{
  appimageTools,
  fetchurl,
  lib,
  stdenv,
  alsa-lib,
  e2fsprogs,
  expat,
  fontconfig,
  freetype,
  gcc-unwrapped,
  glib,
  glibc,
  gmp,
  libglvnd,
  libgpg-error,
  p11-kit,
  qt6,
  xorg,
  zlib,
}:

with lib;

let
  pname = "kDrive";
  version = "3.6.1.20240604";

  srcs = {
    x86_64-linux = fetchurl {
      url = "https://download.storage.infomaniak.com/drive/desktopclient/kDrive-${version}-amd64.AppImage";
      sha256 = "sha256-PLHaNA8W/m+EUFGejM0WpXo288F/QyVRGMBJK35A2qk=";
    };

    aarch64-linux = fetchurl {
      url = "https://download.storage.infomaniak.com/drive/desktopclient/kDrive-${version}-arm64.AppImage";
      #sha256 = ""; # TODO
    };

    x86_64-darwin = fetchurl {
      url = "https://download.storage.infomaniak.com/drive/desktopclient/kDrive-${version}.pkg";
      #sha256 = ""; # TODO
    };
  };

  src =
    srcs.${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");

  meta = {
    description = "kDrive desktop synchronization client.";
    homepage = "https://www.infomaniak.com/kdrive";
    license = licenses.gpl3Plus;
    platforms = builtins.attrNames srcs;
    maintainers = [ maintainers.nicolas-goudry ];
    mainProgram = "kDrive";
  };

  contents = appimageTools.extract { inherit pname version src; };

  linux = stdenv.mkDerivation rec {
    inherit
      pname
      version
      src
      meta
      ;

    dontUnpack = true;
    dontConfigure = true;
    dontBuild = true;
    # Avoid auto-wrap to set rpath
    dontWrapQtApps = true;

    buildInputs = [ qt6.qtbase ];
    nativeBuildInputs = [ qt6.wrapQtAppsHook ];
    libPath = makeLibraryPath [
      alsa-lib
      e2fsprogs
      expat
      fontconfig
      freetype
      gcc-unwrapped
      glib
      glibc
      gmp
      libglvnd
      libgpg-error
      p11-kit
      qt6.qtbase
      qt6.qtdeclarative
      qt6.qtsvg
      qt6.qtwebengine
      xorg.libICE
      xorg.libSM
      xorg.libX11
      xorg.libxcb
      zlib
    ];

    installPhase = ''
      runHook preInstall

      # Copy top-level stuff
      for dir in bin lib plugins resources translations; do
        mkdir -p $out/$dir
        cp -R ${contents}/usr/$dir/* $out/$dir
      done

      # Copy some content from share directory
      for dir in icons kDrive_client; do
        mkdir -p $out/share/$dir
        cp -R ${contents}/usr/share/$dir/* $out/share/$dir
      done

      # Keep only one desktop entry
      mkdir -p $out/share/applications
      cp -R ${contents}/usr/share/applications/kDrive_client.desktop $out/share/applications

      runHook postInstall
    '';

    postFixup = ''
      pushd $out/bin
      for file in kDrive kDrive_client; do
        patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" $file
      done
      popd

      pushd $out
      for file in $(find . -type f \( -name kDrive -o -name kDrive_client -o -name \*.so\* \)); do
        patchelf --set-rpath ${libPath}:$out/lib $file || true
      done
      popd

      wrapQtApp $out/bin/kDrive
    '';
  };

  darwin = stdenv.mkDerivation {
    inherit
      pname
      version
      src
      meta
      ;

    dontBuild = true;

    unpackPhase = ''
      7z x $src
      bsdtar -xf Payload~
    '';

    installPhase = ''
      runHook preInstall

      mkdir -p $out/bin
      install -Dm755 usr/local/bin/kdrive -t $out/bin

      runHook postInstall
    '';
  };
in
if stdenv.isDarwin then darwin else linux
