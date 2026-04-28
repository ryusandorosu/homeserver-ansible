{{ range .Alerts }}
{{ if eq .Status "firing" }}🔴 {{ else if eq .Status "resolved" }}🟢 {{ end }}nuc-server grafana alert: {{ .Status }}: {{ if eq .Labels.severity "error" }}🔴 {{ else if eq .Labels.severity "warning" }}🟡 {{ end }}{{ with .Labels.severity }}{{ . }}{{ else }}n/a{{ end }}
Alert: <code>{{ .Labels.alertname }}</code>
Value: <code>{{ template "__text_values_list" . }}</code>
Threshold: <code>{{ .Annotations.threshold }}</code>
Description:
<i>{{ .Annotations.description }}</i>
{{if gt (len .GeneratorURL) 0}}<a href="{{.GeneratorURL}}">Alert</a>{{end}}{{if gt (len .PanelURL) 0}} | {{end}}{{if gt (len .PanelURL) 0}}<a href="{{.PanelURL}}">Dashboard panel</a>{{end}}
{{ end }}
