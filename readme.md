# Despliegue en Kubernetes
Este repositorio consiste en una prueba de despliege de diferentes servicios conectados entre sí basándose en el repositorio de `Despliegue-aplicaciones-multi-entorno` y en dos entornos distintos, desarrollo y producción, usando la herramienta de Terraform.<br>
Los diferentes servicios son una aplicación web, una base de datos, una caché, un load balancer y un servicio de monitorización con prometheus y grafana. El servicio de alertmanager para las alertas sólo se despliega en el entorno de producción además de las siguientes configuraciones de alta disponibilidad:
* La web tiene 3 instancias en vez de 2.
* La caché está configurada con alta disponibilidad con 2 esclavos.

![Diagrama de la infraestructura](./infraestructura-terraform.png)

## Despliegue de entornos
1. Iniciar el cluster de k8s usando el comando `minikube start`.
2. Habilitar la exposición de ingress de minikube hacia localhost.
   - `minikube addons enable ingress`
3. Modificar el archivo `/etc/hosts` añadiendo la siguiente configuración:
   - En Linux usar la ip del cluster `minikube ip` en vez de localhost.
   - ```
     127.0.0.1 web.local
     127.0.0.1 phpmyadmin.local
     127.0.0.1 redis.local
     127.0.0.1 prometheus.local
     127.0.0.1 grafana.local
     127.0.0.1 alertmanager.local
     ```
4. Ejecutar el script preconfiguration.sh o seguir los siguientes pasos:
    a. Crear los namespaces.
        - `kubectl create -f ./k8s/namespaces.yaml`
    5. Añadir los configmap de los archivos de configuración.
        - ```
            kubectl create configmap db-configmap --from-file=./conf-files/init.sql --from-file=./conf-files/monitoring/prometheus/mysql-exporter.my-cnf -n database-ns
            kubectl create configmap prometheus-configmap --from-file=./conf-files/monitoring/prometheus/prometheus-conf.yml --from-file=./conf-files/monitoring/prometheus/alert-rules.yml -n monitoring-ns
            # Lista de dashboards de Grafana
            kubectl create configmap grafana-configmap --from-file=./conf-files/monitoring/grafana/provisioning/dashboards/all-dashboards.yml --from-file=./conf-files/monitoring/grafana/provisioning/datasources/datasources.yaml --from-file=./conf-files/monitoring/grafana/dashboard.json -n monitoring-ns
            kubectl create configmap alertmanager-configmap --from-file=./conf-files/monitoring/prometheus/alertmanager-conf.yml -n monitoring-ns
            kubectl create configmap blackbox-configmap --from-file=./conf-files/monitoring/prometheus/blackbox-config.yml -n webapp-ns
            ```
    6. Añadir el certificado autofirmado a los secrets de k8s.
        - `kubectl create secret tls self-signed --key=./conf-files/certs/cert.crt.key --cert=./conf-files/certs/cert.crt -n ingress-ns`
    7. Añadir los secrets de usuarios y contraseñas.
        - ```
            kubectl create secret generic db-user --from-literal=username='user' --from-literal=password='pass' -n webapp-ns
            kubectl create secret generic grafana-pass --from-literal=grafana-pass='pass' -n monitoring-ns
            ```
    8. Crear el rol para la monitorización.
        - `kubectl create -f ./k8s/roles-monitoring.yaml`
    9. Hacer el build de la imagen de la aplicación web desde dentro de la carpeta `WebApp`.
        - `minikube image build -t webapp:latest .`
10. En una terminal ejecutar el comando `minikube tunnel`.
11. En otra terminal añadir la carpeta shared al cluster con el comando `minikube mount ./shared:/shared`



Ahora se puede acceder a la web mediante el ingress (la web te dirá en que pod estás):
* Para acceder a la aplicación web hay que entrar en: https://web.local
    > Hay que aceptar el certificado ya que está autofirmado.
* Para acceder al servicio para administrar la base de datos se debe entrar en la siguiente web en localhost: https://phpmyadmin.local
    > Con usuario `user` y contraseña `pass`.
* Administrar la caché: https://cache.local
    > La caché no tiene usuario ni contraseña.
* Prometheus: https://prometheus.local
* Grafana: https://grafana.local
    > Con usuario `admin` y contraseña `pass`.
* Alertmanager: https://alertmanager.local

### Lanzar pro
Para lanzar el entorno de dev primero tendremos que seleccionar el workspace de pro, seguido de un init y un apply:<br>
(Si antes has lanzado otro entorno es mejor que hagas un `terraform destroy -var-file="var.tfvars"`)
```
terraform workspace select pro
terraform init # Si no lo has hecho antes
terraform apply -var-file="var.tfvars"
```
Ahora se puede acceder a la web mediante el load balancer (la web te dirá en que contenedor estás):
* Para acceder a la aplicación web hay que entrar en: https://localhost
> Hay que aceptar el certificado ya que está autofirmado.
* Para acceder al servicio para administrar la base de datos se debe entrar en la siguiente web en localhost: http://localhost:8081
> Con usuario `user` y contraseña `pass`.
* Administrar la caché: http://localhost:8082
> La caché no tiene usuario ni contraseña.
* Prometheus: http://localhost:8083
* Grafana: http://localhost:8084
> Con usuario `admin` y contraseña `pass`.
* Alermanager: http://localhost:8085

## Test
Se ha incluido un archivo de test `test.sh` que comprueba sobretodo que el apartado de monitorización funciona, apagando y encendiendo los diferentes servicios. Puedes seguir sus acciones mediante grafana `http://localhost:8084`.<br>
El script está pensado de tal forma que cuando para un servicio espera a que se pulse una tecla para continuar, de esta forma da tiempo a ver los resultados en grafana y la o las alertas en alertmanager.