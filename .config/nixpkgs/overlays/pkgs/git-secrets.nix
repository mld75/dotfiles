{ stdenv, lib, fetchFromGitHub, makeWrapper, git }:

let
  version = "c11c229a8eebb3545e5fd3bab4e8aa55a7f19383";
  repo = "git-secrets";

in stdenv.mkDerivation {
  name = "${repo}-${version}";

  src = fetchFromGitHub {
    inherit repo;
    owner = "awslabs";
    rev = "${version}";
    sha256 = "1gwx1hrqswl361jx5fir97471g9n8y901261n6xdhz1z3393l1ny";
  };

  buildInputs = [ makeWrapper git];

  # buildPhase = ''
  #  make man # TODO: need rst2man.py
  # '';
  
  installPhase = ''
    install -D git-secrets $out/bin/git-secrets

    wrapProgram $out/bin/git-secrets \
      --prefix PATH : "${lib.makeBinPath [ git ]}"

    # TODO: see above note on rst2man.py
    # mkdir $out/share
    # cp -r man $out/share
  '';

  meta = {
    description = "Prevents you from committing passwords and other sensitive information to a git repository";
    homepage = https://github.com/awslabs/git-secrets;
    license = lib.licenses.asl20;
    platforms = lib.platforms.all;
  };
}
