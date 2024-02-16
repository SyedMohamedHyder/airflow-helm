# ==============================================================================
# Docker and k8s

.PHONY: build
build:
	docker build -f docker/Dockerfile . -t airflow-helm

.PHONY: dry-run
dry-run:
	helm install airflow charts/airflow --namespace airflow --atomic --dry-run

.PHONY: install
install:
	helm install airflow charts/airflow --namespace airflow --create-namespace --atomic

.PHONY: upgrade
upgrade:
	helm upgrade airflow charts/airflow --namespace airflow --atomic

.PHONY: uninstall
uninstall:
	helm uninstall airflow --namespace airflow
