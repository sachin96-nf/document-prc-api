%dw 2.0
output application/json
---
{
	"API Name": app.name,
	"Correlation Id": correlationId,
	"Email Subject": vars.emailSubject,
	"Broker Agency Name": payload[0].Name,
	"Error Type": (error.errorType.namespace default "ERROR") ++ ":" ++ (error.errorType.identifier default "INTERNAL_SERVER_ERROR"),
	"Error Code": vars.httpStatus,
	"Error Description": error.description,
	"Error Flow": ((error.suppressedErrors.failingComponent[0] default error.failingComponent) splitBy "/")[0],
	"Next Steps": "Please add required fields in the attachment for creating broker account in Salesforce and re-push the email"
}