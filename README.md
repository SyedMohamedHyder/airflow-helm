# airflow-helm
This repo contains simple and a quickly deployable helm chart for an Airflow Dev env

**I strictly warn you from deploying this chart as it is in production. A lot of security features have been disabled and passwords have been hardcoded in values.yaml**

Run the following commands to setup up airflow in your local

```bash
helm repo add syed https://syedmohamedhyder.github.io/airflow-helm/
helm repo update
```

In the following command replace \<path-to-airflow-home\> with the path to your airflow home, under which you have the dags, plugins etc.

For non-windows users, you may additionally have to pass in the flag `--set machine.windows=false`.

```bash
helm install airflow syed/airflow --namespace airflow --set "persistence.path=<path-to-airflow-home>" --create-namespace --atomic
```

The \<path-to-airflow-home\> should be in the format `/c/path/to/your/airflow/home`.
