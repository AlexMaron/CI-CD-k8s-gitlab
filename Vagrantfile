# -*- mode: ruby -*-
# vi: set ft=ruby:

Vagrant.configure("2") do |config|

  
  k8s_port = '6443'

  servers=[
    {
      :hostname => "k8s-master",
      :box => "bento/ubuntu-18.04",
      :ip => "10.8.8.11",
      :ssh_port => '2211',
    },
    {
      :hostname => "k8s-node1",
      :box => "bento/ubuntu-18.04",
      :ip => "10.8.8.12",
      :ssh_port => '2212'
    },
    {
      :hostname => "k8s-node2",
      :box => "bento/ubuntu-18.04",
      :ip => "10.8.8.13",
      :ssh_port => '2213'
    },
    {
      :hostname => "gitlab",
      :box => "bento/ubuntu-18.04",
      :ip => "10.8.8.14",
      :ssh_port => '2214'
    }
  ]

  servers.each do |machine|

    config.vm.define machine[:hostname] do |node|
      node.vm.box = machine[:box]
      node.vm.hostname = machine[:hostname]
      
      node.vm.network :private_network, ip: machine[:ip]
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
             wget https://www.python.org/ftp/python/3.8.10/Python-3.8.10.tgz && \
             tag -zxvf Python-3.8.10.tgz && cd Python-3.8.10 && \
             cd Python-3.8.10 && ./configure --enable-optimizations && make install && \
             update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.8 1
             "

  config.vm.define "k8s-master" do |node1|
    node1.vm.provision "shell",
      inline: "apt update && apt upgrade -y && \
               apt install linux-headers-$(uname -r) python3-pip -y && \
               curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py && \
               python3 get-pip.py --force-reinstall && \
               rm get-pip.py && \
               pip3 install ansible cffi && \
               cp -r /vagrant/provisioning/ansible /home/vagrant/ && \
               chmod o-w /home/vagrant/ansible && \
               chown -R vagrant:vagrant /home/vagrant/ansible && \
               if [[ ! -e /vagrant/ssh_key/id_rsa ]]; then ssh-keygen -b 2048 -t rsa -f /vagrant/ssh_key/id_rsa -q -N ""; fi 
              "
    node1.vm.network "forwarded_port", guest: k8s_port, host: k8s_port
  end
end
