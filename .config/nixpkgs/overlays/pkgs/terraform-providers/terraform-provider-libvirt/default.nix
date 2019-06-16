{ stdenv, buildGoPackage, fetchFromGitHub, libvirt, pkgconfig, makeWrapper, cdrtools,
  version ? "0.5.0",
  sha256 ? "0asdws2cd624449a8v81fkvq0ij94bpyi5dbmxs75i35ff514lqh" }:

# USAGE:
# install the following package globally or in nix-shell:
#
#   (terraform.withPlugins (p: [p.libvirt]))
#
# configuration.nix:
#
#   virtualisation.libvirtd.enable = true;
#
# terraform-provider-libvirt does not manage pools at the moment:
#
#   $ virsh --connect "qemu:///system" pool-define-as default dir - - - - /var/lib/libvirt/images
#   $ virsh --connect "qemu:///system" pool-start default
#
# pick an example from (i.e ubuntu):
# https://github.com/dmacvicar/terraform-provider-libvirt/tree/master/examples

buildGoPackage rec {
  name = "terraform-provider-libvirt-${version}";
  inherit version;

  goPackagePath = "github.com/dmacvicar/terraform-provider-libvirt";

  src = fetchFromGitHub {
    inherit sha256;
    owner = "dmacvicar";
    repo = "terraform-provider-libvirt";
    rev = "v${version}";
  };

  buildInputs = [ libvirt pkgconfig makeWrapper ];

  # mkisofs needed to create ISOs holding cloud-init data,
  # and wrapped to terraform via deecb4c1aab780047d79978c636eeb879dd68630
  propagatedBuildInputs = [ cdrtools ];

  # Terraform allow checking the provider versions, but this breaks
  # if the versions are not provided via file paths.
  postBuild = "mv go/bin/terraform-provider-libvirt{,_v${version}}";

  meta = with stdenv.lib; {
    homepage = https://github.com/dmacvicar/terraform-provider-libvirt;
    description = "Terraform provider for libvirt";
    platforms = platforms.linux;
    license = licenses.asl20;
    maintainers = with maintainers; [ mic92 ];
  };
}
