%dw 2.0
output application/java
import dataweave::regex
var client_details=vars.client_details.'client-details'.client_details
var broker_details=vars.client_details.'client-details'.broker_details 
var opp_details=vars.broker_opp_details.'opportunity-data'.opportunity_data
var broker_opp_details=vars.broker_opp_details.'broker-details'.broker_data
var effectiveDate=if (regex::nullChars(broker_opp_details.effective_date default opp_details.received_date) != null) (broker_opp_details.effective_date default opp_details.received_date) as Date {format:"MM/dd/yyyy"} as Date  {format:"yyyy/MM/dd"} else null
var currentDate = now() as Date
var dateMinus30Days = (effectiveDate default currentDate) - |P30D|
var due_date=regex::nullChars(opp_details.due_date) default regex::nullChars(client_details.due_date)
var duedate=if (due_date != null) due_date as Date {format:"MM/dd/yyyy"} as Date  {format:"yyyy/MM/dd"} else null
var duedate_day=(duedate default "") as String {format: "EEEE"}
var carrier_values=['Aetna','Blues','Cigna','Curative','United Healthcare','Virgin','Self-Insured']
var Incumbent_Carrier_Notes__c="Other"
var funding_type=["Fully Insured", "Level Funded", "ASO"]
fun getStateCategory(market_value: String) =
    market_value match {
        case "FL"       -> "Florida: Other"
        case "TX"       -> "Texas: Other"
        case "GA"       -> "Georgia"
        case "FLORIDA"  -> "Florida: Other"
        case "TEXAS"    -> "Texas: Other"
        case "GEORGIA"  -> "Georgia"
        else              -> "Not in Florida Georgia or Texas"
    }
---
[
	{
		"External_Id__c": (client_details.name default "") ++ "_" ++ (broker_opp_details.name default "") ++ "_" ++ (broker_details.name default "") ++ "_" ++ (currentDate as String),
		"RecordTypeId": Mule::p('salesforce.record_type.opportunity'),
		"Name": regex::nullChars(client_details.name),
		"AccountId": vars.client_id,
		"Associated_Broker_Agency__c": vars.broker_account_id,
		"Broker_RFP_Contact__c": vars.broker_contact_id,
		"RFP_Received_Date__c": currentDate as Date {format:"yyyy/MM/dd"},
		"CloseDate": dateMinus30Days as Date {format:"yyyy/MM/dd"},
		"Effective_Date__c": effectiveDate,
		"RFP_Due_Date__c": if (["Saturday","Sunday"] contains(duedate_day)) null else duedate,
		"Market__c": getStateCategory(upper(client_details.address.state) default ""),
		"Sale_Type__c": "Full Replacement",
		"StageName": "Receipt of RFP",
		"Plan_Type__c": "Both",
		"Product_Offering__c": if (getStateCategory(upper(client_details.address.state) default "") == "Georgia") "PPO;PPOx/PPO/PPOmax (GA)" else "PPO;EPO/PPO/PPO Max",
		"OwnerId": payload[0].Id,
		"Proposed_Broker_External_Commission__c": (regex::nullChars(broker_opp_details.commission) default regex::nullChars(client_details.commission) default "") as String,
		"Proposed_Commission_Type__c": "Percent",
		"FTEs__c": regex::nullChars(client_details.fte),
		"Notes_to_Underwriting__c": vars.notes default "",
		"Incumbent_Carrier__c": if (carrier_values contains client_details.carrier.name) client_details.carrier.name else Incumbent_Carrier_Notes__c,
		"Incumbent_Funding_Type__c": if (funding_type contains client_details.carrier.'type') client_details.carrier.'type' else "",
		("Incumbent_Carrier_Notes__c": client_details.carrier.name) if !(carrier_values contains client_details.carrier.name)
	}
]