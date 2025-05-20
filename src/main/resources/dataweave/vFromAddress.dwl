%dw 2.0
output application/json
var name=attributes.fromAddresses[0] splitBy "<"
---
{
	"fullName": attributes.fromAddresses[0],
	"name" : trim(name[0]),
	"address": name[1] replace ">" with ""
}