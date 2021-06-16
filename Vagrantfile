# -*- mode: ruby -*-
# vi: set ft=ruby:

Vagrant.configure("2") do |config|

  
  k8s_port = '6443'

  servers=[
    {
      :hostname => "node-1",
      :box => "bento/ubuntu-18.04",
      :ip => "10.8.8.11",
      :ssh_port => '2211',
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

   config.vm.provision "file", source: "ssh_key/id_rsa", destination: "/home/vagrant/.ssh/"
  config.vm.provision "file", source: "ssh_key/id_rsa.pub", destination: "/home/vagrant/.ssh/"

 
  config.vm.provision "shell",
    inline: "set -x && \
             sed -i 's/^#.*StrictHostKeyChecking ask/    StrictHostKeyChecking no/' /etc/ssh/ssh_config && \
             if [[ ! -e /vagrant/ssh_key/id_rsa ]]; then ssh-keygen -b 2048 -t rsa -f /vagrant/ssh_key/id_rsa -q -N ""; fi && \ 
             if [[ $(cat /vagrant/ssh_key/id_rsa.pub | xargs -I {} grep {} ~/.ssh/authorized_keys | wc -l) -eq 0 ]]; then cat /vagrant/ssh_key/id_rsa.pub >> /home/vagrant/.ssh/authorized_keys; fi && \
             chmod 644 /home/vagrant/.ssh/id_rsa.pub && \
             chmod 600 /home/vagrant/.ssh/id_rsa
             "

  config.vm.define "node-1" do |node1|
    node1.vm.provision "shell",
      inline: "apt update && apt upgrade -y && \
               apt install linux-headers-$(uname -r) python3-pip -y && \
               curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py && \
               python3 get-pip.py --force-reinstall && \
               rm get-pip.py && \
               pip3 install ansible && \
               cp -r /vagrant/provisioning/ansible /home/vagrant/ && \
               chmod o-w /home/vagrant/ansible && \
               chown -R vagrant:vagrant /home/vagrant/ansible
              "
  end
  config.vm.define "node-1" do |k8sforward|
    k8sforward.vm.network "forwarded_port", guest: k8s_port, host: k8s_port
  end
end
