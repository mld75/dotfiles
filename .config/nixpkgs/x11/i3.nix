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
          "0: chat" = [{ class = "Mattermost|Slack"; }];
          "1: terminal" = [{ class = "Alacritty|Gnome-terminal|.terminator-wrapped"; }];
          "9: browser" = [{ class = "Firefox|Chromium-browser"; }];
          "2: editor" = [{ class="Emacs|Code"; }];
          "3: ide" = [{ class="jetbrains-idea"; }];
        };

        gaps = {
          inner = 15;
          outer = 15;
        };

        keybindings = lib.mkOptionDefault {
            # "${modifier}+Return" = "exec ${pkgs.terminator}/bin/terminator"; # Bug https://github.com/NixOS/nixpkgs/issues/56943
            "${modifier}+period" = "exec i3lock";
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
           { criteria = { class = "Firefox|Chromium-browser"; }; command = "focus"; }
           { criteria = { class = "Emacs|Code"; }; command = "focus"; }
           { criteria = { class = "jetbrains-idea"; }; command = "focus"; }
        ];

        bars = [
          # { statusCommand = "LC_ALL=C ${pkgs.i3status}/bin/i3status"; }
          #{
          #  fonts = [ "pango:mono 10" ];
          #  statusCommand = "${pkgs.i3blocks}/bin/i3blocks";
          #  position = "top";
          #  mode = "dock";
          #}
        ];

        startup = [
          { command = "autorandr --change"; notification = false; }
          { command = "xinput --set-prop \"ETPS/2 Elantech Touchpad\" \"libinput Natural Scrolling Enabled\" 1"; notification = false; always = true; }
          { command = "xinput --set-prop \"ETPS/2 Elantech Touchpad\" \"libinput Tapping Enabled\" 1"; notification = false; always = true; }
          { command = "${pkgs.xwallpaper}/bin/xwallpaper --zoom ${config.xdg.configHome}/wallpaper"; notification = false; always = true; }
        ];
      };
    };
  };
}