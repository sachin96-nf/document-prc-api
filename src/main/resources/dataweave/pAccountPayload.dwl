%dw 2.0
output application/json skipNullOn="everywhere"
import dataweave::regex
var broker_details=vars.client_details.'client-details'.broker_details 
var broker_opp_details=vars.broker_opp_details.'broker-details'.broker_data
---
[
	{
		"RecordTypeId": Mule::p('salesforce.record_type.broker'),
		"Name": regex::nullChars(broker_details.agency_name) default regex::nullChars(broker_opp_details.name),
		"BillingCity": regex::nullChars(broker_details.address.city) default regex::nullChars(broker_opp_details.address.city),
		"BillingCountry": 'United States',
		"BillingPostalCode": regex::nullChars(broker_details.address.zip) default regex::nullChars(broker_opp_details.address.zip),
		"BillingState": regex::nullChars(broker_details.address.state) default regex::nullChars(broker_opp_details.address.state),
		"BillingStreet": regex::nullChars(broker_details.address.street) default regex::nullChars(broker_opp_details.address.street)
	}
]