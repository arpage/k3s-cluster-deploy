#!/bin/bash

###
### If ~/.kube exists, prompt the user to remove or rename it, since we are assuming a new cluster installation,
### and we don't want to start out with a confused set of k8s config files.
###
if [ -f  ~/.kube ]; then
   echo
   echo "   It looks like you have some kubectl config files in ~/.kube"
   echo "   Please rename or remove ~/.kube and re-run this file"
   echo
   exit 1
fi
if [ ! -z "$KUBECONFIG" ]; then
   echo
   echo "   It looks like you have KUBECONFIG set (value is: '$KUBECONFIG')."
   echo "   Please remove the environment variable, and re-run this file"
   echo
   exit 1
fi

###
### If we don't have kubectl in our path, try to install it:
###
if [ -z `which kubectl` ]; then
   sudo snap install kubectl --classic
fi
if [ -z `which kubectl` ]; then
   echo
   echo "   We failed to install kubectl w/ snap.  Please investigate how to install kubectl on this host"
   echo
   exit 1
fi

###
### When doing installs via k3sup, RSA keys don't seem to yield a successful install.
### Therefore, we create a new ECDSA key specifically for the k3sup install.
###
export KEY_TYPE=ecdsa
export SSH_KEY=~/.ssh/id_k3s

###
### Create a new key, just for this k3s installation process.
### You can remove it when you are done installing if you want to.
###
if [ ! -f $SSH_KEY ]; then
  ssh-keygen -t $KEY_TYPE -f $SSH_KEY -N ""
fi

###
### When doing installs via k3sup, I've had best luck when the username matches
### on all the hosts where we are installing nodes.  I create the user on the remote
### hosts before beginning the k3sup install process.   In this case, I used "pi"
### since 2 of the 4 nodes I was installing are running rpi hardware.
###
export REMOTE_USER=pi

###
### We need to know the master node's IP address for each install:
###
export MAIN_NODE=192.168.1.124

###
### Copy the new key to each host we want to create a node on.
### Then install either a master or worker node on each host.
###
for REMOTE_HOST in 192.168.1.124 192.168.1.129 192.168.1.131 192.168.1.138; do

   ssh-copy-id -i $SSH_KEY $REMOTE_USER@$REMOTE_HOST

   if [ $MAIN_NODE = $REMOTE_HOST ]; then

      ./k3sup-node-deploy.sh $MAIN_NODE $REMOTE_USER $SSH_KEY
      mkdir -p ~/.kube
      cp kubeconfig ~/.kube/config

   else

      ./k3sup-node-deploy.sh $MAIN_NODE $REMOTE_USER $SSH_KEY $REMOTE_HOST
      sleep 5

   fi

   echo "========================= [ $REMOTE_HOST Installed ] ==========================================="
   echo
done

if [ -z "$KUBECONFIG" ]; then
   export KUBECONFIG=~/.kube/config
fi

# Test your cluster with:
kubectl config set-context default
kubectl get node -o wide

