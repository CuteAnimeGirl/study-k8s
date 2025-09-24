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

ansible wrk -b -m modprobe -a "name=dm_crypt state=present"
ansible wrk -b -m copy -a "content='dm_crypt' dest=/etc/modules-load.d/dm_crypt.conf owner=root group=root mode=0644"

./longhornctl --kube-config ~/.kube/config --image longhornio/longhorn-cli:v1.9.1 check preflight

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
  --version 7.13.0

kubectl get pods -n kubernetes-dashboard -w

kubectl apply -f k8s-dashboard-cluster-admin.yaml -f k8s-dashboard-ingress.yaml

kubectl get secret admin-user -n kubernetes-dashboard -o jsonpath="{.data.token}" | base64 -d

## Gitlab ##

kubectl apply -f gitlab-namespace.yaml

kubectl create secret generic gitlab-secrets \
  --namespace=gitlab \
  --from-literal=root-password=test-password-5454!

kubectl apply -f gitlab-deployment.yaml -f gitlab-service.yaml -f gitlab-ingress.yaml

kubectl get pods -n gitlab -w

## MinIO ##

kubectl apply -f minio-namespace.yaml

kubectl create secret generic minio-secret \
  --namespace=minio \
  --from-literal=rootUser=minioadmin \
  --from-literal=rootPassword=test-password-5454!

helm upgrade --install minio minio \
  --repo https://charts.min.io/ \
  --namespace minio --create-namespace \
  --version 5.4.0 \
  --f minio-values.yaml

kubectl apply -f minio-ingress.yaml

kubectl get pods -n minio -w