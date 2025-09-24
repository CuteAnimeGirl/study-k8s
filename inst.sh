#!/bin/bash

## Metallb ##
helm upgrade --install metallb metallb \
  --repo https://metallb.github.io/metallb \
  --namespace metallb-system --create-namespace \
  --version 0.15.2

kubectl -n metallb-system get pods -w

kubectl apply -f metallb-conf.yaml

## Ingress-nginx ##
helm upgrade --install ingress-nginx ingress-nginx \
  --repo https://kubernetes.github.io/ingress-nginx \
  --namespace ingress-nginx --create-namespace \
  --version 4.13.2

kubectl get pods -n ingress-nginx -w
kubectl get svc -n ingress-nginx

## Longhorn ##
#curl -sSfL -o longhornctl https://github.com/longhorn/cli/releases/download/v1.9.1/longhornctl-linux-amd64
#chmod +x longhornctl

./longhornctl --kube-config ~/.kube/config --image longhornio/longhorn-cli:v1.9.1 install preflight

helm upgrade --install longhorn longhorn \
  --repo https://charts.longhorn.io \
  --namespace longhorn-system --create-namespace \
  --version 1.9.1

kubectl get pods -n longhorn-system -w
kubectl apply -f longhorn-sc1.yaml -f longhorn-ingress.yaml

## Kubernetes Dashboard ##
helm upgrade --install kubernetes-dashboard kubernetes-dashboard \
  --repo https://kubernetes.github.io/dashboard \
  --namespace kubernetes-dashboard --create-namespace \
  --version 7.13.0\
  -f k8s-dashboard-values.yaml

kubectl get pods -n kubernetes-dashboard -w

kubectl apply -f k8s-dashboard-cluster-admin.yaml -f k8s-dashboard-ingress.yaml

kubectl -n kubernetes-dashboard create token admin-user

## Gitlab ##
