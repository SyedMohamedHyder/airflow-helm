<h3>Detailed Airflow Helm Chart Setup Guide</h3>

<p>This repository provides a simple and quickly deployable Helm chart for an Airflow development environment. However, it's essential to note that this chart is <strong>not suitable for production deployment</strong>. Many security features are disabled, and passwords are hardcoded in the <code>values.yaml</code> file.</p>

<h4>Prerequisites</h4>

<p>Before deploying Airflow using this Helm chart, ensure you have the following prerequisites:</p>

<ol>
  <li><strong>Helm:</strong> Ensure that you have Helm installed on your local machine.</li>
  <li><strong>Airflow Home Directory:</strong> Have an Airflow home directory set up on your local machine. This directory should contain the necessary DAGs, plugins, and other configurations.</li>
  <li><strong>Ingress Controller:</strong> For versions 1.0.0 and above of the chart, you'll need an Ingress controller installed on your local Kubernetes cluster. You can avoid the ingress by disabling the ingress <code>--set "ingress.enabled=false"</code>.</li>
</ol>

<h4>Adding Helm Repository</h4>

<p>First, add the Helm repository by running the following command:</p>

<pre><code>helm repo add syed https://syedmohamedhyder.github.io/airflow-helm/
helm repo update
</code></pre>

<h4>Deploying Airflow</h4>

<p>Now, deploy Airflow using the Helm chart. Replace <code>&lt;path-to-airflow-home&gt;</code> with the path to your Airflow home directory.</p>

<p>For non-Windows users, if you're running Docker in WSL (Windows Subsystem for Linux), you may need to pass the additional flag <code>--set dockerInWSL=false</code>.</p>

<pre><code>helm install airflow syed/airflow --version 0.3.0 \
  --namespace airflow \
  --set "persistence.path=&lt;path-to-airflow-home&gt;" \
  --create-namespace \
  --atomic
</code></pre>

<p>Ensure that <code>&lt;path-to-airflow-home&gt;</code> follows the format <code>/c/path/to/your/airflow/home</code> for Windows users.</p>

<h4>Version 1.0.0 and Above</h4>

<p>For versions 1.0.0 and above of the chart, you'll need an Ingress controller installed in your local Kubernetes cluster. Make sure to set up the Ingress controller before deploying Airflow.</p>

<p><strong>Customization:</strong> If you don't have an Ingress controller enabled or don't want to use it, you can modify the values to disable Ingress-related configurations.</p>

<h4>Warning</h4>

<p>Do not use this Helm chart for production deployment. It's intended for development and testing purposes only. Ensure that you understand the security implications, including the hardcoded passwords/tls_certs and disabled security features, before deploying Airflow using this chart.</p>

<h2>Helm Values</h2>

<p>The following is a summary of the <strong>helm values</strong> provided by this chart (see the full list in <a href="https://github.com/SyedMohamedHyder/airflow-helm/blob/main/charts/airflow/values.yaml">values.yaml</a> file).</p>

