#!/bin/bash

_HOST_=`c`

sudo curl -O http://172.16.164.99/cfssl/etcd-root-ca.pem

sudo curl -O http://172.16.164.99/cfssl/k8s-node1-peer.pem
sudo curl -O http://172.16.164.99/cfssl/k8s-node1-peer-key.pem

sudo curl -O http://172.16.164.99/cfssl/k8s-node1.pem
sudo curl -O http://172.16.164.99/cfssl/k8s-node1-key.pem

sudo curl -O http://172.16.164.99/cfssl/client.pem
sudo curl -O http://172.16.164.99/cfssl/client-key.pem
