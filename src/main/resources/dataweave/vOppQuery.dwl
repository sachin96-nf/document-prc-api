%dw 2.0
import dataweave::regex
output application/java
var opp_details=vars.broker_opp_details.'opportunity-data'.opportunity_data
var email=regex::escapeSingleQuote(regex::emailReplace(opp_details.email) default vars.fromAddress.address default " ")
var contact=regex::escapeSingleQuote(regex::nullChars(opp_details.contact) default " ")
---
"select Id from User where email like '" ++ email ++ "%' or Phone = '" ++ contact ++ "'"