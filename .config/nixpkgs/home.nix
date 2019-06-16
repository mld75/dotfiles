{ pkgs, lib ? pkgs.stdenv.lib, config, ... }:
let
  islinux = pkgs.system != "x86_64-darwin";
#  all-hies = import (fetchTarball "https://github.com/infinisil/all-hies/tarball/master") {};
  niv = import (pkgs.fetchFromGitHub {
    owner = "nmattia";
    repo = "niv";
    rev = "cfed53d1042f90c98bfed66075ff9203f09bf42d";
    sha256 = "141944lmmpi06vi3d8z86syviaswyb3cqqd7pgd6ivr6qd6w843m";
  }) {};
in
{
  imports = [
    ./aws.nix
    ./git.nix
    ./parcellite.nix
    ./urxvt.nix
    ./x11
  ];

 fonts.fontconfig.enable = true;

  programs = {
    home-manager = {
      enable = true;
      path = https://github.com/rycee/home-manager/archive/master.tar.gz;
    };

    bat.enable = true;

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
      ];
    };

    direnv.enable = true;
    firefox.enable = true;
    feh.enable = false;
    fzf.enable = true;
    htop.enable = true;
    #lsd.enable = true;
    info.enable = true;
    man.enable = true;
    rofi.enable = true;
    skim.enable = true;

    ssh = {
      enable = true;
      matchBlocks."vnc.df.dwpsoftware.hu" = {
        identityFile = "/home/dwp5080/.ssh/vnc@dwpsoftware.hu";
      };
    };

    vim.enable = true;

  #  zathura.enable = true; # currently broken

    zsh = {
      enable = true;
      oh-my-zsh = {
        enable = true;
        custom = "$HOME/.oh-my-zsh-custom";
        theme = "agnoster";
        plugins = [
          "cabal"
          "docker"
          "docker-compose"
          "docker-machine"
          "emacs"
          "fasd"
          "fzf"
          "git"
          "helm"
          "httpie"
          "mvn"
          "nix"
          "pass"
          "terraform"
          "tmux"
          "vagrant"
          "z"
          "zsh-autosuggestions"
        ];
      };
      shellAliases = {
        et = "te";
        cfg = ''git --git-dir="$HOME/.cfg/" --work-tree="$HOME"'';
        magit = ''te --eval "(magit-status)"'';
        "xkb-de" = "setxkbmap de nodeadkeys";
        "xkb-us" = "setxkbmap us altgr-intl";
      };
      initExtra = ''
      # fd - cd to selected directory
      fd() {
        local dir
        dir=$(find ''${1:-.} -path '*/\.*' -prune \
                        -o -type d -print 2> /dev/null | fzf +m) &&
        cd "$dir"
      }
      dired() { te --eval "(dired \"''${1:-.}\")" }
      '';
    };
  };


  home =  {
    stateVersion = "18.09";
    keyboard = {
      layout = "us";
      variant = "international";
    };

    packages = with pkgs; let exe = haskell.lib.justStaticExecutables; in [
      ack
      acpi # for checking battery status on the CLI
#      all-hies.versions.ghc864
      arandr
      autojump
      alacritty
      ansible
      autorandr
      blackbox
      curl
      dep
      diffpdf
      (exe haskellPackages.dhall)
      (exe haskellPackages.dhall-bash)
      (exe haskellPackages.dhall-json)
      (exe haskellPackages.dhall-text)
      dmenu
      docker_compose
      docker-machine
      emacs26
      entr
      evince
      fasd
      fish
      fira-code
      # font-awesome
      gcc
      gimp
      gnupg
      go
      gradle
#      (exe haskellPackages.matterhorn)
#      (exe haskellPackages.hadolint)
      (exe haskellPackages.nix-derivation)
#      helm # coredump 20.11.2018
      highlight
      htop
      httpie
      icdiff
      iftop
      iotop
      jq
      krita
      less
      links
#     linphone # only 3.x, not 4.x
      jetbrains.idea-ultimate
      #jetbrains.goland
      kafkacat
      (pkgs.callPackage ./pkgs/kind {}) # 0.2.0 not yet in nixpkgs
      kubectl
      kubectx
      mattermost-desktop
      maven
      niv.niv
      nix-prefetch-github
      nettools
      openjdk11
      pass
      paprefs
      pavucontrol
      pinentry_gnome
      playerctl
      #postman
      powertop
      ripgrep
      skype
      slack
      source-code-pro
      spotify
      st
      terminator
#      (terraform.withPlugins (p: [terraform-provider-libvirt p.aws p.template p.ignition p.local p.null]))
      tig
      tmux
      tree
      vagrant
      vscode
      xclip
      #xmind
      xournalpp
      xwallpaper
      youtube-dl
      zsh
    ] ++ [
      apache-directory-studio
    ];

    sessionVariables = {
      EDITOR = "${pkgs.emacs}/bin/emacsclient -t";
      # FZF_BASE = "${pkgs.fzf}"; # geht nicht
      PAGER = "less";
      LESS = "-XR --quit-if-one-screen";
      MANPATH = ":/usr/share/man";
      #TERMINAL = "${pkgs.gnome3.gnome-terminal}/bin/gnome-terminal";
      TERMINAL = "${pkgs.alacritty}/bin/alacritty";
    };
  };

  services = {
    blueman-applet.enable = true;

    compton.enable = true;
    dunst = {
      enable = true;
        settings = {
          global = {
            alignment = "center";
            allow_markup = true;
            bounce_freq = 0;
            dmenu = "${pkgs.dmenu}/bin/dmenu -p dunst";
            follow = "keyboard";
            font = "Liberation Sans 12";
            format = "<b>%s</b>\n%b";
            geometry = "300x5-30+20";
            horizontal_padding = 8;
            idle_threshold = 120;
            ignore_newline = false;
            indicate_hidden = true;
            line_height = 0;
            markup = "full";
            monitor = 0;
            padding = 8;
            separator_color = "#585858";
            separator_height = 2;
            show_age_threshold = 60;
            sort = true;
            startup_notification = true;
            sticky_history = true;
            transparency = 40;
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
            timeout = 10;
          };
          urgency_normal = {
            background = "#181818";
            foreground = "#E3C7AF";
            timeout = 900;
          };
          urgency_critical = {
            background = "#FD5F00";
            foreground = "#282226";
            timeout = 0;
          };
      };
     };

    flameshot.enable = true;

    gpg-agent = {
      enable = true;
      enableSshSupport = true;
    };

    network-manager-applet.enable = true;

    pasystray.enable = true;

    screen-locker = {
      enable = true;
      lockCmd = "i3lock"; # i3lock from nix not working.
      inactiveInterval = 10;
    };

  #  udev.extraRules = ''
  #    SUBSYSTEMS=="usb", ATTRS{idVendor}=="", ATTRS{idProduct}=="", RUN+="/usr/bin/setxkbmap us altgr-intl"
  #      '';

    udiskie = {
      enable = true;
      automount = false;
    };
  };

  xdg = {
    configFile."mimeapps.list".text =
      let mimeapps = {
        "Default Applications" = {
          "application/pdf" = "org.gnome.Evince-previewer.desktop";
        };
      }; in lib.generators.toINI {} mimeapps;

    configFile."gnupg/gpg-agent.conf".text = ''
      enable-ssh-support
      default-cache-ttl 600
      max-cache-ttl 7200
      pinentry-program ${pkgs.pinentry_gnome}/bin/pinentry-gnome3
    '';

    dataFile."applications/emacsclient.desktop".text = ''
      [Desktop Entry]
      Name=Emacsclient
      GenericName=Text Editor
      Comment=Edit text
      MimeType=text/english;text/plain;text/x-makefile;text/x-c++hdr;text/x-c++src;text/x-chdr;text/x-csrc;text/x-java;text/x-moc;text/x-pascal;text/x-tcl;text/x-tex;application/x-shellscript;text/x-c;text/x-c++;
      Exec=${pkgs.emacs}/bin/emacsclient -c -a "" %F
      Icon=emacs
      Type=Application
      Terminal=false
      Categories=Development;TextEditor;
      StartupWMClass=Emacs
      Keywords=Text;Editor;
    '';
  };

  systemd.user.services = lib.mkIf true {
    emacs = {
      Unit = {
        Description = "Emacs: the extensible, self-documenting text editor";
      };
      Service = {
        ExecStart = "${pkgs.emacs}/bin/emacs --fg-daemon";
        ExecStop = "${pkgs.emacs}/bin/emacsclient --eval \"(kill-emacs)\"";
        Restart = "on-failure";
        Environment = ''SSH_AUTH_SOCK="/run/user/%U/gnupg/S.gpg-agent.ssh" PATH="${config.home.profileDirectory}/bin:%h/bin:/usr/local/sbin:/usr/local/bin:/run/current-system/sw/bin:/usr/sbin:/usr/bin:/sbin:/bin"'';
      };
      Install = {
        WantedBy = [ "default.target" ];
      };
    };
  };

}
