{ pkgs, config, lib ? pkgs.stdenv.lib, ... }:
{
  imports = [];
  xsession = {
    windowManager.i3 =
      let modifier = "Mod4";
          workspace_chat = "0: chat";
          workspace_terminal = "1: terminal";
          workspace_editor = "2: editor";
          workspace_ide = "3: ide";
          workspace_email = "8: email";
          workspace_browser = "9: browser";
      in {
      enable = true;
      package = pkgs.i3-gaps;
      config = {
        modifier = "${modifier}";
        assigns = {
          "0: chat" = [{ class = "discord|Mattermost|Slack"; }];
          "1: terminal" = [{ class = "Alacritty|Gnome-terminal|.terminator-wrapped"; }];
          "9: browser" = [{ class = "Firefox|Chromium-browser"; }];
          "2: editor" = [{ class="Emacs|Code"; }];
          "3: ide" = [{ class="jetbrains-idea"; }];
        };

        gaps = {
          inner = 0;
          outer = 0;
        };

        keybindings = lib.mkOptionDefault {
            "${modifier}+period" = "exec i3lock";

            "${modifier}+space" = "floating toggle";
            "${modifier}+Shift+space" = "focus_mode toggle";

            "${modifier}+Escape" = "workspace prev";

            "${modifier}+Shift+d" = "gaps inner current set 0; gaps outer current set 0";
            "${modifier}+o" = "sticky toggle";
            "${modifier}+s" = "gaps inner current plus 5";
            "${modifier}+Shift+s" = "gaps inner current minus 5";
            "${modifier}+t" = "split toggle";
            "${modifier}+Shift+t" = "gaps inner current set 15; gaps outer current set 15";

            "${modifier}+1" = "workspace ${workspace_terminal}";
            "${modifier}+2" = "workspace ${workspace_editor}";
            "${modifier}+3" = "workspace ${workspace_ide}";
            "${modifier}+8" = "workspace ${workspace_email}";
            "${modifier}+9" = "workspace ${workspace_browser}";
            "${modifier}+0" = "workspace ${workspace_chat}";
            "${modifier}+Shift+1" = "move container to workspace ${workspace_terminal}";
            "${modifier}+Shift+2" = "move container to workspace ${workspace_editor}";
            "${modifier}+Shift+3" = "move container to workspace ${workspace_ide}";
            "${modifier}+Shift+8" = "move container to workspace ${workspace_email}";
            "${modifier}+Shift+9" = "move container to workspace ${workspace_browser}";
            "${modifier}+Shift+0" = "move container to workspace ${workspace_chat}";
            "${modifier}+Control+Left" = "move workspace to output Left";
            "${modifier}+Control+Right" = "move workspace to output Right";
            "${modifier}+Control+Up" = "move workspace to output Up";
            "${modifier}+Control+Down" = "move workspace to output Down";
            "${modifier}+Prior" = "workspace prev";
            "${modifier}+Next" = "workspace next";
            "${modifier}+numbersign" = "workspace back_and_forth";
            "XF86AudioRaiseVolume" = "exec --no-startup-id pactl set-sink-volume @DEFAULT_SINK@ +5%";
            "XF86AudioLowerVolume" = "exec --no-startup-id pactl set-sink-volume @DEFAULT_SINK@ -5%";
            "XF86AudioMute" = "exec --no-startup-id pactl set-sink-mute @DEFAULT_SINK@ toggle";
            "XF86MonBrightnessUp" = "exec xbacklight -inc 10";
            "XF86MonBrightnessDown" = "exec xbacklight -dec 10";
            "XF86AudioPlay" = "exec playerctl play";
            "XF86AudioPause" = "exec playerctl pause";
            "XF86AudioNext" = "exec playerctl next";
            "XF86AudioPrev" = "exec playerctl previous";
          };

        window.commands = [
           { criteria = { class = "^.*"; }; command = "border pixel 2"; }
           { criteria = { class = "Alacritty|Gnome-terminal|.terminator-wrapped"; }; command = "focus"; }
           { criteria = { class="^jetbrains-.+"; window_type="dialog"; }; command = "floating enable; move position center"; }
        ];
        window.hideEdgeBorders = "smart";

        bars = [ ];

        startup = [
          { command = "systemctl --user restart polybar"; notification = false; always = true; }
          { command = "autorandr --change"; notification = false; }
          { command = "xinput --set-prop \"Elan Touchpad\" \"libinput Natural Scrolling Enabled\" 1"; notification = false; always = true; }
          { command = "xinput --set-prop \"Elan Touchpad\" \"libinput Tapping Enabled\" 1"; notification = false; always = true; }
          { command = "${pkgs.xwallpaper}/bin/xwallpaper --zoom ${config.xdg.configHome}/wallpaper"; notification = false; always = true; }
          { command = "${pkgs.xcompmgr}/bin/xcompmgr -c -l0 -t0 -r0 -o.00"; always=true; notification = false; }
        ];
      };
    };
  };
}
