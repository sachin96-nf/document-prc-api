%dw 2.0
import * from dw::Runtime
output application/json
---
{
	"sleep": ""
} wait (Mule::p('sleep.freq') as Number)