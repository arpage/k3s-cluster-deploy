#!/bin/sh

#export install_k3s_version=v1.19.15+k3s2
export k3s_token=`ssh pi sudo cat /var/lib/rancher/k3s/server/node-token `
export k3s_url=https://192.168.1.124:6443
#curl -sfL https://get.k3s.io | K3S_URL=$k3s_url K3S_TOKEN=$k3s_token INSTALL_K3S_VERSION=$install_k3s_version sh -
curl -sfL https://get.k3s.io | K3S_URL=$k3s_url K3S_TOKEN=$k3s_token sh -
