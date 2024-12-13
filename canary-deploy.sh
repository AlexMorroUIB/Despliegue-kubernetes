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

# El primer bucle comprueba que exista tráfico hacia el canary
while true; do
    # Ejecuta el comando curl y guarda la salida en la variable 'output'
    output=$(curl -k https://web.local/health)

    # Verifica si la salida contiene la cadena "canary"
    if [[ "$output" == *"canary"* ]]; then
        echo "Existe tráfico hacia el canary!"
        echo ""
        read -p "Cambia la versión a latest en el web-deployment y pulsa Intro para desplegar la nueva versión..."
        echo "Desplegando la nueva versión..."
        kubectl delete deploy webapp-deployment -n webapp-ns
        kubectl apply -f webapp/web-deployment.yaml
        sleep 5
        echo ""
        echo "Esperando que la nueva versión reciba tráfico..."
        # Este segundo bucle comprueba que existe tráfico hacia las nuevas versiones que no son canary
        while true; do
            # Ejecuta el comando curl y guarda la salida en la variable 'output'
            output=$(curl -k https://web.local/health)

            # Verifica si la salida contiene la cadena "canary"
            if [[ "$output" != *"canary"* ]]; then
                echo "La nueva versión recibe tráfico!"
                break  # Sale del bucle si se encuentra "canary"
            fi
            # Espera un segundo antes de volver a intentar
            sleep 1
        done
        break
    fi
    # Espera un segundo antes de volver a intentar
    sleep 1
done
echo "Eliminando canary..."
kubectl delete deploy webapp-canary-deployment -n webapp-ns
