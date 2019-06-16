{ pkgs, config, lib ? pkgs.stdenv.lib, ... }:
{
  home = {
    packages = with pkgs; [
      awscli
      aws-iam-authenticator
    ];
  };
}
