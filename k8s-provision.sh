#!/bin/bash

set -x

if [[ ! -f /home/vagrant/.k8s-provision ]];then
  touch /home/vagrant/.k8s-provision

  apt-get update
  curl -fsSL https://deb.nodesource.com/setup_16.x | sudo -E bash -
  apt-get install -y git python3-pip nodejs ruby-full mono-complete golang default-jdk ack-grep neovim
  gem install neovim
  curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
  python3 get-pip.py --force-reinstall
  pip3 install ansible pynvim ruamel.yaml
  pip3 install git+https://github.com/ansible-community/ansible-lint.git
  ansible-galaxy collection install community.general
  echo 'if [[ ! -d ~/.local/bin ]];then export PATH=~/.local/bin:$PATH;fi' | tee -a /home/vagrant/.bashrc
  wget https://github.com/neovim/neovim/releases/download/v0.4.4/nvim.appimage
  chmod 755 nvim.appimage
  mv nvim.appimage /usr/bin/nvim
  cp /vagrant/provisioning/kubernetes/kube_completion.sh /home/vagrant/
  echo 'alias vim=nvim' | tee -a /home/vagrant/.bashrc
  cp -r /vagrant/provisioning /home/vagrant/
  chmod o-w /home/vagrant/provisioning
#  cp -rf /vagrant/vim/.local /home/vagrant/
#  cp -rf /vagrant/vim/.config /home/vagrant/
  if [[ ! -e /vagrant/ssh_key/id_rsa ]]; then ssh-keygen -b 2048 -t rsa -f /vagrant/ssh_key/id_rsa -q -N ""; fi
  chown -R vagrant:vagrant /home/vagrant
  git clone https://github.com/VundleVim/Vundle.vim.git ~/.config/nvim/bundle/Vundle.vim  
  mkdir -p /home/vagrant/.config/nvim
  if [[ -d /home/vagrant/.config/nvim ]];then
    cp /vagrant/vim/.config/nvim/init.vim /home/vagrant/.config/nvim/
  fi
  vim +PluginInstall +qall
  python3 ~/.vim/bundle/youcompleteme/install.py --go-completer
  sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
	         https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  cd ~/.vim/bundle/vimproc.vim && make && cd -
fi
