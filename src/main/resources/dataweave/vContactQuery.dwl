%dw 2.0
output application/java
import dataweave::regex
var broker_data = vars.broker_opp_details.'broker-details'.'broker_data'
var contacts = 
    if (broker_data.contact is Array) 
    broker_data.contact 
    else if (broker_data.contact != null) 
    [broker_data.contact] 
    else [] // Convert string to an array for consistency
var validContacts = contacts filter ($ != null and $ != "") // Remove null/empty values
var phoneCondition = 
    if (validContacts != []) 
    " OR Phone IN (" ++ ((validContacts map ("'" ++ $ ++ "'")) joinBy ",") ++ ")" 
    else "" // Avoids adding an empty IN clause---
---
"SELECT Id, Name, AccountId, Email FROM Contact WHERE Email = '" ++ regex::escapeSingleQuote(broker_data.email default " ") ++ "'" ++ phoneCondition
