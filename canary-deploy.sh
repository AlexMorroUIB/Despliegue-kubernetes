#!/bin/bash

# Subir la nueva versión a minikube
echo "Subiendo la nueva versión a minikube..."
cd WebApp
minikube image build -t webapp:latest .

cd ../k8s
echo "---"
# Desplegar canary
echo "Desplegando la imagen canary..."
kubectl apply -f simulacion-despliegue/web-canary-deployment.yaml
echo ""
echo "Pods de la aplicación web:"
kubectl get pods -n webapp-ns
echo ""
sleep 10
read -p "Pulsa Intro para continuar..."
echo "Comprobando que existe tráfico al canary..."
canary-pod=$(kubectl get pods -n webapp-ns --no-headers -o custom-columns=":metadata.name" | grep canary)
kubectl -n webapp-ns describe pod $canary-pod | grep Ready
if [ kubectl -n webapp-ns describe pod $canary-pod | grep Ready | grep False ]; then
  echo "No existe tráfico al canary..."
  echo "Eliminando canary..."
  kubectl delete deploy webapp-canary-deployment -n webapp-ns
else
  echo ""
  read -p "Pulsa Intro para desplegar la nueva versión..."
  echo "Desplegando la nueva versión..."
  kubectl delete deploy webapp-deployment -n webapp-ns
  kubectl apply -f webapp/web-deployment.yaml

  echo ""
  sleep 20
  echo "Eliminando canary..."
  kubectl delete deploy webapp-canary-deployment -n webapp-ns
fi