#!/bin/bash

# Subir la nueva versión a minikube
echo "Subiendo la nueva versión a minikube..."
cd WebApp
minikube image build -t webapp:latest .

cd ../k8s
echo "---"
# Desplegar green
echo "Desplegando la imagen GREEN..."
kubectl apply -f simulacion-despliegue/web-green-deployment.yaml
echo "Cambiando el tráfico a la aplicación GREEN..."
kubectl apply -f simulacion-despliegue/web-green-service.yaml

echo ""
read -p "Pulsa Intro para continuar..."
echo "Comprobando que existe tráfico a GREEN..."
# Se verifica la url de health con curl
for i in $(seq 1 3); do curl -k https://web.local/health; done

echo ""
read -p "Pulsa Intro para eliminar el deploy BLUE..."
echo "Eliminando BLUE..."
kubectl delete deploy webapp-deployment -n webapp-ns