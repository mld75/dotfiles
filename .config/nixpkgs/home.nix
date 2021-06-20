{ pkgs, lib ? pkgs.stdenv.lib, config, ... }:
let
#  all-hies = import (fetchTarball "https://github.com/infinisil/all-hies/tarball/master") {};
  pkgsUnstable = import <nixpkgs-unstable> {};
  niv = import (pkgs.fetchFromGitHub {
    owner = "nmattia";
    repo = "niv";
    rev = "cfed53d1042f90c98bfed66075ff9203f09bf42d";
    sha256 = "141944lmmpi06vi3d8z86syviaswyb3cqqd7pgd6ivr6qd6w843m";
  }) {};
  lockcmd = "i3lock -i ${config.home.homeDirectory}/Pictures/Wallpaper/01-general-view-sarti-halkidiki-greece.png";
  makeGlWrapper = wrappedpkg: pkgs.symlinkJoin {
    name = "${wrappedpkg.pname}-non-nixos-${wrappedpkg.version}";
    paths = [ wrappedpkg ];
    buildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/${wrappedpkg.pname} \
        --set LIBGL_DRIVERS_PATH ${pkgs.mesa_drivers}/lib/dri \
        --set LD_LIBRARY_PATH ${pkgs.mesa_drivers}/lib:$LD_LIBRARY_PATH
    '';
  };
in
{
  imports = [
    ./aws.nix
    ./mail
    ./develop
    ./git.nix
#    ./java.nix
#    ./parcellite.nix
    ./shell
    ./urxvt.nix
    ./x11
  ];

  fonts.fontconfig.enable = true;

  programs = {
    home-manager = {
      enable = true;
      path = https://github.com/rycee/home-manager/archive/master.tar.gz;
    };
  };


  home =  {
    stateVersion = "18.09";
    keyboard = {
      layout = "us";
      variant = "international";
    };
  };

  services = {
    gpg-agent = {
      enable = true;
      defaultCacheTtl = 3600;
      defaultCacheTtlSsh = 3600;
      maxCacheTtl = 7200;
      maxCacheTtlSsh = 7200;
      enableSshSupport = true;
#      extraConfig = ''
#        allow-emacs-pinentry
#        pinentry-program ${pkgs.pinentry-gtk2}/bin/pinentry-gtk-2
#      '';
    };

  #  udev.extraRules = ''
  #    SUBSYSTEMS=="usb", ATTRS{idVendor}=="", ATTRS{idProduct}=="", RUN+="/usr/bin/setxkbmap us altgr-intl"
  #      '';
  };
}
