{
  packageOverrides = pkgs: {
    nur = import (builtins.fetchTarball "https://github.com/nix-community/NUR/archive/master.tar.gz") {
      inherit pkgs;
    };
  };
  allowUnfree = true;
  oraclejdk.accept_license = true;
  imports = [
    /etc/nixos/cachix.nix
  ];
}
