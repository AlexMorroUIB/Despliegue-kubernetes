#!/bin/bash

# 
cd k8s
echo "Desplegando la imagen canary..."
kubectl apply -f simulacion-despliegue/web-canary-deployment.yaml
echo ""
read -p "Pulsa Intro para continuar..."
echo "Comprobando que existe tráfico al canary..."
# Se verifica si el curl contiene la palabra "canary". Si es así, sale del bucle.
for i in $(seq 1 10); do
    response=$(curl -k https://web.local/health)
    echo "$response"
    if [[ "$response" == *"canary"* ]]; then
        break
    fi
done

echo ""
read -p "Pulsa Intro para continuar..."
echo "Desplegando la nueva versión..."
kubectl delete deploy webapp-deployment -n webapp-ns
kubectl apply -f webapp/web-deployment.yaml

echo ""
read -p "Pulsa Intro para continuar..."
echo "Eliminando canary..."
kubectl delete deploy webapp-canary-deployment -n webapp-ns