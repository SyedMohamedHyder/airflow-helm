{{/*
Expand the name of the chart.
*/}}
{{- define "airflow.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "airflow.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Generate the full name for the PersistentVolumeClaim.
*/}}
{{- define "airflow.claim.name" -}}
{{- include "airflow.fullname" . }}-claim
{{- end -}}

{{/*
Generate the full name for the common secrets.
*/}}
{{- define "airflow.commonSecrets.name" -}}
{{- include "airflow.fullname" . }}-common
{{- end -}}

{{/*
Generate the full name for the inits.
*/}}
{{- define "airflow.init.name" -}}
{{- include "airflow.fullname" . }}-init
{{- end -}}

{{/*
Generate the full name for the airflow webserver.
*/}}
{{- define "airflow.webserver.name" -}}
{{- include "airflow.fullname" . }}-webserver
{{- end -}}

{{/*
Generate the full name for the airflow scheduler.
*/}}
{{- define "airflow.scheduler.name" -}}
{{- include "airflow.fullname" . }}-scheduler
{{- end -}}

{{/*
Generate the full name for the airflow worker.
*/}}
{{- define "airflow.worker.name" -}}
{{- include "airflow.fullname" . }}-worker
{{- end -}}

{{/*
Generate the full name for the airflow triggerer.
*/}}
{{- define "airflow.triggerer.name" -}}
{{- include "airflow.fullname" . }}-triggerer
{{- end -}}

{{/*
Generate the full name for the airflow flower.
*/}}
{{- define "airflow.flower.name" -}}
{{- include "airflow.fullname" . }}-flower
{{- end -}}

{{/*
Generate the full name for the tls used for ingress.
*/}}
{{- define "airflow.tls.name" -}}
{{- include "airflow.fullname" . }}-tls
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "airflow.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "airflow.labels" -}}
helm.sh/chart: {{ include "airflow.chart" . }}
{{ include "airflow.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "airflow.selectorLabels" -}}
app.kubernetes.io/name: {{ include "airflow.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Define an HTTP probe for the Airflow application.
This template configures an HTTP probe with common settings such as initial delay, period, failure threshold, and timeout.
*/}}
{{- define "airflow.httpProbe" -}}
{{- $path := .path -}}
{{- $port := .port -}}
httpGet:
  path: {{ $path }}
  port: {{ $port }}
initialDelaySeconds: 30
periodSeconds: 30
failureThreshold: 5
timeoutSeconds: 10
{{- end }}

{{/*
Define a TCP socket probe for the Airflow application.
This template configures a TCP socket probe with common settings such as initial delay, period, failure threshold, and timeout.
*/}}
{{- define "airflow.tcpSocketProbe" -}}
{{- $port := .port -}}
tcpSocket:
  port: {{ $port }}
initialDelaySeconds: 30
periodSeconds: 30
failureThreshold: 5
timeoutSeconds: 10
{{- end }}

{{/*
Generate the probes for the Airflow application using HTTP probes.
This template defines HTTP startup, readiness, and liveness probes for Airflow pods.
*/}}
{{- define "airflow.httpProbes" -}}
{{- $path := .path -}}
{{- $port := .port -}}
startupProbe:
  {{- include "airflow.httpProbe" (dict "path" $path "port" $port) | nindent 2 }}
readinessProbe:
  {{- include "airflow.httpProbe" (dict "path" $path "port" $port) | nindent 2 }}
livenessProbe:
  {{- include "airflow.httpProbe" (dict "path" $path "port" $port) | nindent 2 }}
{{- end }}

{{/*
Generate the probes for the Airflow application using TCP socket probes.
This template defines TCP socket startup, readiness, and liveness probes for Airflow pods.
*/}}
{{- define "airflow.tcpSocketProbes" -}}
{{- $port := .port -}}
startupProbe:
  {{- include "airflow.tcpSocketProbe" (dict "port" $port) | nindent 2 }}
readinessProbe:
  {{- include "airflow.tcpSocketProbe" (dict "port" $port) | nindent 2 }}
livenessProbe:
  {{- include "airflow.tcpSocketProbe" (dict "port" $port) | nindent 2 }}
{{- end }}

{{/*
Define a generic probe for the Airflow application.
This template dynamically configures either an HTTP probe or a TCP socket probe based on the provided parameters.
*/}}
{{- define "airflow.probes" -}}
{{- $path := .path -}}
{{- $port := .port -}}
{{- $probeType := .probeType -}}
{{- if eq $probeType "httpGet" }}
{{- include "airflow.httpProbes" (dict "path" $path "port" $port) }}
{{- else if eq $probeType "tcpSocket" }}
{{- include "airflow.tcpSocketProbes" (dict "port" $port) }}
{{- end }}
{{- end }}

{{/*
Define a persistent volume claim (PVC) for Airflow Home.
This template creates a PVC with the specified claim name.
*/}}
{{- define "airflow.home.pvc" -}}
- name: airflow-home
  persistentVolumeClaim:
    claimName: {{ include "airflow.claim.name" . }}
{{- end -}}

{{/*
Define a volume mount to the pod for Airflow Home.
This template creates a volume mount with the specified volume name.
*/}}
{{- define "airflow.home.volumeMount" -}}
- name: airflow-home
  mountPath: /opt/airflow
{{- end -}}

{{/*
Creates a base_url env to be added to the webserver.
*/}}
{{- define "airflow.webserver.baseUrlEnv" -}}
- name: AIRFLOW__WEBSERVER__BASE_URL
  value: http://localhost:8080{{ .Values.webserver.urlPrefix }}
{{- end -}}

{{/*
Creates a common secret env to be added to a Pod.
*/}}
{{- define "airflow.commonSecrets.env" -}}
- secretRef:
    name: {{ include "airflow.commonSecrets.name" . }}
{{- end -}}

{{/*
Define a security context for Airflow containers.
This template sets the specified user and group IDs for running the container.
*/}}
{{- define "airflow.securityContext" -}}
{{- $userID := .userID -}}
{{- $groupID := .groupID -}}
runAsUser: {{ $userID }}
runAsGroup: {{ $groupID }}
{{- end -}}

{{/*
Generate the checksum for the pvc and secret files.
This template calculates the SHA256 checksum of the specified files.
*/}}
{{- define "airflow.checksum" -}}
checksum/persistence: {{ include (print $.Template.BasePath "/persistence.yaml") . | sha256sum }}
checksum/secrets: {{ include (print $.Template.BasePath "/secrets.yaml") . | sha256sum }}
{{- end -}}

{{/*
Generate the checksum for the tls file.
This template calculates the SHA256 checksum of the tls file.
*/}}
{{- define "airflow.ingress.checksum" -}}
checksum/tls: {{ include (print $.Template.BasePath "/tls.yaml") . | sha256sum }}
{{- end -}}
