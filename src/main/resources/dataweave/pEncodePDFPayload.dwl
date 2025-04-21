%dw 2.0
output application/java
import * from dw::core::Binaries
---
{
	encodedFile: toBase64(vars.pdfPayload[0].value as Binary) as String {
		class: "java.lang.String"
	}
}