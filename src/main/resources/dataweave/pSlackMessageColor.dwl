%dw 2.0
output application/json
var successbody=":white_check_mark: *Opportunity created successfully.*"
var errorbody=":red_circle: *Critical alert! Opportunity creation failed.*"
var body=if (isEmpty(payload."Error Type")) successbody else errorbody
var color=if (isEmpty(payload."Error Type")) "#36a64f" else "#ff0000"
var eliminator="\n------------------------------------------------------------------------------\n"
---
{
	"channel": Mule::p('slack.channel'),
	"text": eliminator ++ body,
	"attachments": [
        {
		 "color": color,
         "text": write(payload,"application/json") ++ eliminator
        }
    ]
}