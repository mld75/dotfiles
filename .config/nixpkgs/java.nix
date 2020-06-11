{ pkgs, config, lib ? pkgs.stdenv.lib, ... }:
#let
#  myoraclejdk8 = (pkgs.oraclejdk8.overrideAttrs (oldAttrs: rec { licenseAccepted = true; }));
#in
{
  home = {
    file."java/openjdk11" = {
      source = "${pkgs.openjdk11}/lib/openjdk";
    };
#    file."java/oraclejdk8" = {
#      source = "${myoraclejdk8}";
#    };
    packages = let
        mymaven = pkgs.callPackage ./pkgs/development/tools/build-managers/apache-maven {};
      in with pkgs; [
#        jetbrains.idea-ultimate
        (mymaven.overrideAttrs (oldAttrs: rec { jdk = pkgs.openjdk11; }))
      openjdk11
    ];
  };
}
