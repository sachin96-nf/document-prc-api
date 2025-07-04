%dw 2.0
output application/java
import dataweave::regex
var broker_data = vars.broker_opp_details.'broker-details'.broker_data
var broker_details=vars.client_details.'client-details'.broker_details 
var email = regex::escapeSingleQuote(regex::nullChars(broker_data.email replace  " " with "_") default regex::nullChars(broker_details.email replace  " " with "_") default vars.broker_name_email.email default " ")
var contact=regex::phoneCheck(broker_data.contact)
var contacts = 
    if (contact is Array) 
    contact 
    else if (contact != null) 
    [contact] 
    else [] // Convert string to an array for consistency
var validContacts = contacts filter ($ != null and $ != "") // Remove null/empty values
var phoneCondition = 
    if (validContacts != []) 
    " OR Phone IN (" ++ ((validContacts map ("'" ++ $ ++ "'")) joinBy ",") ++ ")" 
    else "" // Avoids adding an empty IN clause---
---
"SELECT Id, Name, AccountId, Email FROM Contact WHERE Email = '" ++ email ++ "'" ++ phoneCondition
