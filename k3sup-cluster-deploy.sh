#!/bin/bash

### ============================================================================================================
###
### Install k3s on one or more nodes using k3sup - see the notes below on $remote_hosts, $MAIN_NODE, and
### $REMOTE_USER before running.
###
### Comment out the following line to actually run commands, rather than echo them.  Would recommend running
### once or twice to see the actual commands that are generated, before commenting it out.
###export echo=echo

### ============================================================================================================
###
### Script requirements:
### 1. Not being run from any of the hosts in the $remote_hosts list
### 2. Has snap available to install packages, if kubectl is not already available in the path
### 3. uid running this script has sudo access.
### 4. passwordless sudo access on each of the hosts in the $remote_host list.
###

### ============================================================================================================
###
### $MAIN_NODE will be the master node's IP address:
###
### $remote_hosts will be the list of all nodes (server AND worker) we want to install k3s on.
### We assume only one server/master node in this script (see $MAIN_NODE)
###
export MAIN_NODE=192.168.1.124

#remote_hosts=( $MAIN_NODE 192.168.1.129 192.168.1.146 192.168.1.131 192.168.1.138 )
remote_hosts=( 192.168.1.131 )

###
### When doing installs via k3sup, I've had best luck when the username matches
### on all the hosts where we are installing nodes.  I create the user on the remote
### hosts before beginning the k3sup install process.   In this case, I used "pi"
### since 3 of the 5 nodes I was installing are running rpi hardware.
###
export REMOTE_USER=pi

###
### When doing installs via k3sup, RSA keys don't seem to yield a successful install.
### Therefore, we create a new ECDSA key specifically for the k3sup install.
###
export KEY_TYPE=ecdsa
export SSH_KEY=~/.ssh/id_k3sup

###
### We can specify a specific versiob of k3s to install, if we do not want the latest version for some reason.
### A typical use case would be installing a new worker node at some date later than the original install,
### after the latest version of k3s has been updated.   In this case we might modify this script as follows:
###
### export K3S_VERSION=v1.19.15+k3s2
### remote_hosts=( 192.168.1.220 192.168.1.221 )
###
### Note that K3S_VERSION cannot be used when installing the main/master node - this script will always pull
### the latest version of k3s from rancher during the master/main node installation.
###

echo
echo "=== Beginning Pre-install Configuration"
echo

### ============================================================================================================
###
### This script assumes (requires, probably) that we're not running it from one of the nodes we are installing
### k3s onto.  So, we probably don't have kubectl installed locally.
###
### If we don't have kubectl in our path, try to install an agnostic version w/ snap.
###
if [ -z `which kubectl` ]; then
   echo
   echo Trying to install kubectl with snap
   echo
   $echo sudo snap install kubectl --classic
fi
if [ x$echo = x ]; then
  if [ -z `which kubectl` ]; then
    echo
    echo "  Error: We failed to install kubectl w/ snap.  Please investigate how to install kubectl on this host"
    echo
    exit 1
  fi
fi

### ============================================================================================================
###
### Create a new key, just for this k3s installation process.
###
if [ ! -f $SSH_KEY ]; then
  $echo ssh-keygen -t $KEY_TYPE -f $SSH_KEY -N ""
fi

### ============================================================================================================
###
### If ~/.kube exists, prompt the user to remove or rename it, since we are assuming a new cluster installation,
### and we don't want to start out with a confused set of k8s config files.
###
if [ -d  ~/.kube ]; then
   echo
   echo "Error: It looks like you have some kubectl config files in ~/.kube"
   echo "       Please rename or remove ~/.kube and re-run this file"
   echo
   $echo exit 1
  fi
  if [ ! -z "$KUBECONFIG" ]; then
   echo
   echo "   Error: It looks like you have KUBECONFIG set (value is: '$KUBECONFIG')."
   echo "          Please remove the environment variable, and re-run this file"
   echo
   $echo exit 1
fi

echo
echo "=== Beginning Cluster Installation"
echo

### ============================================================================================================
###
### Copy the new key to each host we want to create a node on.
### Then install either a master or worker node on each host.
###
for REMOTE_HOST in ${remote_hosts[*]}; do

   $echo ssh-copy-id -i $SSH_KEY $REMOTE_USER@$REMOTE_HOST

   if [ $MAIN_NODE = $REMOTE_HOST ]; then

      echo "Running: " ./k3sup-node-deploy.sh $MAIN_NODE $REMOTE_USER $SSH_KEY
      ./k3sup-node-deploy.sh $MAIN_NODE $REMOTE_USER $SSH_KEY

      ###
      ### If we're installing the master node, use the kubeconfig generated by k3sup to
      ### create our local ~/.kube/config file
      ###
      $echo mkdir -p ~/.kube
      $echo cp kubeconfig ~/.kube/config

   else

      echo "Running: " ./k3sup-node-deploy.sh $MAIN_NODE $REMOTE_USER $SSH_KEY $REMOTE_HOST $K3S_VERSION
      ./k3sup-node-deploy.sh $MAIN_NODE $REMOTE_USER $SSH_KEY $REMOTE_HOST $K3S_VERSION
      $echo sleep 5

   fi

   echo "========================= [ $REMOTE_HOST Installed ] ==========================================="
   echo
done

if [ -z "$KUBECONFIG" ]; then
   export KUBECONFIG=~/.kube/config
fi

### ============================================================================================================
###
### Test your cluster with:
###
$echo kubectl config set-context default
$echo kubectl get node -o wide

