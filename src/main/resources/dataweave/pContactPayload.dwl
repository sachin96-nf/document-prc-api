%dw 2.0
output application/json skipNullOn="everywhere"
import dataweave::regex
var broker_details=vars.client_details.'client-details'.broker_details
var broker_opp_details=vars.broker_opp_details.'broker-details'.broker_data
---
[
	{
		"RecordTypeId": Mule::p('salesforce.record_type.broker_account'),
		"FirstName": (broker_opp_details.name splitBy " ")[0],
		"LastName": (broker_opp_details.name splitBy " ")[1 to -1] joinBy " ",
		"AccountId": vars.broker_account_id,
		"Email": regex::nullChars(broker_opp_details.email),
		"Phone": if (broker_opp_details.contact is Array) broker_opp_details.contact[0] else regex::nullChars(broker_opp_details.contact),
		"MailingCity": regex::nullChars(broker_opp_details.address.city) default regex::nullChars(broker_details.address.city),
		"MailingCountry": 'United States',
		"MailingPostalCode": regex::nullChars(broker_opp_details.address.zip) default regex::nullChars(broker_details.address.zip),
		"MailingState": regex::nullChars(broker_opp_details.address.state) default regex::nullChars(broker_details.address.state),
		"MailingStreet": regex::nullChars(broker_opp_details.address.street) default regex::nullChars(broker_details.address.street)
	}
]