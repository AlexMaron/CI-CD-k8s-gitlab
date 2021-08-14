# -*- mode: ruby -*-
# vi: set ft=ruby:
 
require "fileutils"

# Variables
#VAGRANT_ROOT              = File.dirname(File.expand_path((__FILE__))
#VAGRANT_DISKS_DIRECTORY   = "disks"
#VAGRANT_CONTROLLER_NAME   = "Virtual I/O SCSI controller"
#VAGRANT_CONFTROLLER_TYPE  = "virtio-scsi"
MEMORY		        	  = 4096
CPUS			          = 3
CPU_UTILIZATION	    	  = 50
ADDITIONAL_DISKS    	  = 2
DISK_SIZE                 = 8192
SUBNET                    = "192.168.88."
BOX                       = "bento/ubuntu-20.04"

  #local_disks = [
  #  { :filename => "disk1", :size => DISK_SIZE, :port => 1},
  #  { :filename => "disk2", :size => DISK_SIZE, :port => 2}
  #]

  servers=[
    {
      :hostname => "k8s-master",
      :box => BOX,
      :ip => "#{SUBNET}204",
      :ssh_port => '2210',
      :persistent_data => "~/vagrant/persistent_disk/k8s-master.vdi",
    },
    {
      :hostname => "k8s-node1",
      :box => BOX,
      :ip => "#{SUBNET}201",
      :ssh_port => '2211',
      :persistent_data => "~/vagrant/persistent_disk/k8s-node1.vdi",
    },
    {
      :hostname => "k8s-node2",
      :box => BOX,
      :ip => "#{SUBNET}202",
      :ssh_port => '2212',
      :persistent_data => "~/vagrant/persistent_disk/k8s-node2.vdi",
    },
    {
      :hostname => "k8s-node3",
      :box => BOX,
      :ip => "#{SUBNET}203",
      :ssh_port => '2213',
      :persistent_data => "~/vagrant/persistent_disk/k8s-node3.vdi",
    }
  ]

Vagrant.configure("2") do |config|

  #disks_directory = File.join(VAGRANT_ROOT, VAGRANT_DISKS_DIRECTORY)

  servers.each do |machine|

    config.vm.define machine[:hostname] do |node|
      node.vm.box = machine[:box]
      node.vm.hostname = machine[:hostname]
      
      node.vm.network :public_network, ip: machine[:ip]
      node.vm.network "forwarded_port", guest: 22, host: machine[:ssh_port], id: "ssh"
      host = machine[:hostname]
      node.vm.provider :virtualbox do |v|
      #  (1..ADDITIONAL_DISKS).each do |i|
      #    data = "E:/VMDisks/#{host}-data#{i}.vdi"
      #    v.customize ["createhd", "--filename", data, '--size', DISK_SIZE]
      #    v.customize ["storageattach", :id, "--storagectl", "SATA Controller", "--port", i, "--type", "hdd", "--medium", data]
      #  end
        v.customize ["modifyvm", :id, "--memory", MEMORY, "--cpus", CPUS]
        v.customize ["modifyvm", :id, "--name", host]
      end
    end
  end

#  config.vbguest.installer_options = { allow_kernel_upgrade: true }
  #config.vbguest.auto_update = false
  #config.vbguest.no_remote = true
 
  # Pre-provision # k8s-master host
  config.vm.define "k8s-master" do |master|
    master.vm.provision "shell", path: "k8s-provision.sh"
  # Pre-provision # All hosts
  config.vm.provision "shell", path: "main-provision.sh"
     # ansible provision
     # ansible_path = "/vagrant/provisioning/ansible"
     # master.vm.provision "ansible_local" do |disk_provision|
     #   disk_provision.playbook = "#{ansible_path}/minio.yml"
     #     disk_provision.inventory_path = "#{ansible_path}/inventory"
     #     disk_provision.limit = "all"
     # end
  end
end
