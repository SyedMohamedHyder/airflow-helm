# ==============================================================================
# Docker and k8s

.PHONY: build
build:
	docker build -f docker/Dockerfile \
		-t syedhyder1362k/cohesive \
		--build-arg http_proxy=${http_proxy} \
		--build-arg https_proxy=${https_proxy} \
		--build-arg HTTP_PROXY=${HTTP_PROXY} \
		--build-arg HTTPS_PROXY=${HTTPS_PROXY} \
		--build-arg no_proxy=${no_proxy} \
		--build-arg NO_PROXY=${NO_PROXY} \
		.

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
