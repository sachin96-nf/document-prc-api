package pdfConvertor;

import org.apache.poi.xwpf.usermodel.*;
import com.openhtmltopdf.pdfboxout.PdfRendererBuilder;
import java.io.*;
import java.util.Base64;
import java.util.List;

public class DocToPdf {

    public static String convertDocOrDocxToPdf(String base64Input) {
        return convertDocxToPdf(base64Input);
    }

    private static String convertDocxToPdf(String base64Input) {
        ByteArrayOutputStream pdfOutputStream = new ByteArrayOutputStream();

        try {
            byte[] decodedBytes = Base64.getDecoder().decode(base64Input);
            InputStream inputStream = new ByteArrayInputStream(decodedBytes);

            XWPFDocument document = new XWPFDocument(inputStream);
            String html = generateStyledHtml(document);

            PdfRendererBuilder builder = new PdfRendererBuilder();
            builder.useFastMode();
            builder.withHtmlContent(html, null);
            builder.toStream(pdfOutputStream);
            builder.run();

        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }

        return Base64.getEncoder().encodeToString(pdfOutputStream.toByteArray());
    }

    private static String generateStyledHtml(XWPFDocument doc) {
        StringBuilder html = new StringBuilder();
        html.append("<html><head><style>")
            .append("body { font-family: Arial, sans-serif; font-size: 10pt; }")
            .append("h2 { font-size: 12pt; margin-top: 20px; margin-bottom: 10px; }")
            .append("p { margin: 4px 0; }")
            .append("table { width: 100%; border-collapse: collapse; margin-top: 10px; margin-bottom: 10px; }")
            .append("td, th { border: 1px solid #ccc; padding: 6px; vertical-align: top; }")
            .append(".section-title { font-weight: bold; margin-top: 20px; font-size: 11pt; }")
            .append(".subtext { margin-left: 10px; }")
            .append("</style></head><body>");

        List<IBodyElement> elements = doc.getBodyElements();
        for (IBodyElement element : elements) {
            if (element instanceof XWPFParagraph) {
                XWPFParagraph paragraph = (XWPFParagraph) element;
                String text = escapeHtml(paragraph.getText().trim());
                if (!text.isEmpty()) {
                    if (isSectionTitle(paragraph)) {
                        html.append("<h2>").append(text).append("</h2>");
                    } else {
                        html.append("<p>").append(text).append("</p>");
                    }
                }
            } else if (element instanceof XWPFTable) {
                XWPFTable table = (XWPFTable) element;
                html.append("<table>");
                for (XWPFTableRow row : table.getRows()) {
                    html.append("<tr>");
                    for (XWPFTableCell cell : row.getTableCells()) {
                        String cellText = escapeHtml(cell.getText().trim().replaceAll("\n", "<br/>"));
                        html.append("<td>").append(cellText).append("</td>");
                    }
                    html.append("</tr>");
                }
                html.append("</table>");
            }
        }

        html.append("</body></html>");
        return html.toString();
    }

    private static boolean isSectionTitle(XWPFParagraph paragraph) {
        if (paragraph.getStyle() != null && paragraph.getStyle().startsWith("Heading")) {
            return true;
        }
        for (XWPFRun run : paragraph.getRuns()) {
            if (run.isBold()) {
                return true;
            }
        }
        return false;
    }

    private static String escapeHtml(String text) {
        if (text == null) return "";
        return text.replace("&", "&amp;")
                   .replace("<", "&lt;")
                   .replace(">", "&gt;")
                   .replace("\"", "&quot;")
                   .replace("'", "&#39;");
    }
}
