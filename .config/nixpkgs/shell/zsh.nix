{ pkgs, config, lib ? pkgs.stdenv.lib, ... }:
{
  programs = {
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
      plugins = [
        {
          name = "zsh-nix-shell";
          file = "nix-shell.plugin.zsh";
          src = pkgs.fetchFromGitHub {
            owner = "chisui";
            repo = "zsh-nix-shell";
            rev = "v0.1.0";
            sha256 = "0snhch9hfy83d4amkyxx33izvkhbwmindy0zjjk28hih1a9l2jmx";
          };
        }
      ];
      sessionVariables = {
        KUBECONFIG = "${config.home.homeDirectory}/.kube/config:${config.home.homeDirectory}/.kube/kube-config-fits";
        KEYID="0xB4B35E233D57B38B";
        LEDGER_FILE="${config.home.homeDirectory}/finance/2020.journal";
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
      # cdd - cd to selected directory
      cdd() {
        local dir
        dir=$(find ''${1:-.} -path '*/\.*' -prune \
                        -o -type d -print 2> /dev/null | fzf +m) &&
        cd "$dir"
      }
      dired() { te --eval "(dired \"''${1:-.}\")" }
      secret () {
        output=~/"''${1}".$(date +%s).enc
        gpg --encrypt --armor --output ''${output} -r ''${KEYID} "''${1}" && echo "''${1} -> ''${output}"
      }
      reveal () {
        output=$(echo "''${1}" | rev | cut -c16- | rev)
        gpg --decrypt --output ''${output} "''${1}" && echo "''${1} -> ''${output}"
      }
      '';
    };
  };
}
