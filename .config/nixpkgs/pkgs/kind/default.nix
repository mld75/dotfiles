{ stdenv, buildGoPackage, fetchFromGitHub }:

with stdenv.lib;

buildGoPackage rec {
  name = "kind-${version}";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "kubernetes-sigs";
    repo = "kind";
    rev = "${version}";
    sha256 = "1i5iwrwxhdwllh3y6srlpqfxakwbc9nhz4rkgr8i4xd4ilbdychm";
  };

  goPackagePath = "sigs.k8s.io/kind";
  excludedPackages = "\\(images/base/entrypoint\\|hack/tools\\)";

  meta = {
    description = "Kubernetes IN Docker - local clusters for testing Kubernetes";
    homepage = https://github.com/kubernetes-sigs/kind;
    maintainers = with maintainers; [ offline rawkode ];
    license = stdenv.lib.licenses.asl20;
    platforms = platforms.unix;
  };
}
