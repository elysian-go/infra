#!/bin/bash
kubectl scale --replicas=0 deployment/kube-dns-autoscaler --namespace=kube-system
kubectl scale --replicas=1 deployment/kube-dns --namespace=kube-system
kubectl scale --replicas=0 deployment/l7-default-backend --namespace=kube-system

