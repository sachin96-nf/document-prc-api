%dw 2.0
import dataweave::regex
var broker_details=vars.client_details.'client-details'.broker_details 
var broker_opp_details=vars.broker_opp_details.'broker-details'.broker_data
var name=regex::escapeSingleQuote(regex::nullChars(broker_details.agency_name) default regex::nullChars(broker_opp_details.name) default " ")
var street=regex::escapeSingleQuote(regex::nullChars(broker_details.address.street) default regex::nullChars(broker_opp_details.address.street) default " ")
var zip=regex::escapeSingleQuote(regex::nullChars(broker_details.address.zip) default regex::nullChars(broker_opp_details.address.zip) default " ")
output application/java
---
"select Id from Account where Name='" ++ name ++ "' AND BillingStreet='" ++ street ++ "' AND BillingPostalCode='" ++ zip ++ "'"