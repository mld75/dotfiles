self: super: {
  terraform-provider-libvirt = super.callPackage ./pkgs/terraform-providers/terraform-provider-libvirt { };
}
