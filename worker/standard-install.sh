#!/bin/sh
echo export K3S_TOKEN="<get from master node w/ 'sudo cat /var/lib/rancher/k3s/server/node-token'>"
echo export K3S_URL="https://<master_node_ip>:6443"
echo 'curl -sfL https://get.k3s.io | sudo K3S_URL=$K3S_URL K3S_TOKEN=$K3S_TOKEN sh -'
