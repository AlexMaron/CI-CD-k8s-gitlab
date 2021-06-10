# -*- mode: ruby -*-
# vi: set ft=ruby:

Vagrant.configure("2") do |config|

  servers=[
    {
      :hostname => "node-1",
      :box => "bento/ubuntu-18.04",
      :ip => "10.8.8.11",
      :ssh_port => '2211'
    },
    {
      :hostname => "node-2",
      :box => "bento/ubuntu-18.04",
      :ip => "10.8.8.12",
      :ssh_port => '2212'
    },
    {
      :hostname => "node-3",
      :box => "bento/ubuntu-18.04",
      :ip => "10.8.8.13",
      :ssh_port => '2213'
    }
  ]

  servers.each do |machine|

    config.vm.define machine[:hostname] do |node|
      node.vm.box = machine[:box]
      node.vm.hostname = machine[:hostname]
      
      node.vm.network :private_network, ip: machine[:ip]
      node.vm.network "forwarded_port", guest: 22, host: machine[:ssh_port], id: "ssh"

      node.vm.provider :virtualbox do |v|
        v.customize ["modifyvm", :id, "--memory", 2048, "--cpus", 2, "--cpuexecutioncap", 60]
        v.customize ["modifyvm", :id, "--name", machine[:hostname]]
      end
    end
  end
  
  config.vm.provision "shell",
    inline: "set -x && \
             cat /vagrant/ssh_key/id_rsa.pub >> /home/vagrant/.ssh/authorized_keys 
             "

  config.vm.provision "file", source: "ssh_key/id_rsa", destination: "/home/vagrant/.ssh/"
  config.vm.provision "file", source: "ssh_key/id_rsa.pub", destination: "/home/vagrant/.ssh/"

  config.vm.define "node-1" do |node1|
    node1.vm.provision "shell",
      inline: "apt install ansible -y"
  end
end
