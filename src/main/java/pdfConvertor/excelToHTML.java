package pdfConvertor;

import java.io.*;
import java.text.SimpleDateFormat;
import java.util.Base64;

import org.apache.poi.ss.usermodel.*;
import org.apache.poi.EncryptedDocumentException;

public class excelToHTML {

    public static String excel2HtmlFromBase64(String base64Excel) throws Exception {
        byte[] excelBytes = Base64.getDecoder().decode(base64Excel);

        try (InputStream input = new ByteArrayInputStream(excelBytes);
             Workbook workbook = WorkbookFactory.create(input)) {

            StringBuilder html = new StringBuilder();
            html.append("<html><head><meta charset='UTF-8'></head><body>");

            for (int i = 0; i < workbook.getNumberOfSheets(); i++) {
                Sheet sheet = workbook.getSheetAt(i);
                html.append("<h3>").append(sheet.getSheetName()).append("</h3>");
                html.append("<table border='1' cellspacing='0' cellpadding='5'>");

                for (Row row : sheet) {
                    html.append("<tr>");
                    int lastColumn = row.getLastCellNum();
                    for (int cn = 0; cn < lastColumn; cn++) {
                        Cell cell = row.getCell(cn, Row.MissingCellPolicy.CREATE_NULL_AS_BLANK);
                        html.append("<td>").append(getCellValue(cell)).append("</td>");
                    }
                    html.append("</tr>");
                }

                html.append("</table><br/>");
            }

            html.append("</body></html>");
            return html.toString();

        } catch (EncryptedDocumentException e) {
            throw new IOException("Unable to process Excel file", e);
        }
    }

    private static String getCellValue(Cell cell) {
        if (cell == null) return "";

        switch (cell.getCellType()) {
            case STRING:
                return cell.getStringCellValue();
            case NUMERIC:
                if (DateUtil.isCellDateFormatted(cell)) {
                    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                    return sdf.format(cell.getDateCellValue());
                } else {
                    return String.valueOf(cell.getNumericCellValue());
                }
            case BOOLEAN:
                return Boolean.toString(cell.getBooleanCellValue());
            case FORMULA:
                try {
                    FormulaEvaluator evaluator = cell.getSheet().getWorkbook().getCreationHelper().createFormulaEvaluator();
                    CellValue evaluatedValue = evaluator.evaluate(cell);
                    switch (evaluatedValue.getCellType()) {
                        case STRING:
                            return evaluatedValue.getStringValue();
                        case NUMERIC:
                            return String.valueOf(evaluatedValue.getNumberValue());
                        case BOOLEAN:
                            return Boolean.toString(evaluatedValue.getBooleanValue());
                        case ERROR:
                            return FormulaError.forInt(evaluatedValue.getErrorValue()).getString();
                        default:
                            return "";
                    }
                } catch (Exception e) {
                    return "FORMULA_ERROR";
                }
            case ERROR:
                return FormulaError.forInt(cell.getErrorCellValue()).getString();
            case BLANK:
            default:
                return "";
        }
    }

}
