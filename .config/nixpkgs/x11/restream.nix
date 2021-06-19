{ pkgs, config, lib ? pkgs.stdenv.lib, ... }:
let
in
{
  imports = [
  ];
  home = {
    file = {
      "bin/restream.sh" = {
        executable = true;
        source = builtins.fetchurl {
          url = "https://raw.githubusercontent.com/rien/reStream/main/reStream.sh";
          sha256 = "03djx9jw7psnc7ak5mb9p41vyvib1x3sr1sgi7djwbxsah54qn02";
        };
      };
    };
    packages = with pkgs; [
      ffmpeg-full
      lz4
    ];
  };
}
