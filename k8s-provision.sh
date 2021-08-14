#!/bin/bash

__home_env="/home/vagrant"

exec > >(tee -i /vagrant/k8s-master.log)
exec 2>&1
set -x

if [[ ! -f ${__home_env}/.k8s-provision ]];then
  apt-get update
  curl -fsSL https://deb.nodesource.com/setup_16.x | sudo -E bash -
  apt-get install -y git python3-pip nodejs ruby-full mono-complete golang default-jdk ack-grep cmake neovim silversearcher-ag
  gem install neovim
  curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
  python3 get-pip.py --force-reinstall
  pip3 install ansible pynvim ruamel.yaml

  # Ansible community libraries start
  pip3 install git+https://github.com/ansible-community/ansible-lint.git
  ansible-galaxy collection install community.general
  ansible-galaxy collection install community.kubernetes
  git clone --recursive https://github.com/kubernetes-client/python.git /tmp/python && cd /tmp/python
  python3 setup.py install && cd -
  # Ansible community libraries end

  echo 'if [[ ! -d ~/.local/bin ]];then export PATH=~/.local/bin:$PATH;fi' | tee -a ${__home_env}/.bashrc
  wget https://github.com/neovim/neovim/releases/download/v0.4.4/nvim.appimage
  chmod 755 nvim.appimage
  mv nvim.appimage /usr/bin/nvim
  cp /vagrant/provisioning/kubernetes/kube_completion.sh ${__home_env}/
  echo 'alias vim=nvim' | tee -a ${__home_env}/.bashrc
  cp -r /vagrant/provisioning ${__home_env}/
  chmod o-w ${__home_env}/provisioning
#  cp -rf /vagrant/vim/.local ${__home_env}/
#  cp -rf /vagrant/vim/.config ${__home_env}/
  if [[ ! -e /vagrant/ssh_key/id_rsa ]]; then ssh-keygen -b 2048 -t rsa -f /vagrant/ssh_key/id_rsa -q -N ""; fi
  git clone https://github.com/VundleVim/Vundle.vim.git ${__home_env}/.config/nvim/bundle/Vundle.vim

  # Neovim configuration start
  if [[ ! -d ${__home_env}/.config/nvim ]];then
    mkdir -p ${__home_env}/.config/nvim
  fi
  if [[ ! -d ${__home_env}/.vim/bundle ]];then
    mkdir -p ${__home_env}/.vim/bundle
  fi
  cp /vagrant/vim/.config/nvim/init.vim ${__home_env}/.config/nvim/
  cd ${__home_env}/.vim/bundle
  git clone https://github.com/tpope/vim-fugitive.git
  git clone https://github.com/vim-syntastic/syntastic.git
  git clone https://github.com/vim-airline/vim-airline.git
  git clone https://github.com/vim-airline/vim-airline-themes.git
  git clone https://github.com/ycm-core/YouCompleteMe.git
  git clone https://github.com/mileszs/ack.vim.git
  git clone https://github.com/nathanaelkane/vim-indent-guides.git
  git clone https://github.com/Shougo/unite.vim.git
  git clone https://github.com/Shougo/vimproc.vim.git
  git clone https://github.com/Shougo/neomru.vim.git
  git clone https://github.com/Shougo/neoyank.vim.git
  git clone https://github.com/xolox/vim-misc.git
  git clone https://github.com/xolox/vim-session.git
  cd -
  python3 ${__home_env}/.vim/bundle/YouCompleteMe/install.py --go-completer
  cd ${__home_env}/.vim/bundle/vimproc.vim && make && cd -
  sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
	        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  # Neovim configuration end

  # TODO add kubernetes autocomplete for vim

  chown -R vagrant:vagrant ${__home_env}
   touch ${__home_env}/.k8s-provision
fi
