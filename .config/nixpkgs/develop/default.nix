{ pkgs, config, lib ? pkgs.lib, ... }:
let
    myemacs = (pkgs.emacsWithPackages (with (pkgs.emacsPackagesNgGen pkgs.emacs27); [vterm]));
in {
  imports = [
  ];

  home = {
    # Only development or programming related tools;
    # Nothing which could also be used outside of programming like writing documents

    packages = with pkgs; let
      exe = haskell.lib.justStaticExecutables;

    in [
      ansible
      # (exe haskellPackages.dhall)
      #(exe haskellPackages.dhall-bash)
      #(exe haskellPackages.dhall-json)
      #(exe haskellPackages.dhall-text)
      docker_compose
      gcc
      gitlab-runner
      go
#      helm # coredump 20.11.2018
      httpie
      jq
      kafkacat
      kind
      kubectl
      kubectx
      niv
      openjdk11
      python3Packages.pgcli
#      (terraform.withPlugins (p: [terraform-provider-libvirt p.aws p.template p.ignition p.local p.null]))
      ];

  };

  programs = {
    direnv.enable = true;
    gh.enable = true;
  };

  services = {
    lorri.enable = true;
  };

  xdg = {
  };

  systemd.user.services = lib.mkIf true {
  };
}
