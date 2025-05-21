package pdfConvertor;
import java.io.*;
import com.itextpdf.html2pdf.ConverterProperties;
import com.itextpdf.html2pdf.HtmlConverter;
import com.itextpdf.kernel.geom.PageSize;
import com.itextpdf.kernel.pdf.*;
import com.itextpdf.layout.Document;
import org.jsoup.Jsoup;
import org.jsoup.nodes.*;
import org.jsoup.select.Elements;

public class htmlToPDF {

	public static FileInputStream createpdf(String htmlContent, String outputPath) throws IOException {
		if (htmlContent == null || htmlContent.trim().isEmpty()) {
			throw new IllegalArgumentException("HTML content is empty or null.");
		}

		// Sanitize HTML content to avoid layout/parsing issues
		String cleanedHtml = sanitizeHtml(htmlContent);

		// Wrap with basic HTML styles
		String styledHtml = "<html><head><style>"
				+ "table { width: 100%; table-layout: fixed; border-collapse: collapse; font-size: 10px; }"
				+ "td, th { word-wrap: break-word; border: 1px solid #000; padding: 3px; }"
				+ "h3 { text-align: center; }" + "</style></head><body>" + cleanedHtml + "</body></html>";

		// Step 1: Convert to PDF in memory
		ByteArrayOutputStream pdfBytes = new ByteArrayOutputStream();
		PdfWriter tempWriter = new PdfWriter(pdfBytes);
		PdfDocument tempPdfDoc = new PdfDocument(tempWriter);
		tempPdfDoc.setDefaultPageSize(PageSize.A3.rotate());

		try {
			ConverterProperties props = new ConverterProperties();
			HtmlConverter.convertToPdf(styledHtml, tempPdfDoc, props);
		} catch (Exception e) {
			e.printStackTrace();
			throw new RuntimeException("HTML to PDF conversion failed: " + e.getMessage(), e);
		} finally {
			tempPdfDoc.close();
		}

		// Step 2: Read from memory, trim to 40 pages if needed
		PdfDocument fullPdf = new PdfDocument(new PdfReader(new ByteArrayInputStream(pdfBytes.toByteArray())));
		PdfWriter finalWriter = new PdfWriter(outputPath);
		PdfDocument finalPdf = new PdfDocument(finalWriter);

		int totalPages = fullPdf.getNumberOfPages();
		int pagesToCopy = Math.min(totalPages, 40);

		fullPdf.copyPagesTo(1, pagesToCopy, finalPdf);

		fullPdf.close();
		finalPdf.close();

		System.out.println("PDF Created Successfully at: " + outputPath + " (Pages: " + pagesToCopy + ")");
		return new FileInputStream(outputPath);
	}

	// Helper method to clean empty rows/cells
	private static String sanitizeHtml(String html) {
		org.jsoup.nodes.Document doc = Jsoup.parse(html);

		// Remove empty <tr> tags
		Elements rows = doc.select("tr");
		for (Element row : rows) {
			Elements cells = row.select("td");
			boolean allEmpty = true;
			for (Element cell : cells) {
				if (!cell.text().trim().isEmpty()) {
					allEmpty = false;
					break;
				}
			}
			if (allEmpty) {
				row.remove();
			}
		}

		// Replace empty <td> with non-breaking space
		Elements cells = doc.select("td");
		for (Element cell : cells) {
			if (cell.text().trim().isEmpty()) {
				cell.html("&nbsp;");
			}
		}

		return doc.body().html(); //️ Return as String, NOT a JSoup Document
	}
}