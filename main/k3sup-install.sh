#!/bin/sh

export SERVER_IP=192.168.1.124

#export NODE_IP=192.168.1.131
export NODE_IP=192.168.1.138

export SERVER_USER=pi
#export SERVER_USER=straypacket

export SSH_KEY=~/.ssh/id_ecdsa

if [ -z $NODE_IP ]; then
   k3sup install --ip $SERVER_IP --user $SERVER_USER --ssh-key $SSH_KEY --local-path ./kubeconfig
else
   k3sup join --ip $NODE_IP --server-ip $SERVER_IP --user $SERVER_USER --ssh-key $SSH_KEY
fi

#echo 'curl -sfL https://get.k3s.io | sh -'
#echo 'mkdir ~/.kube/'
#echo 'sudo cp /etc/rancher/k3s/k3s.yaml ~/.kube/config'
#echo 'sudo chmod 600 ~/.kube/config'
#echo 'export KUBECONFIG=~/.kube/config'
#echo
#echo 'See:  https://rancher.com/docs/k3s/latest/en/quick-start/'
