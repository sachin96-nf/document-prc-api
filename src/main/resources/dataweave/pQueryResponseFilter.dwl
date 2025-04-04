%dw 2.0
output application/json
import dataweave::regex
var email = vars.broker_opp_details.'broker-details'.broker_data.email
var emailfilter=payload filter ((item, index) -> item.Email==email)
---
if (!isEmpty(emailfilter)) emailfilter else payload