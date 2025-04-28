%dw 2.0
output application/java
---
flatten(payload scan(/(?i)Notes([A-Za-z]*\s*)*:\s*([^\r\n].+)/))[2]