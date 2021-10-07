#!/bin/bash

###
### First time thru, after installing the master node:
### Make sure we have global and local kubeconfig files
### test server access
###

#export KONF_FILE=config
#export KONF_DIR=~/.kube
export KONF_ETC_DIR=/etc/rancher/k3s
export KONF_ETC_FILE=k3s.yaml

export GLOBAL_KONFIG=$KONF_ETC_DIR/$KONF_ETC_FILE

if [ ! -f ~/.kube/config ]; then
  mkdir -p ~/.kube
  cp kubeconfig ~/.kube/config
else
  echo kubeconfig exists as ~/.kube/config
fi

export KUBECONFIG=~/.kube/config

#if [ ! -f $GLOBAL_KONFIG ]; then
#  echo sudo mkdir -p $KONF_ETC_DIR
#  echo sudo cp kubeconfig $GLOBAL_KONFIG
#else
#  echo global kubeconfig exists as $GLOBAL_KONFIG
#fi

if [ -z `which kubectl` ]; then
   sudo snap install kubectl --classic
fi

# Test your cluster with:
kubectl config set-context default
kubectl get node -o wide
