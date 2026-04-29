{{ $arrLength := len . -}}
{{ range $i, $value := . -}}
{{ $V := $value.Source.Value -}}
[
  {
  	"text": "Check IP: shodan.io",
  	"url": "https://www.shodan.io/host/{{ $V -}}"
  },
  {
  	"text": "Check IP: crowdsec.net",
  	"url": "https://app.crowdsec.net/cti/{{ $V -}}"
  }
]{{if lt $i ( sub $arrLength 1) }},{{end }}
{{end -}}
