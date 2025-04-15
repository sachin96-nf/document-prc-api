%dw 2.0
output application/java
---
flatten(payload.body scan(/(?i)Scan file([A-Za-z]*\s*)*:\s*([^\r\n]+(\.pdf|\.docx|\.doc|\.xlsx|\.xlsm|\.xls|\.zip|\.png|\.jpg|\.jpeg))/))[2]