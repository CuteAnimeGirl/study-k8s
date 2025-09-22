#!/bin/bash

## Metallb ##
helm upgrade --install metallb metallb/metallb \
  --repo https://metallb.github.io/metallb \
  --namespace metallb-system --create-namespace \
  --version 0.15.2

kubectl -n metallb-system get pods
kubectl apply -f metallb-conf.yaml

## Ingress-nginx ##
helm upgrade --install ingress-nginx ingress-nginx \
  --repo https://kubernetes.github.io/ingress-nginx \
  --namespace ingress-nginx --create-namespace \
  --version 4.13.2

kubectl get pods -n ingress-nginx
kubectl get svc -n ingress-nginx

## Longhorn ##
#curl -sSfL -o longhornctl https://github.com/longhorn/cli/releases/download/v1.9.1/longhornctl-linux-amd64
#chmod +x longhornctl

./longhornctl --kube-config ~/.kube/config --image longhornio/longhorn-cli:v1.9.1 install preflight

helm upgrade --install longhorn longhorn/longhorn \
  --repo https://charts.longhorn.io \
  --namespace longhorn-system --create-namespace \
  --version 1.9.1

helm repo add longhorn https://charts.longhorn.io
helm repo update
helm install longhorn longhorn/longhorn --namespace longhorn-system --create-namespace --version 1.9.1

kubectl get pods -n longhorn-system
kubectl apply -f longhorn-sc1.yaml

## Kubernetes Dashboard ##

helm upgrade --install kubernetes-dashboard kubernetes-dashboard/kubernetes-dashboard \
  --repo https://kubernetes.github.io/dashboard/ \
  --namespace kubernetes-dashboard --create-namespace \
  --version 7.13.0

kubectl apply -f k8s-dashboard-cluster-admin.yaml -f k8s-dashboard-ingress.yaml
