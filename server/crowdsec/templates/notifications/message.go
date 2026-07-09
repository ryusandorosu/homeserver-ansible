[CrowdSec]
{{range . -}}
{{$alert := . -}}

{{range .Decisions -}}
Scenario: {{.Scenario}}
Decision: {{.Type}}
IP: {{.Value}}
Duration: {{.Duration}}
{{end -}}

{{end -}}
