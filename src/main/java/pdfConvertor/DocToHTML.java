package pdfConvertor;

import org.apache.poi.hwpf.HWPFDocument;
import org.apache.poi.hwpf.converter.WordToHtmlConverter;
import org.apache.poi.xwpf.usermodel.XWPFDocument;
import org.apache.poi.xwpf.usermodel.XWPFParagraph;
import org.apache.poi.xwpf.usermodel.XWPFRun;

import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;

import java.io.*;
import java.nio.charset.StandardCharsets;
import java.util.Base64;
import java.util.List;

import org.w3c.dom.Document;

public class DocToHTML {

    public static String convertDocOrDocxToHtml(String base64Input, String extension) {
        try {
            byte[] decodedBytes = Base64.getDecoder().decode(base64Input);
            try (InputStream inputStream = new ByteArrayInputStream(decodedBytes)) {

                if ("docx".equalsIgnoreCase(extension)) {
                    return convertDocxToHtml(inputStream);
                } else if ("doc".equalsIgnoreCase(extension)) {
                    return convertDocToHtml(inputStream);
                } else {
                    throw new IllegalArgumentException("Unsupported extension: " + extension);
                }

            }
        } catch (Exception e) {
            e.printStackTrace();
            return "<html><body>Error converting document: " + e.getMessage() + "</body></html>";
        }
    }

    private static String convertDocxToHtml(InputStream inputStream) throws IOException {
        XWPFDocument docx = new XWPFDocument(inputStream);
        StringBuilder html = new StringBuilder();
        html.append("<html><body>");
        for (XWPFParagraph para : docx.getParagraphs()) {
            html.append("<p>");
            List<XWPFRun> runs = para.getRuns();
            if (runs != null) {
                for (XWPFRun run : runs) {
                    String text = run.text();
                    if (text != null) {
                        html.append(escapeHtml(text));
                    }
                }
            }
            html.append("</p>");
        }
        html.append("</body></html>");
        docx.close();
        return html.toString();
    }

    private static String convertDocToHtml(InputStream inputStream) throws Exception {
        HWPFDocument doc = new HWPFDocument(inputStream);
        WordToHtmlConverter wordToHtmlConverter = new WordToHtmlConverter(
                DocumentBuilderFactory.newInstance().newDocumentBuilder().newDocument()
        );
        wordToHtmlConverter.processDocument(doc);
        Document htmlDoc = wordToHtmlConverter.getDocument();

        try (ByteArrayOutputStream out = new ByteArrayOutputStream()) {
            TransformerFactory tf = TransformerFactory.newInstance();
            Transformer serializer = tf.newTransformer();
            serializer.transform(new DOMSource(htmlDoc), new StreamResult(out));
            return out.toString(StandardCharsets.UTF_8);
        }
    }

    private static String escapeHtml(String text) {
        return text.replace("&", "&amp;")
                   .replace("<", "&lt;")
                   .replace(">", "&gt;");
    }
}
