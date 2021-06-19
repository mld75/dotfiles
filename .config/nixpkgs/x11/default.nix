{ pkgs, config, fetchurl, lib ? pkgs.stdenv.lib, ... }:
let
  synology-drive-client = pkgs.callPackage ../pkgs/synology-drive-client { };
in
{
  imports = [
    ./i3.nix
    ./polybar.nix
    ./restream.nix
  ];
  fonts.fontconfig.enable = true;

  home = {
    packages = with pkgs;
    [
      alacritty
      arandr
      autorandr
      calibre
      discord
      dropbox
      evince
      element-desktop
      feh
      fira-code
      font-awesome
      gimp
      gnome3.cheese
      gnome3.gnome-calculator
      hasklig
      jetbrains.idea-ultimate
      krita
      libreoffice
      notify-desktop
      paprefs
      pavucontrol
      powerline-fonts
      signal-desktop
      siji
      skype
      slack
      source-code-pro
      spotify
      # sweethome3d.application
      # sweethome3d.furniture-editor
      # sweethome3d.textures-editor
      teams
      unifont
      #virtualbox
      vscode
      xclip
      #xmind
      xorg.xev
      xournalpp
      xwallpaper
      zoom-us
    ];
  };

  programs = {
    autorandr = {
      enable = true;
      profiles = let
        fingerprints = let f = {
            eDP1 = "00ffffffffffff000daec91400000000081a0104951f11780228659759548e271e505400000001010101010101010101010101010101b43b804a71383440503c680035ad10000018000000fe004e3134304843412d4541420a20000000fe00434d4e0a202020202020202020000000fe004e3134304843412d4541420a20003e";
            DP1-1 = "00ffffffffffff0010ac72d04c553930281a010380371f78ee4455a9554d9d260f5054a54b00b300d100714fa9408180778001010101565e00a0a0a029503020350029372100001a000000ff0039583256593641363039554c0a000000fc0044454c4c205532353135480a20000000fd0038561e711e000a20202020202001d6020322f14f1005040302071601141f1213202122230907078301000065030c002000023a801871382d40582c250029372100001e011d8018711c1620582c250029372100009e011d007251d01e206e28550029372100001e8c0ad08a20e02d10103e9600293721000018483f00ca808030401a50130029372100001e000000dd";
            DP1-2 = "00ffffffffffff0010ac3a414c3238351a1c0104b5371f783eee95a3544c99260f5054a54b00714fa9408180d1c00101010101010101565e00a0a0a029503020350029372100001a000000ff0033433459503836533538324c0a000000fc0044454c4c205532353138440a20000000fd00384c1e5a19010a202020202020019a02031cf14f90050403020716010611121513141f23091f0783010000023a801871382d40582c450029372100001e7e3900a080381f4030203a0029372100001a011d007251d01e206e28550029372100001ebf1600a08038134030203a0029372100001a00000000000000000000000000000000000000000000000000000086";
            DP1-3 = "00ffffffffffff0010ac3c414c3238351a1c010380371f78eeee95a3544c99260f5054a54b00714fa9408180d1c00101010101010101565e00a0a0a029503020350029372100001a000000ff0033433459503836533538324c0a000000fc0044454c4c205532353138440a20000000fd00384c1e5a19000a202020202020011f020324f14f90050403020716010611121513141f23091f078301000067030c0010000032023a801871382d40582c450029372100001e7e3900a080381f4030203a0029372100001a011d007251d01e206e28550029372100001ebf1600a08038134030203a0029372100001a00000000000000000000000000000000000000c6";
            DP2-1 = f.DP1-1;
            DP2-2 = f.DP1-2;
            DP2-3 = f.DP1-3;
        }; in f;
      in
      {
        "builtin" = {
           fingerprint = {
             inherit (fingerprints) eDP1 DP1-1 DP1-2 DP1-3 DP2-1 DP2-2 DP2-3;
           };
           config = {
             eDP1 = {
               enable = true;
               rate = "60.00";
               mode = "1920x1080";
             };
             DP1-1.enable = false;
             DP1-2.enable = false;
             DP1-3.enable = false;
             DP2-1.enable = false;
             DP2-2.enable = false;
             DP2-3.enable = false;
           };
        };
        "home-2" = {
           fingerprint = {
             inherit (fingerprints) eDP1 DP1-1 DP1-2 DP1-3 DP2-1 DP2-2 DP2-3;
           };
           config = {
             eDP1.enable = false;
             DP1-1.enable = false;
             DP1-2.enable = false;
             DP1-3.enable = false;
             DP2-1 = {
               enable = true;
               primary = true;
               rate = "59.95";
               mode = "2560x1440";
               position = "2560x0";
             };
             DP2-2.enable = false;
             DP2-3 = {
               enable = true;
               rate = "59.95";
               mode = "2560x1440";
               position = "0x0";
             };
           };
        };
#         output DP1
# off
# output DP2
# off
# output DP2-2
# off
# output HDMI1
# off
# output HDMI2
# off
# output VIRTUAL1
# off
# output DP2-1
# crtc 1
# mode 2048x1080
# pos 0x0
# rate 60.00
# output DP2-3
# crtc 2
# mode 2048x1152
# pos 2048x0
# rate 60.00
# output eDP1
# crtc 0
# mode 1920x1080
# pos 0x1080
# primary
# rate 60.00
        "home-all" = {
           fingerprint = {
             inherit (fingerprints) eDP1 DP1-1 DP1-2 DP1-3 DP2-1 DP2-2 DP2-3;
           };
           config = {
             eDP1 = {
               enable = true;
               rate = "60.00";
               mode = "1920x1080";
               position = "0x1440";
             };
             DP2-1 = {
               enable = true;
               rate = "60.00";
               mode = "2560x1440";
               position = "2791x0";
             };
             DP2-3 = {
               enable = true;
               primary = true;
               rate = "60.00";
               mode = "2560x1440";
               position = "231x0";
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

    browserpass = {
      enable = true;
      browsers = [ "firefox" "chromium" ];
    };

    chromium = {
      enable = true;
      extensions = [
        "cfhdojbkjhnklbpkdaibdccddilifddb" # adblock-plus
        "naepdomgkenhinolocfifgehidddafch" # browserpass-ce
        "gcbommkclmclpchllfjekcdonpmejbdp" # https-everywhere
        "bfhkfdnddlhfippjbflipboognpdpoeh" # Read on reMarkable
      ];
    };

    firefox = {
      enable = true;
      #enableAdobeFlash = true;

      extensions = with pkgs.nur.repos.rycee.firefox-addons; [
        browserpass
        #browserpass-otp
        https-everywhere
        privacy-badger
      ];

      profiles = {
        j0xaf = {
          settings = {
            "browser.backspace_action" = 0;
            "browser.ctrlTab.recentlyUsedOrder" = false;
          };
          isDefault = true;
        };
      };
    };
    feh.enable = false;
    rofi.enable = true;
    zathura.enable = true;


  };
  services = {
    blueman-applet.enable = true; # broken 20191021

    picom = {
      enable = true; # high CPU usage when on.
    };

    dunst = {
      enable = true;
        settings = {
          global = {
            alignment = "right";
            allow_markup = true;
            bounce_freq = 0;
            browser = "xdg-open";
            dmenu = "${pkgs.dmenu}/bin/dmenu -p dunst";
            follow = "keyboard";
            font = "Liberation Sans 12";
            format = "<b>%s</b>\n%b";
            geometry = "350x5-30+20";
            horizontal_padding = 8;
            idle_threshold = 120;
            ignore_newline = false;
            indicate_hidden = true;
            line_height = 0;
            markup = "full";
            monitor = 0;
            padding = 8;
            progress_bar = true;
            separator_color = "#585858";
            separator_height = 2;
            show_age_threshold = 60;
            sort = true;
            startup_notification = true;
            sticky_history = true;
            transparency = 20;
            word_wrap = true;
            icon_position = "left";
          };
          frame = {
            width = 1;
            color = "#383838";
          };
          shortcuts = {
            close = "ctrl+space";
            close_all = "ctrl+shift+space";
            history = "ctrl+grave";
            context = "ctrl+shift+period";
          };
          urgency_low = {
            background = "#383A3B";
            foreground = "#FFFFFF";
            timeout = 5;
          };
          urgency_normal = {
            background = "#181818";
            foreground = "#E3C7AF";
            timeout = 10;
          };
          urgency_critical = {
            background = "#FD5F00";
            foreground = "#282226";
            timeout = 0;
          };
      };
     };

    flameshot.enable = true;

    network-manager-applet.enable = true;

    pasystray.enable = true;

    screen-locker = {
      enable = true;
      lockCmd = "i3lock"; # i3lock from nix not working.
      inactiveInterval = 10;
    };

    udiskie = {
      enable = true;
      automount = false;
    };

    unclutter = {
      enable = true;
      timeout = 3;
    };
  };
  xsession = {
    enable = true;
  };

  xdg = {
    configFile = {
      "autorandr/postswitch.d/restart-polybar" = {
        text = "systemctl --user restart polybar.service";
      };

      "mimeapps.list".text =
        let mimeapps = {
              "Default Applications" = {
                "application/pdf" = "org.gnome.Evince-previewer.desktop";
              };
            }; in lib.generators.toINI {} mimeapps;

#      "polybar/launch.sh" = {
#        text = builtins.readFile ./files/.config/polybar/launch.sh;
#        executable = true;
#      };
    };
  };
}
