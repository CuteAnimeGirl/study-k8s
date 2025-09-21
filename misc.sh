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

helm upgrade --install longhorn longhorn/longhorn --namespace longhorn-system --create-namespace

kubectl get pods -n longhorn-system

kubectl create -f longhorn-custom-storageclass.yaml

## app ##

kubectl apply -f app1.yaml -f app2.yaml -f ingress-main.yaml
#kubectl delete -f app1.yaml -f app2.yaml -f app-ingress.yaml -f storage-class.yaml

kubectl get pods -n longhorn-system -n default

## k8s web ##

helm repo add kubernetes-dashboard https://kubernetes.github.io/dashboard/

helm upgrade --install kubernetes-dashboard kubernetes-dashboard/kubernetes-dashboard --create-namespace --namespace kubernetes-dashboard

kubectl apply -f dashboard-serviceaccount.yaml

kubectl -n kubernetes-dashboard describe secret $(kubectl -n kubernetes-dashboard get secret | grep admin-user | awk '{print $1}')

kubectl apply -f dashboard-ingress.yaml
