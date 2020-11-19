
{ autoPatchelfHook
, dpkg
, fetchurl
, glib
, gnome3
, lib
, stdenv
, xkeyboardconfig
, xlibs
, zlib
, wrapGAppsHook }:

let

  mirror = "https://global.download.synology.com/download/Utility/SynologyDriveClient";

in stdenv.mkDerivation rec {

  pname = "synology-drive-client";
  version = "2.0.2";
  buildNumber = "11078";
  architecture = "x86_64";

  src = fetchurl {
    url = "${mirror}/${version}-${buildNumber}/Ubuntu/Installer/${architecture}/${pname}-${buildNumber}.${architecture}.deb";
    sha256 = "10r89ijzam2dvaqgjijj0vlpd04flk6b5gq6w46jdmyvj8jk0rca";
  };

  unpackCmd = "${dpkg}/bin/dpkg-deb -x $curSrc .";
  sourceRoot = ".";

  nativeBuildInputs = [
    autoPatchelfHook
    wrapGAppsHook
  ];

  buildInputs = [
    glib
    gnome3.nautilus
    stdenv.cc.cc.lib
    xlibs.libICE
    xlibs.libSM
    xlibs.libX11
    zlib
  ];

  runtimeDependencies = [
    xkeyboardconfig
  ];

  installPhase = ''
    mkdir -p $out $out/lib/
    cp -r . $out/
    mv $out/opt/Synology/SynologyDrive/lib/*.so* $out/lib/
  '';

  meta = with lib; {
    homepage = "https://www.synology.com";
    description = "Drive Synchronization";
    platforms = [ "x86_64-linux" ];
    license = licenses.unfree;
  };
}
