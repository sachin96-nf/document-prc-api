%dw 2.0
output application/json
var str=(flatten(payload.body scan(/(?i)From([A-Za-z]*\s*)*:\s*([^\r\n].+)/))[5]) splitBy ("<")
---
{
    "name": trim(str[0]),
    "email": trim(str[1]) replace ">" with "",
    "agency": trim((str[1] splitBy "@")[1]) replace ".com>" with ""
}