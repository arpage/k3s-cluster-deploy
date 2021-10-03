#!/bin/sh
echo 'curl -sfL https://get.k3s.io | K3S_TOKEN=<SOMETHING GOES HERE> sh -s server --cluster-init'
echo 'mkdir ~/.kube/'
echo 'sudo cp /etc/rancher/k3s/k3s.yaml ~/.kube/config'
echo 'sudo chmod 600 ~/.kube/config'
echo 'export KUBECONFIG=~/.kube/config'
echo
echo 'See:  https://rancher.com/docs/k3s/latest/en/installation/ha-embedded/'

