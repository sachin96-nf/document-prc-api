%dw 2.0
import dataweave::regex
output application/java
---
"select Id from User where email='" ++ regex::escapeSingleQuote(vars.broker_opp_details.'opportunity-data'.opportunity_data.email default " ") ++ "' or Phone = '" ++ regex::escapeSingleQuote(vars.broker_opp_details.'opportunity-data'.opportunity_data.contact default " ") ++ "'"