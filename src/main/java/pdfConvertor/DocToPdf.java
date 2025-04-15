package pdfConvertor;

import java.io.*;
import java.util.Base64;
import org.apache.poi.xwpf.usermodel.XWPFDocument;
//import org.apache.poi.hwpf.HWPFDocument;
import org.apache.poi.xwpf.converter.pdf.PdfConverter;
import org.apache.poi.xwpf.converter.pdf.PdfOptions;
import fr.opensagres.poi.xwpf.converter.core.XWPFConverterException;
//import org.apache.pdfbox.pdmodel.PDDocument;
//import org.apache.pdfbox.pdmodel.PDPage;
//import org.apache.pdfbox.pdmodel.PDPageContentStream;
//import org.apache.pdfbox.pdmodel.common.PDRectangle;
//import org.apache.pdfbox.pdmodel.graphics.image.PDImageXObject;
//import org.apache.pdfbox.rendering.PDFRenderer;

//import java.awt.image.BufferedImage;
//import javax.imageio.ImageIO;
//

public class DocToPdf {

	public static String convertDocOrDocxToPdf(String base64Input, String extension) {
        ByteArrayOutputStream pdfOutputStream = new ByteArrayOutputStream();

        try {
            byte[] decodedBytes = Base64.getDecoder().decode(base64Input);
            InputStream inputStream = new ByteArrayInputStream(decodedBytes);

            if (extension.equalsIgnoreCase("docx")) {
                XWPFDocument docx = new XWPFDocument(inputStream);
                PdfOptions options = PdfOptions.create();
                PdfConverter.getInstance().convert(docx, pdfOutputStream, options);
            } else if (extension.equalsIgnoreCase("doc")) {
                //HWPFDocument doc = new HWPFDocument(inputStream);
                // Convert DOC to PDF logic (Apache POI doesn't support direct DOC to PDF)
                // You might use doc ➝ HTML ➝ PDF or a library like JODConverter + LibreOffice
                throw new UnsupportedOperationException("Direct DOC to PDF is not supported in POI. Use a service like LibreOffice.");
            }

        } catch (XWPFConverterException e) {
            e.printStackTrace();
        } catch (Exception e) {
            System.err.println("Error during DOC/DOCX to PDF conversion: " + e.getMessage());
        }

        return Base64.getEncoder().encodeToString(pdfOutputStream.toByteArray());
    }
//    public static String convertDocOrDocxToPdf1(String base64Input, String extension) {
//        ByteArrayOutputStream pdfOutputStream = new ByteArrayOutputStream();
//
//        try {
//            byte[] decodedBytes = Base64.getDecoder().decode(base64Input);
//            InputStream inputStream = new ByteArrayInputStream(decodedBytes);
//
//            if (extension.equalsIgnoreCase("docx")) {
//                XWPFDocument docx = new XWPFDocument(inputStream);
//                PdfOptions options = PdfOptions.create();
//
//                // Convert DOCX to PDF (temp PDF)
//                ByteArrayOutputStream tempPdf = new ByteArrayOutputStream();
//                PdfConverter.getInstance().convert(docx, tempPdf, options);
//
//                // Load the converted PDF
//                PDDocument originalDoc = PDDocument.load(new ByteArrayInputStream(tempPdf.toByteArray()));
//                PDFRenderer pdfRenderer = new PDFRenderer(originalDoc);
//
//                PDDocument adjustedDoc = new PDDocument();
//                float margin = 30; // points (~0.4 inches)
//
//                for (int i = 0; i < originalDoc.getNumberOfPages(); i++) {
//                    BufferedImage pageImage = pdfRenderer.renderImageWithDPI(i, 300); // High-res image
//
//                    PDPage newPage = new PDPage(PDRectangle.LETTER); // or mediaBox from original
//                    adjustedDoc.addPage(newPage);
//
//                    PDImageXObject pdImage = PDImageXObject.createFromByteArray(adjustedDoc, toByteArray(pageImage), "page-image");
//
//                    PDRectangle mediaBox = newPage.getMediaBox();
//                    float width = mediaBox.getWidth() - 2 * margin;
//                    float height = mediaBox.getHeight() - 2 * margin;
//
//                    PDPageContentStream contentStream = new PDPageContentStream(adjustedDoc, newPage);
//                    contentStream.drawImage(pdImage, margin, margin, width, height);
//                    contentStream.close();
//                }
//
//                originalDoc.close();
//                adjustedDoc.save(pdfOutputStream);
//                adjustedDoc.close();
//            } else if (extension.equalsIgnoreCase("doc")) {
//                throw new UnsupportedOperationException("Direct DOC to PDF is not supported in POI. Use a service like LibreOffice.");
//            }
//
//        } catch (XWPFConverterException e) {
//            e.printStackTrace();
//        } catch (Exception e) {
//            System.err.println("Error during DOC/DOCX to PDF conversion: " + e.getMessage());
//        }
//
//        return Base64.getEncoder().encodeToString(pdfOutputStream.toByteArray());
//    }
    
//    private static byte[] toByteArray(BufferedImage image) throws IOException {
//        ByteArrayOutputStream baos = new ByteArrayOutputStream();
//        ImageIO.write(image, "png", baos);
//        return baos.toByteArray();
//    }
}