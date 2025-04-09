%dw 2.0
import dataweave::regex
var client=vars.client_details.'client-details'.client_details
var email=regex::escapeSingleQuote(regex::nullChars(client.email replace  " " with "_") default " ")
var name=regex::escapeSingleQuote(regex::nullChars(client.name) default " ")
output application/java
---
"select Id from Account where Email__c='" ++ email ++ "' OR Name='" ++ name ++ "'"