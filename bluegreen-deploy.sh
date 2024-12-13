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
echo "Habilitando el tráfico a la aplicación GREEN..."
kubectl apply -f simulacion-despliegue/web-green-service.yaml
echo "Ejecuta 'minikube service webapp-green-service -n webapp-ns' en otra terminal para comprobar que funcione la web."
echo ""
read -p "Pulsa Intro para continuar..."


echo ""
read -p "Cambia el color de 'web-service.yaml' a green y pulsa Intro para eliminar el deploy BLUE..."
kubectl apply -f webapp/web-service.yaml
kubectl delete -n webapp-ns service webapp-green-service
echo "Comprobando que existe tráfico a GREEN..."
# Se verifica la url de health con curl
for i in $(seq 1 3); do 
    output=$(curl -k https://web.local/health)
    echo $output
    if [[ "$output" == *"green"* ]]; then
        echo "La nueva versión recibe tráfico!"
        # Si green recibe tráfico elimina el deploy blue y sale del bucle
        echo "Eliminando BLUE..."
        kubectl delete deploy webapp-deployment -n webapp-ns
        break  
    fi
done
