self: super: {
  git-secrets = super.callPackage ./pkgs/git-secrets.nix { };
}
