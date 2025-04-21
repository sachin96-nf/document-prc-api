%dw 2.0
output application/json
import dataweave::regex
var client_details=vars.client_details.'client-details'.client_details
var opp_details=vars.broker_opp_details.'opportunity-data'.opportunity_data
var broker_opp_details=vars.broker_opp_details.'broker-details'.broker_data
---
{
	"Status": "Successfully created Opportunity in Salesforce",
	"Correlation Id": correlationId,
	"Email Subject": vars.emailSubject,
	"Email Sender": vars.fromAddress.fullName,
	"Opportunity Id": vars.opp_payload.items[0].id,
	"Opportunity Name": client_details.name,
	"Broker Contact": broker_opp_details.name,
	"Opportunity Owner": opp_details.name
}