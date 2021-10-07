#!/bin/bash

export REMOTE_USER=pi

export MAIN_NODE=192.168.1.124

export SSH_KEY=~/.ssh/id_k3s-install

###
### Create a new key, just for this k3s installation process.
### We can remove it when we're done:
###

if [ ! -f $SSH_KEY ]; then
  ssh-keygen -t rsa -f $SSH_KEY -N ""
fi

###
### Copy the new key to each node we want to create (main and worker nodes):
###
for REMOTE_HOST in 192.168.1.124 192.168.1.129 192.168.1.131 192.168.1.138; do

   ssh-copy-id -i $SSH_KEY $REMOTE_USER@$REMOTE_HOST

   if [ $MAIN_NODE = $REMOTE_HOST ]; then

      echo ./k3sup-node-deploy.sh $MAIN_NODE $REMOTE_USER $SSH_KEY

   else

      echo ./k3sup-node-deploy.sh $MAIN_NODE $REMOTE_USER $SSH_KEY $REMOTE_HOST

   fi

   ./post-install.sh

done
