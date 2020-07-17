{ lib
, stdenv
, fetchFromGitHub
}:
stdenv.mkDerivation {

  pname = "instantWidgets";
  version = "unstable";

  src = fetchFromGitHub {
    owner = "instantOS";
    repo = "instantwidgets";
    rev = "a050ab8cefd3bd334a3e60efa5ea479936717993";
    sha256 = "01g2yfw00ygvhb256yp6kvnxzk6y5z2qnk9qsakiac14f5ypf7ps";
    name = "instantOS_instantWidgets";
  };

  postPatch = ''
    substituteInPlace install.conf \
      --replace /usr/share/instantwidgets "$out/share/instantwidgets"
  '';

  installPhase = ''
    mkdir -p "$out/share/instantwidgets"
    mv * "$out/share/instantwidgets"
  '';

  meta = with lib; {
    description = "instantOS widgets";
    license = licenses.mit;
    homepage = "https://github.com/instantOS/instantwidgets";
    maintainers = [ "Scott Hamilton <sgn.hamilton+nixpkgs@protonmail.com>" ];
    platforms = platforms.linux;
  };
}
