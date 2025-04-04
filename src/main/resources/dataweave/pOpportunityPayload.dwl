%dw 2.0
output application/java
import dataweave::nullCheck
var client_details=vars.client_details.'client-details'.client_details
var opp_details=vars.broker_opp_details.'opportunity-data'.opportunity_data
var broker_opp_details=vars.broker_opp_details.'broker-details'.broker_data
var currentDate = now() as Date
var dateMinus30Days = currentDate - |P30D|
var carrier_values=['Aetna','Blues','Cigna','Curative','United Healthcare','Virgin','Self-Insured']
var Incumbent_Carrier_Notes__c="Other"
var funding_type=["Fully Insured", "Level Funded", "ASO"]
fun getStateCategory(market_value: String) =
    market_value match {
        case "(FL)"       -> "Florida: Other"
        case "(TX)"       -> "Texas: Other"
        case "(GA)"       -> "Georgia"
        case "(FLORIDA)"  -> "Florida: Other"
        case "(TEXAS)"    -> "Texas: Other"
        case "(GEORGIA)"  -> "Georgia"
        else              -> "Not in Florida Georgia or Texas"
    }
---
[
	{
		"RecordTypeId": Mule::p('sf.record_type.opportunity'),
		"Name": nullCheck::nullChars(client_details.name),
		"AccountId": vars.client_id,
		"Associated_Broker_Agency__c": vars.broker_account_id,
		"Broker_RFP_Contact__c": vars.Broker_RFP_Contact__c,
		"Effective_Date__c": currentDate as Date {format:"yyyy/MM/dd"},
		"CloseDate": dateMinus30Days as Date {format:"yyyy/MM/dd"},
		"RFP_Received_Date__c": if (nullCheck::nullChars(opp_details.received_date) != null) opp_details.received_date as Date {format:"MM/dd/yyyy"} as String {format:"yyyy/MM/dd"} as Date  {format:"yyyy/MM/dd"} else null,
		"RFP_Due_Date__c": if (nullCheck::nullChars(opp_details.due_date) != null) opp_details.due_date as Date {format:"MM/dd/yyyy"} as String {format:"yyyy/MM/dd"} as Date  {format:"yyyy/MM/dd"} else null,
		"Market__c": getStateCategory(upper(client_details.address.state) default ""),
		"Sale_Type__c": "Full Replacement",
		"StageName": "Receipt of RFP",
		"Plan_Type__c": "Both",
		"Product_Offering__c": "PPO;EPO/PPO/PPO Max",
		"OwnerId": payload[0].Id,
		"Proposed_Broker_External_Commission__c": (nullCheck::nullChars(broker_opp_details.commission) default "") as String,
		"Proposed_Commission_Type__c": "Percent",
		"FTEs__c": nullCheck::nullChars(client_details.fte),
		"Incumbent_Carrier__c": if (carrier_values contains client_details.carrier.name) client_details.carrier.name else Incumbent_Carrier_Notes__c,
		"Incumbent_Funding_Type__c": if (funding_type contains client_details.carrier.'type') client_details.carrier.'type' else "",
		("Incumbent_Carrier_Notes__c": client_details.carrier.name) if !(carrier_values contains client_details.carrier.name)
	}
]