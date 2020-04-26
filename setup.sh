#!/bin/bash

#GCloud
gcloud container clusters get-credentials kluster
gcloud iam service-accounts list
gcloud iam service-accounts keys create keys/kubeip-key.json --iam-account kubeip-serviceaccount@groovy-height-275210.iam.gserviceaccount.com

#namespaces
kubectl create --save-config -f k8s/namespaces.yaml

#static-web deployment
kubectl create --save-config -f k8s/static-web/deployment.yaml -f k8s/static-web/service.yaml

#kubeip setup
kubectl create --save-config -f k8s/kubeip/deployment.yaml
kubectl create secret generic kubeip-key --from-file=keys/kubeip-key.json -n kube-system
kubectl create --save-config -f k8s/kubeip/serviceaccount.yaml -f k8s/kubeip/configmap.yaml

#nginx ingress
helm install nginx-ingress nginx-stable/nginx-ingress -f k8s/ingress/values.yaml --namespace elysian-ingress
kubectl create --save-config -f k8s/ingress/ingress.yaml

#static-web ingress
kubectl create --save-config -f k8s/static-web/ingress.yaml

kubectl get event --sort-by=lastTimestamp
