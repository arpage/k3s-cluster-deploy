#!/bin/sh
echo 'export K3S_TOKEN=<SOMETHING_GOES_HERE>'
echo 'export SERVER=https://primary-node-ip:6443'
echo 'curl -sfL https://get.k3s.io | sh -s server --server $SERVER'
echo 'mkdir ~/.kube/'
echo 'sudo cp /etc/rancher/k3s/k3s.yaml ~/.kube/config'
echo 'sudo chmod 600 ~/.kube/config'
echo 'export KUBECONFIG=~/.kube/config'
echo
echo 'See:  https://rancher.com/docs/k3s/latest/en/installation/ha-embedded/'

