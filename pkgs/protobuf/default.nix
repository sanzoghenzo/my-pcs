{
  lib,
  rel,
  buildKodiAddon,
  fetchzip,
  addonUpdateScript,
  requests,
}:
buildKodiAddon rec {
  pname = "protobuf";
  namespace = "script.module.protobuf";
  version = "4.23.2";

  src = fetchzip {
    url = "https://mirrors.kodi.tv/addons/${lib.toLower rel}/${namespace}/${namespace}-${version}.zip";
    sha256 = "sha256-O19P+fhGoN3Np09o/SZ2WdSZze0eLFitZK0K0hghZ1s=";
  };

  passthru = {
    updateScript = addonUpdateScript {
      attrPath = "script.module.protobuf";
    };
  };

  meta = with lib; {
    homepage = "https://github.com/sanzoghenzo/kodi-protobuf";
    description = "Protocol Buffers (a.k.a., protobuf) are Google's language-neutral, platform-neutral, extensible mechanism for serializing structured data.";
    license = licenses.bsd3;
    maintainers = teams.kodi.members;
  };
}
