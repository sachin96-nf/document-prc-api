package pdfConvertor;

import java.io.*;
import com.itextpdf.html2pdf.ConverterProperties;
import com.itextpdf.html2pdf.HtmlConverter;
import com.itextpdf.kernel.geom.PageSize;
import com.itextpdf.kernel.pdf.PdfWriter;
import com.itextpdf.kernel.pdf.PdfDocument;
import com.itextpdf.layout.Document;

public class htmlToPDF {
    public static FileInputStream createpdf(String htmlContent, String outputPath) throws IOException {
        // Set up the output stream
        FileOutputStream fOut = new FileOutputStream(outputPath);
        PdfWriter writer = new PdfWriter(fOut);
        PdfDocument pdfDoc = new PdfDocument(writer);
        
        // Use landscape A3 or larger for wide tables
        pdfDoc.setDefaultPageSize(PageSize.A3.rotate());

        Document document = new Document(pdfDoc);
        ConverterProperties props = new ConverterProperties();

        // Inject some basic styles for better layout
        String styledHtml = "<html><head><style>" +
            "table { width: 100%; table-layout: fixed; border-collapse: collapse; font-size: 10px; }" +
            "td, th { word-wrap: break-word; border: 1px solid #000; padding: 3px; }" +
            "h3 { text-align: center; }" +
            "</style></head><body>" + htmlContent + "</body></html>";

        HtmlConverter.convertToPdf(styledHtml, pdfDoc, props);
        document.close();
        System.out.println("PDF Created Successfully");

        return new FileInputStream(outputPath);
    }
}
