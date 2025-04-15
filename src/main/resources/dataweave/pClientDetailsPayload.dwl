%dw 2.0
output application/json
var detail=payload.prompts."client-details".answer.value default ""
---
{
	"client-details" : read(((detail replace "```" with "") replace "json{" with "{"), "applications/json")
}