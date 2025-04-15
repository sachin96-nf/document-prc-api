%dw 2.0
output application/java
import * from dw::core::Binaries
// Pick first DOC/DOCX
var docAttachment = vars.pdfPayload[0].key endsWith ".doc"
var encodedFile=toBase64(vars.pdfPayload[0].value as Binary) as String {
		class: "java.lang.String"
	}
---
{
	encodedFile: encodedFile,
	extension: if (docAttachment) "doc" else "docx"
}