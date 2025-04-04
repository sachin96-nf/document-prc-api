%dw 2.0
output application/java
---
vars.emailPayload filter (vars.scan_pdf_filename contains $.key)