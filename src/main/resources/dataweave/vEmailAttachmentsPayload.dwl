%dw 2.0
output application/java
---
entriesOf(payload.attachments mapObject ((value, key) -> {(key) : value.^raw})) default []