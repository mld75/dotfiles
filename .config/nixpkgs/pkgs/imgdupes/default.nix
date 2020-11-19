{ lib, python3Packages }:

python3Packages.buildPythonApplication rec {
    pname = "imgdupes";  
    version = "0.1.1";

    src = python3Packages.fetchPypi {
      inherit pname version;
      sha256 = "1k1ybswid814p7i9g2fcn6kjq8xxyv69y3xjymkh5i19fl6misq5";
    };

    propagatedBuildInputs = with python3Packages; [ ngt numpy pathos termcolor webcolors ];

}
