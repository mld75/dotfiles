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
