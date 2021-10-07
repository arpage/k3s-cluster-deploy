#!/bin/bash

###
### First time thru, after installing the master node:
### Make sure we have global and local kubeconfig files
### test server access
###

export KONF_FILE=config
export KONF_DIR=~/.kube
export KONF_ETC_DIR=/etc/rancher/k3s
export KONF_ETC_FILE=k3s.yaml

export GLOBAL_KONFIG=$KONF_ETC_DIR/$KONF_ETC_FILE
export KUBECONFIG=$KONF_DIR/$KONF_FILE

if [ ! -f $KUBECONFIG ]; then
  echo mkdir -p $KONF_DIR
  echo cp kubeconfig $KUBECONFIG
else
  echo kubeconfig exists as $KUBECONFIG
fi

if [ ! -f $GLOBAL_KONFIG ]; then
  echo sudo mkdir -p $KONF_ETC_DIR
  echo sudo cp kubeconfig $GLOBAL_KONFIG
else
  echo global kubeconfig exists as $GLOBAL_KONFIG
fi

if [ ! -z `which kubectl` ]; then
   echo sudo snap install kubectl --classic
fi

# Test your cluster with:
kubectl config set-context default
kubectl get node -o wide
