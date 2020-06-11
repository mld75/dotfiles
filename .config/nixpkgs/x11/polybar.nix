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
        pulseSupport = true;
      };
      config = ../files/.config/polybar/config;
      script = ''
      # Terminate already running bar instances
      (${pkgs.procps}/bin/pkill -u "$USER" -x 'polybar-wrappe') || true

      while ${pkgs.procps}/bin/pgrep -u "$USER" -x '.polybar-wrappe' >/dev/null; do sleep 1; done

      for m in $(polybar --list-monitors | ${pkgs.coreutils}/bin/cut -d":" -f1); do
        MONITOR=$m polybar top &
      done

      echo "Bar launched..."
      '';
    };
  };
}
