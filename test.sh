#!/bin/bash

mensajeDeConfirmación() {
    if [ "$1" == "dev" ]; then 
        echo "compruébalo en grafana:"
        echo "http://localhost:8084"
    else
        echo "compruébalo en grafana y la alerta en alertmanager."
        echo "Grafana: http://localhost:8084"
        echo "Alertmanager: http://localhost:8085"
    fi
}

echo "Test para la infraestructura generada con terraform."

# Preguntar al usuario por el nombre del workspace
read -p "Introduce el nombre del workspace que quieres comprobar: " workspace

# Ejecutar el comando docker stop con el nombre del workspace
docker stop $workspace-mariadb

# Mensaje de confirmación
echo "Se ha detenido la base de datos,"
mensajeDeConfirmación "$workspace"

# Esperar para continuar
read -p "Pulsa Intro para continuar..."
# Reanudar la base de datos
docker start $workspace-mariadb

# Ejecutar el comando docker stop con el nombre del workspace
docker stop $workspace-redis-slave-1

# Mensaje de confirmación
echo "Se ha reanudado la base de datos y se ha detenido 1 contenedor de redis,"
mensajeDeConfirmación "$workspace"

read -p "Pulsa Intro para continuar..."
# Reanudar la base de datos
docker start $workspace-redis-slave-1

# Ejecutar el comando docker stop con el nombre del workspace
docker stop $workspace-webapp-1

# Mensaje de confirmación
echo "Se ha reanudado redis y se ha detenido 1 contenedor de la web,"
mensajeDeConfirmación "$workspace"

read -p "Pulsa Intro para continuar..."
# Reanudar la base de datos
docker start $workspace-webapp-1

# Ejecutar el comando docker stop con el nombre del workspace
docker stop $workspace-load-balancer

# Mensaje de confirmación
echo "Se ha reanudado el contenedor de la web y se ha detenido el load balancer,"
mensajeDeConfirmación "$workspace"

read -p "Pulsa Intro para finalizar..."
docker start $workspace-load-balancer