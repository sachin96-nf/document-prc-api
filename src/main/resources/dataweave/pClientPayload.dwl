%dw 2.0
output application/json skipNullOn="everywhere"
import dataweave::regex
var client_details=vars.client_details.'client-details'.client_details
fun getFteRange(fte) =
	if (fte == null) "Unknown"
    else if (fte as Number <= 50) "50 or Less"
    else if (fte as Number <= 499) "51-499"
    else if (fte as Number <= 1999) "500-1,999"
    else "2,000+"
---
[
	{
		"RecordTypeId": Mule::p('salesforce.record_type.client'),
		"Name": regex::nullChars(client_details.name),
		"Email__c": regex::emailReplace(client_details.email replace  " " with "_"),
		"Company_Size__c": getFteRange(regex::nullChars(client_details.fte)),
		"BillingCity": regex::nullChars(client_details.address.city),
		"BillingCountry": 'United States',
		"BillingPostalCode": regex::nullChars(client_details.address.zip),
		"BillingState": regex::nullChars(client_details.address.state),
		"BillingStreet": regex::nullChars(client_details.address.street)
	}
]