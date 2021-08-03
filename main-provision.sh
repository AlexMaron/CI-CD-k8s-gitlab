#!/bin/bash

HOME_DIR="/home/vagrant"

set -x

# If else statement for idempotent environment
if [[ ! -f /home/vagrant/.main-provision ]];then
  touch /home/vagrant/.main-provision
  sed -i 's/^#.*StrictHostKeyChecking ask/    StrictHostKeyChecking no/' /etc/ssh/ssh_config
fi

  # Add ssh key user to vagrant user
  if [[ ! -f $HOME_DIR/.ssh/id_rsa ]];then
    if [[ ! -d $HOME_DIR/.ssh ]];then
      mkdir -p $HOME_DIR/.ssh
    fi
    cp /vagrant/ssh_key/* $HOME_DIR/.ssh/
  fi
  chmod 644 $HOME_DIR/.ssh/id_rsa.pub
  chmod 600 $HOME_DIR/.ssh/id_rsa
  chown vagrant:vagrant $HOME_DIR/.ssh/*
  if [[ $(cat /vagrant/ssh_key/id_rsa.pub | xargs -I {} grep {} ~/.ssh/authorized_keys | wc -l) -eq 0 ]];then 
    cat /vagrant/ssh_key/id_rsa.pub >> /home/vagrant/.ssh/authorized_keys
  fi
  
  # Add ssh keys to root user
  if [[ ! -f /root/.ssh/id_rsa ]];then
    if [[ ! -d /root/.ssh ]];then
      mkdir -p /root/.ssh
    fi
    cp /vagrant/ssh_key/* /root/.ssh/
  fi
  chmod 644 /root/.ssh/id_rsa.pub
  chmod 600 /root/.ssh/id_rsa
  if [[ $(cat /vagrant/ssh_key/id_rsa.pub | xargs -I {} grep {} /root/.ssh/authorized_keys | wc -l) -eq 0 ]];then 
    cat /vagrant/ssh_key/id_rsa.pub >> /root/.ssh/authorized_keys; 
  fi

## LVM2 configuration

#DATA_DIR="/mnt/data"
#VG_NAME="minio-vg"
#PARTITION="/dev/${VG_NAME}/data"
#
#if [[ $(lsblk | grep $DATA_DIR | wc -l ) -lt 1 ]];then
#  for i in b c d;do
#    echo ';' | sfdisk /dev/sd$i
#    if [[ `pvdisplay -s | grep sd${i}1 | wc -l` -lt 1 ]];then
#      pvcreate /dev/sd${i}1
#    fi
#  done
#  vgcreate $VG_NAME /dev/sdb1
#  vgextend $VG_NAME /dev/sdc1 /dev/sdd1
#  for i in {1..3};do
#    lvcreate -l $(vgdisplay $VG_NAME | sed -En 's/\s{2,}Total\sPE\s{2,}//p' | awk '{print $1 = $1 / 3}') -n data${i} $VG_NAME
#    if [[ ! -d "/mnt/data${i}" ]];then
#      mkdir -p $DATA_DIR${i}
#      mkfs.ext4 ${PARTITION}${i}
#    fi
#    mount ${PARTITION}${i} ${DATA_DIR}${i}
#  done
#fi
