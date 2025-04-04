%dw 2.0
fun escapeSingleQuote(str: String) =
    str replace "'" with "\'"
fun nullChars(str)=
    if ( str==null or lower(str)=="null" or str=="" or str==" " ) null else str
fun phoneCheck(data) =
 if ( data is Array ) data
 else if ( data startsWith "[" ) data replace "[" with "" replace "]" with "" splitBy "," map (item) -> trim(item) replace "'" with ""
 else data
 
//var broker_details=vars.client_details.'client-details'.broker_details 
//var broker_opp_details=vars.broker_opp_details.'broker-details'.broker_data
//var client_details=vars.client_details.'client-details'.client_details
//var opp_details=vars.broker_opp_details.'opportunity-data'.opportunity_data