#!/bin/sh

kubectl create -f pod.yaml
sleep 5
kubectl exec build -- git clone --branch=build https://github.com/hyphenation/tex-hyphen
kubectl exec build -- sh tex-hyphen/build/build.sh
