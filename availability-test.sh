#!/bin/bash

# kubectl delete -n monitoring-ns pod $(kubectl get pods -n monitoring-ns --no-headers -o custom-columns=":metadata.name")
mensajeDeConfirmación() {
  echo -c "compruébalo en el dashboard!\n"
}

echo "Test para la infraestructura generada en kubernetes."
echo ""
echo "--- Base de datos ---"
echo "Comprobando la persistencia de datos y la alta disponibilidad..."
database=$(kubectl get pods -n database-ns --no-headers -o custom-columns=":metadata.name")
kubectl exec -it -n database-ns $database -c mariadb -- mariadb -u user -ppass -D webdata -e "SELECT * FROM users;"
echo "Se va a eliminar el pod de la base de datos..."
# Detener la base de datos
kubectl delete -n database-ns pod $database

# Mensaje de confirmación
echo "Se ha detenido la base de datos, "
mensajeDeConfirmación
# Esperar para continuar
read -p "Pulsa Intro una vez iniciada la base de datos y comprobar la persistencia de datos..."
kubectl exec -it -n database-ns $(kubectl get pods -n database-ns --no-headers -o custom-columns=":metadata.name") -c mariadb -- mariadb -u user -ppass -D webdata -e "SELECT * FROM users;"

echo ""
echo "--- Cache ---"
echo "Se va a detener la cache..."
# Detener la cache
kubectl delete -n cache-ns pod $(kubectl get pods -n cache-ns --no-headers -o custom-columns=":metadata.name")

# Mensaje de confirmación
echo "Se detenido la cache, "
mensajeDeConfirmación

read -p "Pulsa Intro para continuar..."
echo ""
echo "--- Web ---"
echo "Se va a detener la web..."
# Detener la cache
kubectl delete -n webapp-ns pod $(kubectl get pods -n webapp-ns --no-headers -o custom-columns=":metadata.name")

# Mensaje de confirmación
echo "Se detenido la web, "
mensajeDeConfirmación

read -p "Pulsa Intro para finalizar..."