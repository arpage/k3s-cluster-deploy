#!/bin/sh

#export install_k3s_version=v1.19.15+k3s2
export server_user=pi
export server_ip=192.168.1.124

ssh ${server_user}@$server_ip sudo cat /etc/rancher/k3s/k3s.yaml > config
sed -i "s/127.0.0.1/$server_ip/" config
chmod 600 config
#mkdir ~/.kube
#mv config ~/.kube

export k3s_token=`ssh ${server_user}@$server_ip sudo cat /var/lib/rancher/k3s/server/node-token`
export k3s_url=https://$server_ip:6443

if [ x$install_k3s_version != x ]; then
   echo "curl -sfL https://get.k3s.io | K3S_URL=$k3s_url K3S_TOKEN=$k3s_token INSTALL_K3S_VERSION=$install_k3s_version sh -"
else
   echo "curl -sfL https://get.k3s.io | K3S_URL=$k3s_url K3S_TOKEN=$k3s_token sh -"
fi

cat config

