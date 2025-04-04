%dw 2.0
output application/json skipNullOn="everywhere"
import dataweave::nullCheck
var broker_details=vars.client_details.'client-details'.broker_details 
var broker_opp_details=vars.broker_opp_details.'broker-details'.broker_data
---
[
	{
		"RecordTypeId": Mule::p('sf.record_type.broker_account'),
		"FirstName": (broker_opp_details.name splitBy " ")[0],
		"LastName": (broker_opp_details.name splitBy " ")[1 to -1] joinBy " ",
		"AccountId": vars.broker_account_id,
		"Email": nullCheck::nullChars(broker_opp_details.email),
		"Phone": if (broker_opp_details.contact is Array) broker_opp_details.contact[0] else nullCheck::nullChars(broker_opp_details.contact),
		"MailingCity": nullCheck::nullChars(broker_opp_details.address.city) default nullCheck::nullChars(broker_details.address.city),
		"MailingCountry": 'United States',
		"MailingPostalCode": nullCheck::nullChars(broker_opp_details.address.zip) default nullCheck::nullChars(broker_details.address.zip),
		"MailingState": nullCheck::nullChars(broker_opp_details.address.state) default nullCheck::nullChars(broker_details.address.state),
		"MailingStreet": nullCheck::nullChars(broker_opp_details.address.street) default nullCheck::nullChars(broker_details.address.street)
	}
]