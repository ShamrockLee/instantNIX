{ lib
, stdenv
, fetchFromGitHub
, instantMenu
}:
stdenv.mkDerivation {

  pname = "imenu";
  version = "unstable";

  src = fetchFromGitHub {
    owner = "instantOS";
    repo = "imenu";
    rev = "9c96964ed933294b16164dd21101183199e208cc";
    sha256 = "0n9cnfqwzs0f2swc0mzy1qcrsiqcsmk2dz85m8fkf5lrfy2pigsj";
    name = "instantOS_imenu";
  };

  propagatedBuildInputs = [
    instantMenu
  ];

  installPhase = ''
    install -Dm 555 imenu.sh $out/bin/imenu
  '';

  meta = with lib; {
    description = "instantOS imenu";
    license = licenses.mit;
    homepage = "https://github.com/instantOS/imenu";
    maintainers = [ "con-f-use <con-f-use@gmx.net" ];
    platforms = platforms.linux;
  };
}
