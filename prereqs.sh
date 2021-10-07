#!/bin/bash

export REMOTE_USER=pi
export SSH_KEY=~/.ssh/id_k3s-install

###
### Create a new key, just for this k3s installation process.
### We can remove it when we're done:
###
ssh-keygen -t rsa -f $SSH_KEY -N ""

###
### Copy the new key to each node we want to create (main and worker nodes):
###
for REMOTE_HOST in pi.local.not pi2.local.not cq-eth.local.not hp.local.not; do

   ssh-copy-id -i $SSH_KEY $REMOTE_USER@$REMOTE_HOST

done
