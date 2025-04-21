%dw 2.0
output application/json
---
{
	"API Name": app.name,
	"Correlation Id": correlationId,
	"Email Subject": vars.emailSubject,
	"Email Sender": vars.fromAddress.fullName,
	"Client Name": payload[0].Name,
	"Opportunity Owner": vars.broker_opp_details.'opportunity-data'.opportunity_data.name default "",
	"Error Type": (error.errorType.namespace default "ERROR") ++ ":" ++ (error.errorType.identifier default "INTERNAL_SERVER_ERROR"),
	"Error Code": vars.httpStatus,
	"Error Description": error.description,
	"Error Flow": ((error.suppressedErrors.failingComponent[0] default error.failingComponent) splitBy "/")[0],
	"Next Steps": "Please add required fields in the Email body for creating Client account in Salesforce and re-push the email"
}