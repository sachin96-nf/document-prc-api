%dw 2.0
output application/json
import dataweave::regex
---
{
	"API Name": app.name,
	"Correlation Id": correlationId,
	"Email Subject": vars.emailSubject,
	"Email Sender": vars.fromAddress.fullName,
	"Broker Name": vars.broker_opp_details.'broker-details'.broker_data.name,
	"Opportunity Owner": vars.broker_opp_details.'opportunity-data'.opportunity_data.name default "",
	"Error Type": (error.errorType.namespace default "ERROR") ++ ":" ++ (error.errorType.identifier default "INTERNAL_SERVER_ERROR"),
	"Error Code": vars.httpStatus,
	"Error Description": error.description,
	"Error Flow": ((error.suppressedErrors.failingComponent[0] default error.failingComponent) splitBy "/")[0],
	"Next Steps": "Please add required fields in the Email body for creating broker contact in Salesforce and re-push the email"
}