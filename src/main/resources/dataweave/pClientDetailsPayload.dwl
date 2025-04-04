%dw 2.0
output application/json
---
{
	"client-details" : read(payload.prompts."client-details".answer.value, "application/json")
}