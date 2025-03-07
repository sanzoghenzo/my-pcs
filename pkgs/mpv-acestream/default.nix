{
  lib,
  fetchFromGitHub,
  buildLua,
}:
buildLua rec {
  pname = "mpv-acestream";
  version = "0.5";

  src = fetchFromGitHub {
    owner = "Digitalone1";
    repo = "mpv-acestream";
    rev = "v${version}";
    sha256 = "";
  };

  scriptPath = "./scripts/${pname}.lua";

  meta = {
    description = "Add AceStream protocol support to mpv";
    homepage = "https://github.com/Digitalone1/mpv-acestream";
    # maintainers = [ lib.maintainers.sanzoghenzo ];
    license = lib.licenses.gplv3;
  };
}
