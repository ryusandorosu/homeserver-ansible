{{ range .Alerts }}
{{ if eq .Status "firing" }}🔴 {{ else if eq .Status "resolved" }}🟢 {{ end }}nuc-server grafana alert: {{ .Status }}: {{ if eq .Labels.severity "error" }}🔴 {{ else if eq .Labels.severity "warning" }}🟡 {{ end }}{{ with .Labels.severity }}{{ . }}{{ else }}n/a{{ end }}
Alert: <code>{{ with .Annotations.alertname }}{{ . }}{{ else with .Labels.alertname }}{{ . }}{{ else }}n/a{{ end }}</code>
Value: <code>{{ if len .Values }}{{range $$refID, $$value := .Values}}
{{$$refID}} = {{$$value}}{{end}}{{ else }}n/a{{ end }}</code>
Threshold: <code>{{ with .Annotations.threshold }}{{ . }}{{ else }}n/a{{ end }}</code>
Description:
<i>{{ with .Annotations.description }}{{ . }}{{ else }}n/a{{ end }}</i>
{{if gt (len .GeneratorURL) 0}}<a href="{{.GeneratorURL}}">Alert</a>{{end}}{{if gt (len .PanelURL) 0}} | {{end}}{{if gt (len .PanelURL) 0}}<a href="{{.PanelURL}}">Dashboard panel</a>{{end}}
{{ end }}
