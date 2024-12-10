#!/bin/bash

# 
cd k8s
echo "Desplegando la imagen canary..."
kubectl apply -f simulacion-despliegue/web-canary-deployment.yaml
echo ""
read -p "Pulsa Intro para continuar..."
echo "Comprobando que existe tráfico al canary..."
for i in $(seq 1 10); do curl -k https://web.local/health && echo ""; done

echo ""
read -p "Pulsa Intro para continuar..."
echo "Desplegando la nueva versión..."
kubectl delete deploy webapp-deployment -n webapp-ns
kubectl apply -f webapp/web-deployment.yaml

echo ""
read -p "Pulsa Intro para continuar..."
echo "Eliminando canary..."
kubectl delete deploy webapp-canary-deployment -n webapp-ns