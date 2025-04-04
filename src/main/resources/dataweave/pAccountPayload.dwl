%dw 2.0
output application/json skipNullOn="everywhere"
import dataweave::nullCheck
var broker_details=vars.client_details.'client-details'.broker_details 
var broker_opp_details=vars.broker_opp_details.'broker-details'.broker_data
---
[
	{
		"RecordTypeId": Mule::p('sf.record_type.broker'),
		"Name": nullCheck::nullChars(broker_details.agency_name) default nullCheck::nullChars(broker_opp_details.name),
		"BillingCity": nullCheck::nullChars(broker_details.address.city) default nullCheck::nullChars(broker_opp_details.address.city),
		"BillingCountry": 'United States',
		"BillingPostalCode": nullCheck::nullChars(broker_details.address.zip) default nullCheck::nullChars(broker_opp_details.address.zip),
		"BillingState": nullCheck::nullChars(broker_details.address.state) default nullCheck::nullChars(broker_opp_details.address.state),
		"BillingStreet": nullCheck::nullChars(broker_details.address.street) default nullCheck::nullChars(broker_opp_details.address.street)
	}
]