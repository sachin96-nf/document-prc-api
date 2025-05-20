%dw 2.0
output application/json
import dataweave::regex
var client_details=vars.client_details.'client-details'.client_details
var opp_details=vars.broker_opp_details.'opportunity-data'.opportunity_data
var broker_opp_details=vars.broker_opp_details.'broker-details'.broker_data
var broker_details=vars.client_details.'client-details'.broker_details
var status= if (vars.oppCreatedStatus) "Successfully created Opportunity in Salesforce" else "Opportunity already exists in Salesforce"
---
{
	"Status": status,
	"Correlation Id": correlationId,
	"Email Subject": vars.emailSubject,
	"Email Sender": vars.fromAddress.fullName,
	"Opportunity Id": vars.opp_payload.items[0].id,
	"Opportunity Name": client_details.name,
	"Broker Contact": broker_opp_details.name default broker_details.name,
	"Opportunity Owner": opp_details.name
}