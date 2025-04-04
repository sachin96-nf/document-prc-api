%dw 2.0
import dataweave::regex
output application/java
var opp_details=vars.broker_opp_details.'opportunity-data'.opportunity_data
---
"select Id from User where email='" ++ regex::escapeSingleQuote(opp_details.email default " ") ++ "' or Phone = '" ++ regex::escapeSingleQuote(opp_details.contact default " ") ++ "'"