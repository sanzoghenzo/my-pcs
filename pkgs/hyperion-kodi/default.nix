{
  lib,
  rel,
  buildKodiAddon,
  fetchzip,
  addonUpdateScript,
  protobuf-kodi,
}:
buildKodiAddon rec {
  pname = "hyperion-kodi";
  namespace = "script.service.hyperion";
  version = "20.0.1";

  src = fetchzip {
    url = "https://mirrors.kodi.tv/addons/${lib.toLower rel}/${namespace}/${namespace}-${version}.zip";
    sha256 = "sha256-nCWfyFBzHtZlQ9M8I3y9+io3DqZH7utf6oJgSusjt7w=";
  };

  propagatedBuildInputs = [
    protobuf-kodi
  ];

  passthru = {
    updateScript = addonUpdateScript {
      attrPath = "script.service.hyperion";
    };
  };

  meta = with lib; {
    homepage = "https://github.com/hyperion-project/hyperion.kodi";
    description = "Capture and send your current Kodi-picture to your Hyperion Ambient Lighting system.";
    license = licenses.mit;
    maintainers = teams.kodi.members;
  };
}
