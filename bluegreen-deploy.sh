#!/bin/bash

# cahnge default name to blue
cd k8s
echo "Desplegando la imagen green..."
kubectl apply -f simulacion-despliegue/web-green-deployment.yaml
echo "Cambiando el tráfico a la aplicación green"
kubectl edit svc webapp-service -n webapp-ns

echo ""
read -p "Pulsa Intro para continuar..."
echo "Comprobando que existe tráfico al green..."
for i in $(seq 1 10); do curl -k https://web.local/health && echo ""; done

echo ""
read -p "Pulsa Intro para continuar..."
echo "Escalando la nueva versión..."
kubectl scale deployment green --replicas=3

echo ""
read -p "Pulsa Intro para continuar..."
echo "Eliminando canary..."
kubectl delete deploy webapp-canary-deployment -n webapp-ns