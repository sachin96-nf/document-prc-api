%dw 2.0
output application/json skipNullOn="everywhere"
import dataweave::regex
var broker_details=vars.client_details.'client-details'.broker_details
var broker_opp_details=vars.broker_opp_details.'broker-details'.broker_data
var name=regex::nullChars(broker_opp_details.name default broker_details.agency_name default vars.broker_name_email.name default "") splitBy " "
---
[
	{
		"RecordTypeId": Mule::p('salesforce.record_type.broker_account'),
		"FirstName": name[0],
		"LastName": (name[1 to -1] joinBy " ") default name[0],
		"AccountId": vars.broker_account_id,
		"Email": regex::emailReplace(broker_opp_details.email replace  " " with "_") default vars.broker_name_email.email,
		"Phone": if (broker_opp_details.contact is Array) broker_opp_details.contact[0] else regex::nullChars(broker_opp_details.contact),
		"MailingCity": regex::nullChars(broker_opp_details.address.city) default regex::nullChars(broker_details.address.city),
		"MailingCountry": 'United States',
		"MailingPostalCode": regex::nullChars(broker_opp_details.address.zip) default regex::nullChars(broker_details.address.zip),
		"MailingState": regex::nullChars(broker_opp_details.address.state) default regex::nullChars(broker_details.address.state),
		"MailingStreet": regex::nullChars(broker_opp_details.address.street) default regex::nullChars(broker_details.address.street)
	}
]