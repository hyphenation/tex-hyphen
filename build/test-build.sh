#!/bin/sh

kubectl create -f pod.yaml
while test z = z"`kubectl get pod build | grep -F Running`"; do sleep 1; done

kubectl exec build -- git clone --branch=build https://github.com/hyphenation/tex-hyphen
kubectl exec build -- sh tex-hyphen/build/build.sh
