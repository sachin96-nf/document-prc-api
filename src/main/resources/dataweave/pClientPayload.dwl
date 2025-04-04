%dw 2.0
output application/json skipNullOn="everywhere"
import dataweave::nullCheck
var client_details=vars.client_details.'client-details'.client_details 
fun getFteRange(fte) =
	if (fte == null) null
    else if (fte as Number <= 50) "50 or Less"
    else if (fte as Number <= 499) "51-499"
    else if (fte as Number <= 1999) "500-1,999"
    else "2,000+"
---
[
	{
		"RecordTypeId": Mule::p('sf.record_type.client'),
		"Name": nullCheck::nullChars(client_details.name),
		"Email__c": nullCheck::nullChars(client_details.email),
		"Company_Size__c": getFteRange(client_details.fte),
		"BillingCity": nullCheck::nullChars(client_details.address.city),
		"BillingCountry": 'United States',
		"BillingPostalCode": nullCheck::nullChars(client_details.address.zip),
		"BillingState": nullCheck::nullChars(client_details.address.state),
		"BillingStreet": nullCheck::nullChars(client_details.address.street)
	}
]