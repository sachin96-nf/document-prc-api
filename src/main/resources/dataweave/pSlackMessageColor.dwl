%dw 2.0
output application/json
var successbody=":white_check_mark: *Opportunity created successfully.*"
var errorbody=":red_circle: *Critical alert! Opportunity creation failed.*"
var body=if (isEmpty(payload."Error Type")) successbody else errorbody
var color=if (isEmpty(payload."Error Type")) "#36a64f" else "#ff0000"
fun replaceKey(k) = "*" ++ k ++ "*"
fun boldPayload(obj) = obj mapObject ((value, key, index) -> (replaceKey(key)) : value)
var eliminator="\n------------------------------------------------------------------------------\n"
---
{
	"channel": Mule::p('slack.channel'),
	"text": if (!isEmpty(payload."Error Type")) "<!here>" ++ eliminator ++ body else eliminator ++ body,
	"attachments": [
        {
		 "color": color,
         "text": write(boldPayload(payload-"API Name"-"Error Code"-"Error Flow"),"application/json") ++ eliminator
        }
    ]
}