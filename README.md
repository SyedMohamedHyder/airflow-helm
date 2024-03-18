### Detailed Airflow Helm Chart Setup Guide

This repository provides a simple and quickly deployable Helm chart for an Airflow development environment. However, it's essential to note that this chart is **not suitable for production deployment**. Many security features are disabled, and passwords are hardcoded in the `values.yaml` file.

#### Prerequisites

Before deploying Airflow using this Helm chart, ensure you have the following prerequisites:

1. **Helm**: Ensure that you have Helm installed on your local machine.
2. **Airflow Home Directory**: Have an Airflow home directory set up on your local machine. This directory should contain the necessary DAGs, plugins, and other configurations.
3. **Ingress Controller**: For versions 1.0.0 and above of the chart, you'll need an Ingress controller installed on your local Kubernetes cluster.
        You can avoid the ingress by disabling the ingress `--set "ingress.enabled=false"`.

#### Adding Helm Repository

First, add the Helm repository by running the following command:

```bash
helm repo add syed https://syedmohamedhyder.github.io/airflow-helm/
helm repo update
```

Deploying Airflow
Now, deploy Airflow using the Helm chart. Replace <path-to-airflow-home> with the path to your Airflow home directory.

For non-Windows users, if you're running Docker in WSL (Windows Subsystem for Linux), you may need to pass the additional flag --set dockerInWSL=false.

```bash
helm install airflow syed/airflow --version 0.3.0 \
  --namespace airflow \
  --set "persistence.path=<path-to-airflow-home>" \
  --create-namespace \
  --atomic
```

Ensure that `<path-to-airflow-home>` follows the format `/c/path/to/your/airflow/home` for Windows users.

#### Version 1.0.0 and Above
For versions 1.0.0 and above of the chart, you'll need an Ingress controller installed in your local Kubernetes cluster. Make sure to set up the Ingress controller before deploying Airflow.

**Customization:** If you don't have an Ingress controller enabled or don't want to use it, you can modify the values to disable Ingress-related configurations.

#### Warning

Do not use this Helm chart for production deployment. It's intended for development and testing purposes only. Ensure that you understand the security implications, including the hardcoded passwords/tls_certs and disabled security features, before deploying Airflow using this chart.

## Helm Values

The following is a summary of the **helm values** provided by this chart (see the full list in [`values.yaml`](https://github.com/SyedMohamedHyder/airflow-helm/blob/main/charts/airflow/values.yaml) file).

<details>
<summary><code>nameOverride</code></summary>

Parameter | Description | Default
--- | --- | ---
`nameOverride` | Name override for the Helm release | `nil`
`fullnameOverride` | Full name override for the Helm release | `nil`
</details>

<details>
<summary><code>image.*</code></summary>

Parameter | Description | Default
--- | --- | ---
`image.repository` | The repository of docker image | `syedhyder1362k/cohesive`
`image.pullPolicy` | Image pull policy | `IfNotPresent`
`image.tag` | Tag for the docker image | `latest`
</details>

<details>
<summary><code>dockerInWSL</code></summary>

Parameter | Description | Default
--- | --- | ---
`dockerInWSL` | Flag indicating whether Docker is running in WSL | `false`
</details>

<details>
<summary><code>persistence.*</code></summary>

Parameter | Description | Default
--- | --- | ---
`persistence.storage` | Storage configuration for the PersistentVolume | `5Gi`
`persistence.storageClassName` | Storage class for the PersistentVolume | `manual`
`persistence.path` | Path for the hostPath | `"/C/Users/kunmeer/go/src/github.com/cmo-pce-e2e-build"`
</details>

<details>
<summary><code>pg.*</code></summary>

Parameter | Description | Default
--- | --- | ---
`pg.enabled` | Flag indicating whether PostgreSQL is enabled | `true`
`pg.auth.postgresPassword` | Password for the 'postgres' user in PostgreSQL | `postgres`
`pg.auth.username` | Username for the 'airflow' user in PostgreSQL | `airflow`
`pg.auth.password` | Password for the 'airflow' user in PostgreSQL | `airflow`
`pg.auth.database` | Database name in PostgreSQL | `airflow`
`pg.primary.networkPolicy.enabled` | Flag indicating whether network policy is enabled for the primary node | `false`
`pg.primary.persistence.size` | Size of the PersistentVolumeClaim (PVC) for PostgreSQL data | `1Gi`
</details>

<details>
<summary><code>redis.*</code></summary>

Parameter | Description | Default
--- | --- | ---
`redis.enabled` | Flag indicating whether Redis is enabled | `true`
`redis.architecture` | Redis architecture | `standalone`
`redis.networkPolicy.enabled` | Flag indicating whether network policy is enabled for Redis | `false`
`redis.master.persistence.size` | Size of the PersistentVolumeClaim (PVC) for Redis data | `1Gi`
</details>

<details>
<summary><code>commonSecrets.*</code></summary>

Parameter | Description | Default
--- | --- | ---
`commonSecrets.*` | Hardcoded values for secrets | *Various*
</details>

<details>
<summary><code>init.*</code></summary>

Parameter | Description | Default
--- | --- | ---
`init.env` | Initialization environment variables | *Various*
</details>

<details>
<summary><code>webserver.*</code></summary>

Parameter | Description | Default
--- | --- | ---
`webserver.replicaCount` | Number of replicas for the webserver | `1`
`webserver.urlPrefix` | URL prefix for the webserver | `/cohesive`
`webserver.service.type` | Service type for the webserver | `ClusterIP`
`webserver.service.nodePorts.http` | Node port for HTTP | `30080`
`webserver.service.nodePorts.https` | Node port for HTTPS | `30443`
`webserver.service.ports.http` | Container port for HTTP | `8080`
`webserver.service.ports.https` | Container port for HTTPS | `443`
</details>

<details>
<summary><code>scheduler.*</code></summary>

Parameter | Description | Default
--- | --- | ---
`scheduler.replicaCount` | Number of replicas for the scheduler | `1`
</details>

<details>
<summary><code>worker.*</code></summary>

Parameter | Description | Default
--- | --- | ---
`worker.replicaCount` | Number of replicas for the worker | `1`
</details>

<details>
<summary><code>triggerer.*</code></summary>

Parameter | Description | Default
--- | --- | ---
`triggerer.replicaCount` | Number of replicas for the triggerer | `1`
</details>

<details>
<summary><code>flower.*</code></summary>

Parameter | Description | Default
--- | --- | ---
`flower.enabled` | Flag indicating whether Flower is enabled | `true`
`flower.urlPrefix` | URL prefix for Flower | `/flower`
`flower.service.type` | Service type for Flower | `ClusterIP`
</details>

<details>
<summary><code>ingress.*</code></summary>

Parameter | Description | Default
--- | --- | ---
`ingress.enabled` | Enable or disable the Ingress resource | `true`
`ingress.class` | Specify the Ingress class to use | `nginx`
`ingress.host` | Specify the host for the Ingress | `hewlettpackard.dev.internal`
`ingress.tls.enabled` | Flag indicating whether TLS is enabled for ingress | `true`
`ingress.tls.crt` | TLS certificate for the ingress | *Certificate data*
`ingress.tls.key` | TLS key for the ingress | *Key data*
</details>
