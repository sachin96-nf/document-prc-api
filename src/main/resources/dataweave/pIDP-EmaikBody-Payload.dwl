%dw 2.0
output multipart/form-data
---
{
	"parts": {
		"file": {
			"headers": {
				"Content-Disposition": {
					"name": "file",
					"filename": "emailbody.pdf",
					"subtype": "form-data"
				},
				"Content-Type": "application/pdf"
			},
			"content": payload as Binary {
		        class: "byte[]"
		    }
		}
	}
}