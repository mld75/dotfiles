{  stdenvNoCC, buildEnv, writeShellScriptBin, fetchurl, oraclejdk8 }:

let
  name = "conduktor-${version}";
  version = "1.0";
  myoraclejdk8 = (oraclejdk8.overrideAttrs (oldAttrs: rec { licenseAccepted = true; }));

  conduktor = fetchurl {
    url = "https://cdn.conduktor.io/jar/Conduktor-${version}.jar";
    sha256 = "0jliakjzgc2ripgisi3j81j7w4f9gb2drjh7r1wv5q3yc298zbqk";
  };

  script = writeShellScriptBin "conduktor" ''
  set -euo pipefail
  ${myoraclejdk8}/bin/java -jar ${conduktor}
  '';
in

buildEnv {
  inherit name;
  paths = [ script ];

  meta = with stdenvNoCC.lib; {
    description = "Conduktor, an Apache Kafka desktop client";
    maintainers = with maintainers; [ ];
    platforms = platforms.all;
    homepage = https://conduktor.io;
  };
}
