{  stdenvNoCC, buildEnv, writeShellScriptBin, fetchzip }:

let
  name = "camunda-modeler-${version}";
  version = "3.4.1";

  camunda-modeler = fetchzip {
    url = "https://camunda.org/release/camunda-modeler/3.4.1/camunda-modeler-3.4.1-linux-x64.tar.gz";
    sha256 = "1bpfhmazzzp9vnjnddf6kfzxr8d46kkk4840wm5rgaijag59bgqq";
  };

  script = writeShellScriptBin "camunda-modeler" ''
  set -euo pipefail
  ${camunda-modeler}/camunda-modeler
  '';
in

buildEnv {
  inherit name;
  paths = [ script ];

  meta = with stdenvNoCC.lib; {
    description = "Camunda Modeler.";
    maintainers = with maintainers; [ ];
    platforms = platforms.all;
    homepage = https://camunda.com;
  };
}
