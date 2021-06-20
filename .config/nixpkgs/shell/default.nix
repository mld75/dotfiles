{ pkgs, config, lib ? pkgs.stdenv.lib, ... }:
let
    myemacs = (pkgs.emacsWithPackages (with (pkgs.emacsPackagesNgGen pkgs.emacs27); [vterm]));
    imgdupes = (pkgs.callPackage ../pkgs/imgdupes {});
in {
  imports = [
    ./zsh.nix
  ];

  home = {
    packages = with pkgs; let
      exe = haskell.lib.justStaticExecutables;

    # Only general usage tools, nothing related to development/programming/programming languages
    in [
      ack
      acpi # for checking battery status on the CLI
      age
      arping
      arp-scan
      aqbanking
      autojump
      ansible
      binutils # for libvterm + emacs
      bmon
      brightnessctl
      cmake # for libvterm + emacs
      cntr
      curl
      dep
      diffpdf
      # (exe haskellPackages.dhall)
      #(exe haskellPackages.dhall-bash)
      #(exe haskellPackages.dhall-json)
      #(exe haskellPackages.dhall-text)
      dmenu
      dnsutils
      docker_compose
      docker-machine
      #emacs26
      myemacs
      entr
      fasd
      fd
      gnupg
      go
#      (exe haskellPackages.matterhorn)
#      (exe haskellPackages.hadolint)
      (exe haskellPackages.nix-derivation) # broken as of 20191021
#      helm # coredump 20.11.2018
      highlight
      hledger
      hledger-ui
      hledger-web
      hledger-iadd
      htop
      icdiff
      iftop
#      imgdupes
      iotop
      jdupes
      less
      libtool # for libvterm + emacs
      libvterm-neovim
      links
#     linphone # only 3.x, not 4.x
      lsof
      magic-wormhole
      minicom
      minisign
      mtr
#      (import fetchFromGitHub {
#        owner = "nmattia";
#        repo = "niv";
#        rev = "fed53d1042f90c98bfed66075ff9203f09bf42d";
#        sha256 = "141944lmmpi06vi3d8z86syviaswyb3cqqd7pgd6ivr6qd6w843m";
#      }).niv
      nixfmt
      nix-index
      nix-prefetch-github
      nettools
      pandoc
      (pass.withExtensions(e: [ e.pass-import  e.pass-otp e.pass-import ]))
      plantuml
      playerctl
      psmisc
      pulsemixer
      qrencode
      restic
      ripgrep
      rmapi
      speedtest-cli
      tcpdump
      terminator
#      (terraform.withPlugins (p: [terraform-provider-libvirt p.aws p.template p.ignition p.local p.null]))
      tmux
      tree
      unzip
      #vagrant
      xz
      youtube-dl
      zbar
      zip
      ];

    sessionVariables = {
      EDITOR = "${myemacs}/bin/emacsclient -t";
      LESS = "-XR --quit-if-one-screen";
      PAGER = "less";
      MANPATH = ":/usr/share/man";
      TERMINAL = "${pkgs.alacritty}/bin/alacritty";
    };
  };

  programs = {
    bat.enable = true;
    broot.enable = true;

    direnv.enable = true;
    fzf.enable = true;
    gh.enable = true;
    gpg = {
      enable = true;
      settings = {
        
      };
    };
    htop.enable = true;
    lsd.enable = true;
    info.enable = true;
    man.enable = true;
    skim.enable = true;

    ssh = {
      enable = true;
      matchBlocks = {
        "rsync.net" = {
          hostname = "ch-s012.rsync.net";
          user = "14210";
        };
        "remarkable" = {
          hostname = "10.11.99.1";
          user = "root";
        };
      };
    };

    vim.enable = true;

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
          "fd"
          "fzf"
          "git"
          "helm"
          "httpie"
          "kubectl"
          "mvn"
          "nix"
          "npm"
          "nvm"
          "pass"
          "terraform"
          "tmux"
          "vagrant"
          "z"
          "zsh-autosuggestions"
        ];
      };
      sessionVariables = {
        KUBECONFIG = "${config.home.homeDirectory}/.kube/config:${config.home.homeDirectory}/.kube/kube-config-fits";
        LESSCHARSET = "UTF-8";
      };
      shellAliases = {
        et = "te";
        cfg = ''git --git-dir="$HOME/.cfg/" --work-tree="$HOME"'';
        linphone = "flatpak run com.belledonnecommunications.linphone";
        magit = ''te --eval "(magit-status)"'';
        jnix-build = "nix-build -E 'with import <nixpkgs> { };  callPackage ./default.nix {}'";
        "xkb-de" = "setxkbmap de nodeadkeys";
        "xkb-us" = "setxkbmap us altgr-intl";
      };
      initExtra = ''
      # fd - cd to selected directory
      cdd() {
        local dir
        dir=$(find ''${1:-.} -path '*/\.*' -prune \
                        -o -type d -print 2> /dev/null | fzf +m) &&
        cd "$dir"
      }
      dired() { te --eval "(dired \"''${1:-.}\")" }
      '';
    };
  };

  xdg = {
    dataFile."applications/emacsclient.desktop".text = ''
      [Desktop Entry]
      Name=Emacsclient
      GenericName=Text Editor
      Comment=Edit text
      MimeType=text/english;text/plain;text/x-makefile;text/x-c++hdr;text/x-c++src;text/x-chdr;text/x-csrc;text/x-java;text/x-moc;text/x-pascal;text/x-tcl;text/x-tex;application/x-shellscript;text/x-c;text/x-c++;
      Exec=${myemacs}/bin/emacsclient -c -a "" %F
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
        ExecStart = "${myemacs}/bin/emacs --fg-daemon";
        ExecStop = "${myemacs}/bin/emacsclient --eval \"(kill-emacs)\"";
        Restart = "on-failure";
        Environment = ''SSH_AUTH_SOCK="/run/user/%U/gnupg/S.gpg-agent.ssh" PATH="${config.home.profileDirectory}/bin:%h/bin:/usr/local/sbin:/usr/local/bin:/run/wrappers/bin:/run/current-system/sw/bin:/usr/sbin:/usr/bin:/sbin:/bin"'';
      };
      Install = {
        WantedBy = [ "default.target" ];
      };
    };
  };
}
