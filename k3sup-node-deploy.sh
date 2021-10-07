#!/bin/sh

export SERVER_IP=$1
export TARGET_USER=$2
export SSH_KEY=$3
export NODE_IP=$4

if [ -z "$SERVER_IP" -o -z "$TARGET_USER" -o -z "$SSH_KEY" ]; then
   echo
   echo "   " Syntax is:
   echo "   " `basename $0` "SERVER_IP TARGET_USER SSH_KEY [NODE_IP]"
   echo
   echo "   Prerequisites:"
   echo "   TARGET_USER must exist on both SERVER_IP (and NODE_IP if doing a worker node install)"
   echo "   TARGET_USER must have passwordless sudo permissions on the SERVER_IP (and NODE_IP if doing a worker install) - you can remove this permission after installation is complete"
   echo "   SSH_KEY should be a non-rsa key that allows access to the SERVER_IP (and NODE_IP if doing a worker install)"
   echo
   exit 1
fi

if [ ! -f $SSH_KEY ]; then
   echo
   echo "   File does not exist:  $SSH_KEY"
   echo
   exit 1
fi

echo "   SERVER_IP:   $SERVER_IP"
echo "   TARGET_USER: $TARGET_USER"
echo "   SSH_KEY:     $SSH_KEY"
echo "   NODE_IP:     $NODE_IP"

if [ -z $NODE_IP ]; then
   k3sup install --ip $SERVER_IP --user $TARGET_USER --ssh-key $SSH_KEY --local-path ./kubeconfig
else
   k3sup join --ip $NODE_IP --server-ip $SERVER_IP --user $TARGET_USER --ssh-key $SSH_KEY
fi
