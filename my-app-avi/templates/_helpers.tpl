{{/*
Expand the name of the chart.
*/}}
{{- define "my-app-avi.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "my-app-avi.fullname" -}}
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
Create chart name and version as used by the chart label.
*/}}
{{- define "my-app-avi.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "my-app-avi.labels" -}}
helm.sh/chart: {{ include "my-app-avi.chart" . }}
{{ include "my-app-avi.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "my-app-avi.selectorLabels" -}}
app.kubernetes.io/name: {{ include "my-app-avi.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "my-app-avi.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "my-app-avi.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Define image name
*/}}
{{- define "my-app-avi.imageName" -}}
{{- default .Chart.Name .Values.image.name  | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Define image tag
*/}}
{{- define "my-app-avi.imageTag" -}}
{{- default .Chart.AppVersion .Values.image.tag | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Define image URL
*/}}
{{- define "my-app-avi.imageURL" -}}
{{- if .Values.image.tag -}}
{{- printf "%s/%s:%s" .Values.image.repository (include "my-app-avi.imageName" .) (include "my-app-avi.imageTag" .) -}}
{{- else -}}
{{- printf "%s/%s" .Values.image.repository (include "my-app-avi.imageName" .) -}}
{{- end -}}
{{- end -}}

