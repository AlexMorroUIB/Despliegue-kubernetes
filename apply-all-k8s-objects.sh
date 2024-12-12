#!/bin/bash

# 
cd k8s
kubectl apply -f webapp
kubectl apply -f database
kubectl apply -f cache
kubectl apply -f monitoring
kubectl apply -f ingress.yaml