<table>
  <tr>
    <th>Parameter</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><code>image.repository</code></td>
    <td>The repository of docker image</td>
    <td><code>syedhyder1362k/cohesive</code></td>
  </tr>
  <tr>
    <td><code>image.pullPolicy</code></td>
    <td>Image pull policy</td>
    <td><code>IfNotPresent</code></td>
  </tr>
  <tr>
    <td><code>image.tag</code></td>
    <td>Tag for the docker image</td>
    <td><code>latest</code></td>
  </tr>
  <tr>
    <td><code>dockerInWSL</code></td>
    <td>Flag indicating whether Docker is running in WSL</td>
    <td><code>false</code></td>
  </tr>
  <tr>
    <td><code>persistence.storage</code></td>
    <td>Storage configuration for the PersistentVolume</td>
    <td><code>5Gi</code></td>
  </tr>
  <tr>
    <td><code>persistence.storageClassName</code></td>
    <td>Storage class for the PersistentVolume</td>
    <td><code>manual</code></td>
  </tr>
  <tr>
    <td><code>persistence.path</code></td>
    <td>Path for the hostPath</td>
    <td><code>"/C/Users/kunmeer/go/src/github.com/cmo-pce-e2e-build"</code></td>
  </tr>
  <tr>
    <td><code>pg.enabled</code></td>
    <td>Flag indicating whether PostgreSQL is enabled</td>
    <td><code>true</code></td>
  </tr>
  <tr>
    <td><code>pg.auth.postgresPassword</code></td>
    <td>Password for the 'postgres' user in PostgreSQL</td>
    <td><code>postgres</code></td>
  </tr>
  <tr>
    <td><code>pg.auth.username</code></td>
    <td>Username for the 'airflow' user in PostgreSQL</td>
    <td><code>airflow</code></td>
  </tr>
  <tr>
    <td><code>pg.auth.password</code></td>
    <td>Password for the 'airflow' user in PostgreSQL</td>
    <td><code>airflow</code></td>
  </tr>
  <tr>
    <td><code>pg.auth.database</code></td>
    <td>Database name in PostgreSQL</td>
    <td><code>airflow</code></td>
  </tr>
  <tr>
    <td><code>pg.primary.networkPolicy.enabled</code></td>
    <td>Flag indicating whether network policy is enabled for the primary node</td>
    <td><code>false</code></td>
  </tr>
  <tr>
    <td><code>pg.primary.persistence.size</code></td>
    <td>Size of the PersistentVolumeClaim (PVC) for PostgreSQL data</td>
    <td><code>1Gi</code></td>
  </tr>
  <tr>
    <td><code>redis.enabled</code></td>
    <td>Flag indicating whether Redis is enabled</td>
    <td><code>true</code></td>
  </tr>
  <tr>
    <td><code>redis.architecture</code></td>
    <td>Redis architecture</td>
    <td><code>standalone</code></td>
  </tr>
  <tr>
    <td><code>redis.networkPolicy.enabled</code></td>
    <td>Flag indicating whether network policy is enabled for Redis</td>
    <td><code>false</code></td>
  </tr>
  <tr>
    <td><code>redis.master.persistence.size</code></td>
    <td>Size of the PersistentVolumeClaim (PVC) for Redis data</td>
    <td><code>1Gi</code></td>
  </tr>
  <tr>
    <td><code>commonSecrets.*</code></td>
    <td>Hardcoded values for secrets</td>
    <td>*Various*</td>
  </tr>
  <tr>
    <td><code>init.env</code></td>
    <td>Initialization environment variables</td>
    <td>*Various*</td>
  </tr>
  <tr>
    <td><code>webserver.replicaCount</code></td>
    <td>Number of replicas for the webserver</td>
    <td><code>1</code></td>
  </tr>
  <tr>
    <td><code>webserver.urlPrefix</code></td>
    <td>URL prefix for the webserver</td>
    <td><code>/cohesive</code></td>
  </tr>
  <tr>
    <td><code>webserver.service.type</code></td>
    <td>Service type for the webserver</td>
    <td><code>ClusterIP</code></td>
  </tr>
  <tr>
    <td><code>webserver.service.nodePorts.http</code></td>
    <td>Node port for HTTP</td>
    <td><code>30080</code></td>
  </tr>
  <tr>
    <td><code>webserver.service.nodePorts.https</code></td>
    <td>Node port for HTTPS</td>
    <td><code>30443</code></td>
  </tr>
  <tr>
    <td><code>webserver.service.ports.http</code></td>
    <td>Container port for HTTP</td>
    <td><code>8080</code></td>
  </tr>
  <tr>
    <td><code>webserver.service.ports.https</code></td>
    <td>Container port for HTTPS</td>
    <td><code>443</code></td>
  </tr>
  <tr>
    <td><code>scheduler.replicaCount</code></td>
    <td>Number of replicas for the scheduler</td>
    <td><code>1</code></td>
  </tr>
  <tr>
    <td><code>worker.replicaCount</code></td>
    <td>Number of replicas for the worker</td>
    <td><code>1</code></td>
  </tr>
  <tr>
    <td><code>triggerer.replicaCount</code></td>
    <td>Number of replicas for the triggerer</td>
    <td><code>1</code></td>
  </tr>
  <tr>
    <td><code>flower.enabled</code></td>
    <td>Flag indicating whether Flower is enabled</td>
    <td><code>true</code></td>
  </tr>
  <tr>
    <td><code>flower.urlPrefix</code></td>
    <td>URL prefix for Flower</td>
    <td><code>/flower</code></td>
  </tr>
  <tr>
    <td><code>flower.service.type</code></td>
    <td>Service type for Flower</td>
    <td><code>ClusterIP</code></td>
  </tr>
  <tr>
    <td><code>ingress.enabled</code></td>
    <td>Enable or disable the Ingress resource</td>
    <td><code>true</code></td>
  </tr>
  <tr>
    <td><code>ingress.class</code></td>
    <td>Specify the Ingress class to use</td>
    <td><code>nginx</code></td>
  </tr>
  <tr>
    <td><code>ingress.host</code></td>
    <td>Specify the host for the Ingress</td>
    <td><code>hewlettpackard.dev.internal</code></td>
  </tr>
  <tr>
    <td><code>ingress.tls.enabled</code></td>
    <td>Flag indicating whether TLS is enabled for ingress</td>
    <td><code>true</code></td>
  </tr>
  <tr>
    <td><code>ingress.tls.crt</code></td>
    <td>TLS certificate for the ingress</td>
    <td>*Certificate data*</td>
  </tr>
  <tr>
    <td><code>ingress.tls.key</code></td>
    <td>TLS key for the ingress</td>
    <td>*Key data*</td>
  </tr>
</table>

</html>
