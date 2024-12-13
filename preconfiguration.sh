#!/bin/bash

# Crea los namespaces
kubectl create -f ./k8s/namespaces.yaml

# Configmaps
kubectl create configmap db-configmap --from-file=./conf-files/init.sql --from-file=./conf-files/monitoring/prometheus/mysql-exporter.my-cnf -n database-ns
kubectl create configmap prometheus-configmap --from-file=./conf-files/monitoring/prometheus/prometheus-conf.yml --from-file=./conf-files/monitoring/prometheus/alert-rules.yml -n monitoring-ns
kubectl create configmap promtail-configmap --from-file=./conf-files/monitoring/prometheus/promtail.yaml -n monitoring-ns
kubectl create configmap grafana-configmap --from-file=./conf-files/monitoring/grafana/provisioning/dashboards/all-dashboards.yml --from-file=./conf-files/monitoring/grafana/provisioning/datasources/datasources.yaml --from-file=./conf-files/monitoring/grafana/provisioning/alerting/alerts.yaml --from-file=./conf-files/monitoring/grafana/dashboard.json -n monitoring-ns
kubectl create configmap alertmanager-configmap --from-file=./conf-files/monitoring/prometheus/alertmanager-conf.yml -n monitoring-ns

# certificado autofirmado
kubectl create secret tls self-signed --key=./conf-files/certs/cert.crt.key --cert=./conf-files/certs/cert.crt -n ingress-ns

# secrets de usuarios y contraseñas
kubectl create secret generic db-user --from-literal=username='user' --from-literal=password='pass' -n webapp-ns
kubectl create secret generic grafana-pass --from-literal=grafana-pass='pass' -n monitoring-ns

# Rol de monitorización
kubectl create -f ./k8s/roles-monitoring.yaml

# Crea la imagen de la webapp
echo "Creando la imagen de la aplicación web..."
cd WebApp
minikube image build -t webapp:1.5 .
