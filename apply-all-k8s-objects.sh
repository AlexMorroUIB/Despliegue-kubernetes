#!/bin/bash

# 
cd k8s
kubectl apply -f ingress.yaml
kubectl apply -f webapp
kubectl apply -f database
kubectl apply -f cache
kubectl apply -f monitoring