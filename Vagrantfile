# -*- mode: ruby -*-
# vi: set ft=ruby:

Vagrant.configure("2") do |config|

  
  k8s_port = '6443'

  servers=[
    {
      :hostname => "k8s-master",
      :box => "bento/ubuntu-18.04",
      :ip => "192.168.0.211",
      :ssh_port => '2211',
    },
    {
      :hostname => "k8s-node1",
      :box => "bento/ubuntu-18.04",
      :ip => "192.168.0.212",
      :ssh_port => '2212'
    },
    {
      :hostname => "k8s-node2",
      :box => "bento/ubuntu-18.04",
      :ip => "192.168.0.213",
      :ssh_port => '2213'
    },
    {
      :hostname => "gitlab",
      :box => "bento/ubuntu-18.04",
      :ip => "192.168.0.214",
      :ssh_port => '2214'
    }
  ]

  servers.each do |machine|

    config.vm.define machine[:hostname] do |node|
      node.vm.box = machine[:box]
      node.vm.hostname = machine[:hostname]
      
      node.vm.network :public_network, ip: machine[:ip]
      node.vm.network "forwarded_port", guest: 22, host: machine[:ssh_port], id: "ssh"

      node.vm.provider :virtualbox do |v|
        v.customize ["modifyvm", :id, "--memory", 3060, "--cpus", 2, "--cpuexecutioncap", 60]
        v.customize ["modifyvm", :id, "--name", machine[:hostname]]
      end
    end
  end

   config.vm.provision "file", source: "ssh_key/id_rsa", destination: "/home/vagrant/.ssh/"
  config.vm.provision "file", source: "ssh_key/id_rsa.pub", destination: "/home/vagrant/.ssh/"

  config.vm.provision "shell",
    inline: "set -x && \
             sed -i 's/^#.*StrictHostKeyChecking ask/    StrictHostKeyChecking no/' /etc/ssh/ssh_config && \
             if [[ $(cat /vagrant/ssh_key/id_rsa.pub | xargs -I {} grep {} ~/.ssh/authorized_keys | wc -l) -eq 0 ]]; then cat /vagrant/ssh_key/id_rsa.pub >> /home/vagrant/.ssh/authorized_keys; fi && \
             chmod 644 /home/vagrant/.ssh/id_rsa.pub && \
             chmod 600 /home/vagrant/.ssh/id_rsa && \
             apt update && apt upgrade -y && apt install build-essential zlib1g-dev libffi-dev linux-headers-$(uname -r) libffi-dev -y && \
             wget https://www.openssl.org/source/openssl-1.1.1k.tar.gz && \
             tar -zxvf openssl-1.1.1k.tar.gz && cd openssl-1.1.1k && \
             ./config --prefix=/opt/openssl --openssldir=/opt/openssl && \ 
             make && make install && cd ~ && \
             wget https://www.python.org/ftp/python/3.8.10/Python-3.8.10.tgz && \
             tar -zxvf Python-3.8.10.tgz && cd Python-3.8.10 && \
             ./configure --enable-optimizations --with-openssl=/opt/openssl && make install

            "
  config.vm.define "k8s-master" do |node1|
    node1.vm.provision "shell",
      inline: "pip3 install cffi ansible && \
               echo 'if [[ -d ~/.local/bin ]];then export PATH=~/.local/bin:$PATH;fi' | tee -a ~/.bashrc && source ~/.bashrc && \
               cp -r /vagrant/provisioning/ansible /home/vagrant/ && \
               chmod o-w /home/vagrant/ansible && \
               chown -R vagrant:vagrant /home/vagrant/ansible && \
               if [[ ! -e /vagrant/ssh_key/id_rsa ]]; then ssh-keygen -b 2048 -t rsa -f /vagrant/ssh_key/id_rsa -q -N ""; fi 
              "
    node1.vm.network "forwarded_port", guest: k8s_port, host: k8s_port
  end
end
