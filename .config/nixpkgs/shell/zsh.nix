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
}
