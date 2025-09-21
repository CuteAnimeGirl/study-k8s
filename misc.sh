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

## Storage ##

kubectl apply -f storage-class.yaml

## app ng ##

kubectl apply -f app1.yaml -f app2.yaml -f app-ingress.yaml
#kubectl delete -f app1.yaml -f app2.yaml -f app-ingress.yaml -f storage-class.yaml





helm repo add kubernetes-dashboard https://kubernetes.github.io/dashboard/
helm upgrade --install kubernetes-dashboard kubernetes-dashboard/kubernetes-dashboard --create-namespace --namespace kubernetes-dashboard