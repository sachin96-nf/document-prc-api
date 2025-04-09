%dw 2.0
import dataweave::regex
output application/java
var opp_details=vars.broker_opp_details.'opportunity-data'.opportunity_data
---
"select Id from User where email like '" ++ regex::escapeSingleQuote(regex::nullChars(opp_details.email) default " ") ++ "%' or Phone = '" ++ regex::escapeSingleQuote(regex::nullChars(opp_details.contact) default " ") ++ "'"