#!/bin/bash
set -euo pipefail

declare -r FISH="/usr/bin/fish"

sudo apt purge \
	libreoffice \
	thunderbird
sudo apt update 
sudo apt upgrade
# Not in Nix:
#   - fasd
#   - autojump
sudo apt install -y \
	autojump \
	fasd \
        fish \
	git \
	network-manager-openvpn-gnome \
	fonts-powerline \
	virtualbox \

# Setup configuration
git clone --bare --recurse-submodules https://github.com/j0xaf/dotfiles.git "$HOME/.cfg"
git --git-dir="$HOME/.cfg" --work-tree="$HOME" checkout
git --git-dir="$HOME/.cfg" --work-tree="$HOME" config --local status.showUntrackedFiles no

# Install Nix
if ! command -v nix > /dev/null; then
  sudo apt -y install curl gpg
  gpg --keyserver pool.sks-keyservers.net --recv-keys B541D55301270E0BCF15CA5D8170B4726D7198DE
  TMP_NIX_DIR=$(mktemp -d -t nix.XXX)
  curl -o ${TMP_NIX_DIR}/install https://nixos.org/nix/install
  curl -o ${TMP_NIX_DIR}/install.sig https://nixos.org/nix/install.sig
  gpg --verify ${TMP_NIX_DIR}/install.sig
  sh ${TMP_NIX_DIR}/install --daemon

  if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
    . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
  fi
else
  echo "Nix already installed."
fi

# Install Home-Manager
if ! command -v home-manager > /dev/null; then
  HM_PATH=https://github.com/rycee/home-manager/archive/master.tar.gz
  nix-shell $HM_PATH -A install
else
  echo "home-manager already installed."
fi

# Install OMF
if [ ! -d ~/.local/share/omf ]; then
  sudo apt install autojump
  curl -L https://get.oh-my.fish | fish
else
  echo "OMF already installed."
fi
if [[ -x ${FISH} ]]; then
  sudo chsh -s "${FISH}" $USER
fi

# Install Docker
if ! dpkg -s docker-ce > /dev/null; then
  sudo apt-get install -y \
      apt-transport-https \
      ca-certificates \
      curl \
      software-properties-common

  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
  if ! gpg --keyring /etc/apt/trusted.gpg --no-default-keyring -k --fingerprint docker@docker.com | grep "9DC8 5822 9FC7 DD38 854A  E2D8 8D81 803C 0EBF CD88" > /dev/null; then
  	echo "Invalid key docker@docker.com. Check https://docs.docker.com/install/linux/docker-ce/ubuntu/#set-up-the-repository."
	exit -1
  fi
  sudo add-apt-repository \
     "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
     $(lsb_release -cs) \
     stable"

  sudo apt update
  sudo apt install -y docker-ce
else
  echo "docker-ce is already installed,"
fi
sudo adduser $USER docker

# KVM
sudo apt install qemu-kvm
sudo adduser $USER kvm
if ! kvm-ok | grep "/dev/kvm exists"; then
  echo "WARN: /dev/kvm does not exist. Reason may be that VT / virtualization is disabled in BIOS."
fi
