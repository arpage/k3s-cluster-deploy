#!/bin/sh
curl -sLS https://get.k3sup.dev | sh
sudo install k3sup /usr/local/bin/

k3sup --help

echo "Check here for details: https://github.com/alexellis/k3sup"
