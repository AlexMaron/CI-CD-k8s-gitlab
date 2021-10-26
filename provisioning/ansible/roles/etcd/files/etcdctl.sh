#!/bin/bash

sudo -u etcd etcdctl --endpoints=https://192.168.88.201:2379 --cacert /etc/ssl/certs/etcd-ca.pem --cert /etc/ssl/certs/client.pem --key /etc/ssl/certs/client-key.pem $@

if [[ $1 == health ]];then
  sudo -u etcd etcdctl --write-out=table endpoint --endpoints=https://192.168.88.201:2379 --cacert /etc/ssl/certs/etcd-ca.pem --cert /etc/ssl/certs/client.pem --key /etc/ssl/certs/client-key.pem --cluster health
fi
