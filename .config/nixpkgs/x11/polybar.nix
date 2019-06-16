{ pkgs, config, lib ? pkgs.stdenv.lib, ... }:
{
  home = {
    packages = with pkgs; [
      siji
      unifont
    ];
  };

  services = {
    polybar = {
      enable = true;
      package = pkgs.polybar.override {
        i3GapsSupport = true;
      };
      config = ../files/.config/polybar/config;
      script = "polybar top &";
    };
  };
}
