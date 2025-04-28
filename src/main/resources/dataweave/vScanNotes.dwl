%dw 2.0
output application/java
---
flatten(payload.body scan(/(?i)Notes to Underwriting([A-Za-z]*\s*)*:\s*([^\r\n].+)/))[2]