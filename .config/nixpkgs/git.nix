{ pkgs, config, lib ? pkgs.stdenv.lib, ... }:
{
  home = {
    packages = with pkgs; [
      gitAndTools.ghq
      git-lfs
      git-secrets
      pass-git-helper
    ];
  };

  programs.git = {
    enable = true;
    userName = "Jörn Gersdorf";
    userEmail = "j0xaf@j0xaf.de";
    ignores = [
      "*~"
      ".DS_Store" ];
    extraConfig = {
      credential.helper = "${pkgs.pass-git-helper}/bin/pass-git-helper";
      "credential \"https://github.com\"" = {
        username = "j0xaf";
      };
#      credential.helper = "cache";
      "filter \"lfs\"" = {
          clean = "${pkgs.git-lfs}/bin/git-lfs clean -- %f";
          smudge = "${pkgs.git-lfs}/bin/git-lfs smudge --skip -- %f";
          required = true;
      };
      ghq = {
        root = "${config.home.homeDirectory}/git";
      };
    };
  };

  xdg = {
    configFile."pass-git-helper/git-pass-mapping.ini".text = ''
      [github.com*]
      target=github.com/j0xaf
      '';
  };
}
