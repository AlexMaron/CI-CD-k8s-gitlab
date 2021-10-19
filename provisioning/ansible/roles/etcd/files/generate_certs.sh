#!/bin/bash

ETCD_HOSTNAME=( $( cat /etc/hosts | grep -v "127." | cut -d' ' -f2 | grep ${ETCD_HOSTNAME_PREFIX} ) )

HOST_COUNT=0
for i in $( seq 1 `cat /etc/hosts | grep ${ETCD_HOSTNAME_PREFIX} | grep -v "127." | wc -l`);do
  ETCD_HOST_IP=`dig ${ETCD_HOSTNAME[${HOST_COUNT}]} +short`
  echo "{\"CN\":\"${ETCD_HOSTNAME[${HOST_COUNT}]}\",\"hosts\":[\"\"],\"key\":{\"algo\":\"rsa\",\"size\":2048}}" | \
  cfssl gencert \
    -ca=/cfssl/etcd-ca.pem \
    -ca-key=/cfssl/etcd-ca-key.pem \
    -config=/cfssl/ca-config.json \
    -profile=server \
    -hostname="${ETCD_HOST_IP},${ETCD_HOSTNAME[${HOST_COUNT}]}.local,${ETCD_HOSTNAME[${HOST_COUNT}]}" - | \
  cfssljson -bare /cfssl/${ETCD_HOSTNAME[${HOST_COUNT}]};
  let HOST_COUNT="$HOST_COUNT + 1"
done

HOST_COUNT=0
for i in $( seq 1 `cat /etc/hosts | grep ${ETCD_HOSTNAME_PREFIX} | grep -v "127." | wc -l`);do
  ETCD_HOST_IP=`dig ${ETCD_HOSTNAME[${HOST_COUNT}]} +short`
  echo "{\"CN\":\"${ETCD_HOSTNAME[${HOST_COUNT}]}\",\"hosts\":[\"\"],\"key\":{\"algo\":\"rsa\",\"size\":2048}}" | \
  cfssl gencert \
    -ca=/cfssl/etcd-ca.pem \
    -ca-key=/cfssl/etcd-ca-key.pem \
    -config=/cfssl/ca-config.json \
    -profile=peer \
    -hostname="${ETCD_HOST_IP},${ETCD_HOSTNAME[${HOST_COUNT}]}.local,${ETCD_HOSTNAME[${HOST_COUNT}]}" - | \
  cfssljson -bare /cfssl/${ETCD_HOSTNAME[${HOST_COUNT}]}-peer;
  let HOST_COUNT="$HOST_COUNT + 1"
done

echo "{\"CN\":\"client\",\"hosts\":[\"\"],\"key\":{\"algo\":\"rsa\",\"size\":2048}}" | \
cfssl gencert \
  -ca=/cfssl/etcd-ca.pem \
  -ca-key=/cfssl/etcd-ca-key.pem \
  -config=/cfssl/ca-config.json \
  -profile=client - |\
cfssljson -bare /cfssl/client
