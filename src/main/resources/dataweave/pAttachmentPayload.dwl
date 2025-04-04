%dw 2.0
output application/json
---
payload map ( payload01 , indexOfPayload01 ) -> {
    LinkedEntityId: vars.opp_payload.items[0].id,
    ContentDocumentId: payload01.ContentDocumentId
}