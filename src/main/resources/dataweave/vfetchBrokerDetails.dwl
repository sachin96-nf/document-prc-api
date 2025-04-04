%dw 2.0
output application/json
---
{
	"broker-details" : read(payload.prompts."broker-details".answer.value, "application/json"),
	"opportunity-data": read(payload.prompts."oppurtunity-data".answer.value, "application/json"),
}