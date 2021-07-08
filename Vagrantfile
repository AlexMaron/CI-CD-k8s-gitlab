# -*- mode: ruby -*-
# vi: set ft=ruby:

# Variables
MEMORY			= 4096
CPUS			= 3
CPU_UTILIZATION		= 50
ADDITIONAL_DISKS	= 2
DISK_SIZE               = 8192

Vagrant.configure("2") do |config|

  servers=[
    {
      :hostname => "k8s-node1",
      :box => "bento/ubuntu-18.04",
      :ip => "172.16.0.11",
      :ssh_port => '2211',
      :ceph_port => "18443",
      :persistent_data => "~/vagrant/persistent_disk/k8s-node1.vdi",
    },
    {
      :hostname => "k8s-node2",
      :box => "bento/ubuntu-18.04",
      :ip => "172.16.0.12",
      :ssh_port => '2212',
      :ceph_port => "28443",
      :persistent_data => "~/vagrant/persistent_disk/k8s-node2.vdi",
    },
    {
      :hostname => "k8s-node3",
      :box => "bento/ubuntu-18.04",
      :ip => "172.16.0.13",
      :ssh_port => '2213',
      :ceph_port => "38443",
      :persistent_data => "~/vagrant/persistent_disk/k8s-node3.vdi",
    },
    {
      :hostname => "k8s-master",
      :box => "bento/ubuntu-18.04",
      :ip => "172.16.0.10",
      :ssh_port => '2210',
      :ceph_port => "8443",
      :persistent_data => "~/vagrant/persistent_disk/k8s-master.vdi",
    }
  ]

  servers.each do |machine|

    config.vm.define machine[:hostname] do |node|
      node.vm.box = machine[:box]
      node.vm.hostname = machine[:hostname]
      
      node.vm.network :private_network, ip: machine[:ip],
        auto_config: true,
        virtual__intnet: "k8s-net"
      node.vm.network "forwarded_port", guest: 22, host: machine[:ssh_port], id: "ssh"
      node.vm.network "forwarded_port", guest: 8443, host: machine[:ceph_port]
      host = machine[:hostname]
      node.vm.provider :virtualbox do |v|
        (1..ADDITIONAL_DISKS).each do |i|
          data = "F:/VMDisks/#{host}-data#{i}.vdi"
          v.customize ["createhd","--filename", data, '--size', DISK_SIZE]
          v.customize ["storageattach", :id, "--storagectl", "SATA Controller", "--port", i, "--type", "hdd", "--medium", data]
        end
        v.customize ["modifyvm", :id, "--memory", 4096, "--cpus", 3, "--cpuexecutioncap", 60]
        v.customize ["modifyvm", :id, "--name", machine[:hostname]]
      end
    end
  end

#  config.vbguest.installer_options = { allow_kernel_upgrade: true }
  config.vbguest.auto_update = false
  config.vbguest.no_remote = true

  # Pre-provision # All hosts
  config.vm.provision "shell", path: "main-provision.sh"
  # Pre-provision # k8s-master host
   config.vm.define "k8s-master" do |master|
    master.vm.network "forwarded_port", guest: 9000, host: 9000
    master.vm.network "forwarded_port", guest: 6443, host: 6443
    master.vm.network "forwarded_port", guest: 3000, host: 3000
    for i in 8000..8100
      master.vm.network "forwarded_port", guest: i, host: i
    end
    for s in 30000..30200
      master.vm.network "forwarded_port", guest: s, host: s
    end
    master.vm.provision "shell", path: "k8s-provision.sh"
     # ansible provision
     # ansible_path = "/vagrant/provisioning/ansible"
     # master.vm.provision "ansible_local" do |disk_provision|
     #   disk_provision.playbook = "#{ansible_path}/minio.yml"
     #     disk_provision.inventory_path = "#{ansible_path}/inventory"
     #     disk_provision.limit = "all"
     # end
  end
end
