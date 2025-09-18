#!/bin/bash

## Metallb ##

kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.15.2/config/manifests/metallb-native.yaml
# or
kubectl apply -f metallb-native.yaml

kubectl -n metallb-system get pods

kubectl apply -f metallb-ipaddresspool.yaml

## ingress-nginx ##

kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.13.2/deploy/static/provider/cloud/deploy.yaml
# or
kubectl apply -f ingress-nginx.yaml

kubectl get pods -n ingress-nginx
kubectl get svc -n ingress-nginx

## cert-manager ##

kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.18.2/cert-manager.yaml
# or
kubectl apply -f cert-manager.yaml

kubectl get pods -n cert-manager

kubectl apply -f cluster-issuer.yaml

kubectl describe clusterissuer letsencrypt-staging

## app ##

kubectl create ns my-app

kubectl apply -f app-deployment.yaml
