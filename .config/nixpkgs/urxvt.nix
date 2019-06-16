{ pkgs, config, lib ? pkgs.stdenv.lib, ... }:
{
  home = {
    file.".terminfo/r" = {
      source = "${pkgs.rxvt_unicode.terminfo}/share/terminfo/r";
      recursive = true;
    };
  };

  programs.urxvt = {
    enable = true;
    fonts = [ "xft:Source Code Pro:size=14" ];
    keybindings = {
          "Shift-Control-C" = "eval:selection_to_clipboard";
          "Shift-Control-V" = "eval:paste_clipboard";
          };
    transparent = true;
    shading = 30;
  };

  xresources.extraConfig = ''
! special
*.foreground:   #93a1a1
*.background:   #002b36
*.cursorColor:  #93a1a1

! black
*.color0:       #002b36
*.color8:       #657b83

! red
*.color1:       #dc322f
*.color9:       #dc322f

! green
*.color2:       #859900
*.color10:      #859900

! yellow
*.color3:       #b58900
*.color11:      #b58900

! blue
*.color4:       #268bd2
*.color12:      #268bd2

! magenta
*.color5:       #6c71c4
*.color13:      #6c71c4

! cyan
*.color6:       #2aa198
*.color14:      #2aa198

! white
*.color7:       #93a1a1
*.color15:      #fdf6e3
  '';

}
