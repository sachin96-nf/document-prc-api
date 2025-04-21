%dw 2.0
output application/json
var name=attributes.fromAddresses[0] splitBy "<"
---
{
	"fullName": name,
	"name" : trim(name[0]),
	"address": name[1] replace ">" with ""
}