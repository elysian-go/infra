#!/bin/bash

#GCloud
gcloud container clusters get-credentials kluster --region us-east1-b
gcloud iam service-accounts list
gcloud iam service-accounts keys create keys/kubeip-key.json \
 --iam-account kubeip-serviceaccount@GCP_PROJECT.iam.gserviceaccount.com

#namespaces
kubectl create --save-config -f k8s/namespaces.yaml

#static-web deployment
kubectl create secret docker-registry gcr-json-key \
--docker-server=asia.gcr.io --docker-username=_json_key \
--docker-password="$(cat ./keys/gcr_key.json)" --docker-email=any@valid.email
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

#redis-ha
helm install redis-ha dandydev/redis-ha -f k8s/redis/values.yaml --namespace elysian-dev

#resize node pool
gcloud container clusters resize kluster --node-pool web-pool --num-nodes 3

#update configmap or secret
kubectl create configmap NAME --from-file PATH -o yaml --dry-run | kubectl replace -f - -n elysian-dev
