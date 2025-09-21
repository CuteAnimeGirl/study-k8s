#!/bin/bash

## Metallb ##

kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.15.2/config/manifests/metallb-native.yaml
# or kubectl apply -f metallb-native.yaml

kubectl -n metallb-system get pods

kubectl apply -f metallb-config.yaml

## ingress-nginx ##

kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.13.2/deploy/static/provider/cloud/deploy.yaml
# or kubectl apply -f ingress-nginx.yaml

kubectl get pods -n ingress-nginx
kubectl get svc -n ingress-nginx

## longhorn ##

longhornctl --kube-config ~/.kube/config --image longhornio/longhorn-cli:v1.9.1 install preflight

helm repo add longhorn https://charts.longhorn.io
helm repo update
helm install longhorn longhorn/longhorn --namespace longhorn-system --create-namespace

kubectl get pods -n longhorn-system

kubectl create -f longhorn-custom-storageclass.yaml

## app ##

kubectl apply -f app1.yaml -f app2.yaml -f app-ingress.yaml
#kubectl delete -f app1.yaml -f app2.yaml -f app-ingress.yaml -f storage-class.yaml

