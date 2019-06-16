{ pkgs, config, lib ? pkgs.stdenv.lib, ... }:
{
  imports = [
    ./i3.nix
    ./polybar.nix
  ];

  programs = {
    autorandr = {
      enable = true;
      profiles = let
        fingerprints = {
            eDP1 = "00ffffffffffff000daec91400000000081a0104951f11780228659759548e271e505400000001010101010101010101010101010101b43b804a71383440503c680035ad10000018000000fe004e3134304843412d4541420a20000000fe00434d4e0a202020202020202020000000fe004e3134304843412d4541420a20003e";
            DP1-2 = "00ffffffffffff0010ac3a414c3238351a1c0104b5371f783eee95a3544c99260f5054a54b00714fa9408180d1c00101010101010101565e00a0a0a029503020350029372100001a000000ff0033433459503836533538324c0a000000fc0044454c4c205532353138440a20000000fd00384c1e5a19010a202020202020019a02031cf14f90050403020716010611121513141f23091f0783010000023a801871382d40582c450029372100001e7e3900a080381f4030203a0029372100001a011d007251d01e206e28550029372100001ebf1600a08038134030203a0029372100001a00000000000000000000000000000000000000000000000000000086";
            DP1-3 = "00ffffffffffff0010ac6ed04c553930281a0104a5371f783e4455a9554d9d260f5054a54b00b300d100714fa9408180778001010101565e00a0a0a029503020350029372100001a000000ff0039583256593641363039554c0a000000fc0044454c4c205532353135480a20000000fd0038561e711e010a202020202020016302031cf14f1005040302071601141f12132021222309070783010000023a801871382d40582c450029372100001e011d8018711c1620582c250029372100009e011d007251d01e206e28550029372100001e8c0ad08a20e02d10103e9600293721000018483f00ca808030401a50130029372100001e00000000000000000057";
        };
      in
      {
        "builtin" = {
           fingerprint = {
             inherit (fingerprints) eDP1 DP1-2 DP1-3;
           };
           config = {
             eDP1 = {
               enable = true;
               rate = "60.00";
               mode = "1920x1080";
             };
             DP1-2.enable = false;
             DP1-3.enable = false;
           };
        };
        "home-2" = {
           fingerprint = {
             inherit (fingerprints) eDP1 DP1-2 DP1-3;
           };
           config = {
             eDP1.enable = false;
             DP1-2 = {
               enable = true;
               primary = true;
               rate = "60.00";
               mode = "2560x1440";
               position = "0x0";
             };
             DP1-3 = {
               enable = true;
               rate = "60.00";
               mode = "2560x1440";
               position = "2560x0";
             };
           };
        };
        "home-all" = {
           fingerprint = {
             inherit (fingerprints) eDP1 DP1-2 DP1-3;
           };
           config = {
             eDP1 = {
               enable = true;
               rate = "60.00";
               mode = "1920x1080";
               position = "0x1440";
             };
             DP1-2 = {
               enable = true;
               primary = true;
               rate = "60.00";
               mode = "2560x1440";
               position = "0x0";
             };
             DP1-3 = {
               enable = true;
               rate = "60.00";
               mode = "2560x1440";
               position = "2560x0";
             };
           };
        };
      };
      hooks = {
        postswitch = {
          "notify-i3" = "${pkgs.i3}/bin/i3-msg restart";
          "restart-compton" = "${pkgs.systemd}/bin/systemctl --user restart compton.service";
          "restart-polybar" = "${pkgs.systemd}/bin/systemctl --user restart polybar.service";
        };
      };
    };
  };
  xsession = {
    enable = true;
  };
}
