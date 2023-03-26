import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show Offset, Rect, Uint8List, rootBundle;
import 'package:korean_school_receipt_generator/models/invoice.dart';
import 'package:korean_school_receipt_generator/models/korean_fonts.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:syncfusion_flutter_pdf/pdf.dart';

const logoSize = 76.0;
const String nanumSquareRoundBPath = 'assets/fonts/NanumSquareRoundB.ttf';
const String nanumSquareRoundLPath = 'assets/fonts/NanumSquareRoundL.ttf';

Future<Uint8List> makeGridPdf(Invoice invoice) async {
  pw.Font koreanLightFont = pw.Font.ttf(await rootBundle.load(nanumSquareRoundLPath));
  pw.Font koreanBoldFont = pw.Font.ttf(await rootBundle.load(nanumSquareRoundBPath));
  var koreanFonts = KoreanFonts(light: koreanLightFont, bold: koreanBoldFont);
  print("____ koreanFonts: $koreanFonts");

  PdfDocument document = PdfDocument();

  //Add page to the PDF
  final PdfPage page = document.pages.add();
  //Get page client size
  final Size pageSize = page.getClientSize();

  //Draw rectangle
  page.graphics.drawRectangle(
      bounds: Rect.fromLTWH(0, 0, pageSize.width, pageSize.height), pen: PdfPen(PdfColor(142, 170, 219)));

  // Logo
  var asUint8List = (await rootBundle.load('assets/images/korean_school_logo.jpg')).buffer.asUint8List();
  var pdfBitmap = PdfBitmap(asUint8List);
  // page.graphics.drawImage(pdfBitmap, Rect.fromLTWH(0, 0, logoSize, logoSize));

  //Generate PDF grid.
  final PdfGrid grid = _getGrid();
  //Draw the header section by creating text element
  final PdfLayoutResult result = _drawHeader(page, pageSize, pdfBitmap, grid);
  //Draw grid
  _drawGrid(page, grid, result);
  //Add invoice footer
  _drawFooter(page, pageSize);

//Save the document.
  var list = await document.save();

  return Uint8List.fromList(list);
}

//Draws the invoice header
PdfLayoutResult _drawHeader(PdfPage page, Size pageSize, PdfImage logo, PdfGrid grid) {
  //Draw rectangle
  // page.graphics.drawRectangle(
  //     brush: PdfSolidBrush(PdfColor(91, 126, 215)), bounds: Rect.fromLTWH(0, 0, pageSize.width - 115, 90));

  page.graphics.drawImage(logo, Rect.fromLTWH(0, 0, logoSize, logoSize));

  page.graphics.drawString("The Korean School of Auckland", PdfStandardFont(PdfFontFamily.helvetica, 13),
      bounds: Rect.fromLTWH(300, 0, 200, 30),
      brush: PdfBrushes.black,
      format: PdfStringFormat(alignment: PdfTextAlignment.right, lineAlignment: PdfVerticalAlignment.middle));

  page.graphics.drawString(
      "Email: email@korea.school.nz", PdfStandardFont(PdfFontFamily.helvetica, 11, style: PdfFontStyle.regular),
      bounds: Rect.fromLTWH(300, 20, 200, 20),
      brush: PdfBrushes.black,
      format: PdfStringFormat(alignment: PdfTextAlignment.right, lineAlignment: PdfVerticalAlignment.middle));

  page.graphics.drawString('RECEIPT', PdfStandardFont(PdfFontFamily.helvetica, 36, style: PdfFontStyle.bold),
      brush: PdfBrushes.black,
      bounds: Rect.fromLTWH(25, 96, pageSize.width, 90),
      format: PdfStringFormat(alignment: PdfTextAlignment.center, lineAlignment: PdfVerticalAlignment.middle));

  page.graphics.drawString('for 2023 School Donation', PdfStandardFont(PdfFontFamily.helvetica, 15),
      brush: PdfBrushes.black,
      bounds: Rect.fromLTWH(25, 136, pageSize.width, 90),
      format: PdfStringFormat(alignment: PdfTextAlignment.center, lineAlignment: PdfVerticalAlignment.middle));
  page.graphics.drawString('GST No 69-324-002', PdfStandardFont(PdfFontFamily.helvetica, 13),
      brush: PdfBrushes.black,
      bounds: Rect.fromLTWH(25, 156, pageSize.width, 90),
      format: PdfStringFormat(alignment: PdfTextAlignment.center, lineAlignment: PdfVerticalAlignment.middle));

  return PdfTextElement(text: "", font: PdfStandardFont(PdfFontFamily.helvetica, 9))
      .draw(page: page, bounds: Rect.fromLTWH(30, 190, 0, 0))!;
}

//Draws the grid
void _drawGrid(PdfPage page, PdfGrid grid, PdfLayoutResult result) {
  Rect? totalPriceCellBounds;
  Rect? quantityCellBounds;
  //Invoke the beginCellLayout event.
  grid.beginCellLayout = (Object sender, PdfGridBeginCellLayoutArgs args) {
    final PdfGrid grid = sender as PdfGrid;
    if (args.cellIndex == grid.columns.count - 1) {
      totalPriceCellBounds = args.bounds;
    } else if (args.cellIndex == grid.columns.count - 2) {
      quantityCellBounds = args.bounds;
    }
  };
  //Draw the PDF grid and get the result.
  result = grid.draw(page: page, bounds: Rect.fromLTWH(8, result.bounds.bottom + 40, 0, 0))!;
  //Draw grand total.
  page.graphics.drawString('Grand Total', PdfStandardFont(PdfFontFamily.helvetica, 9, style: PdfFontStyle.bold),
      bounds: Rect.fromLTWH(
          quantityCellBounds!.left, result.bounds.bottom + 10, quantityCellBounds!.width, quantityCellBounds!.height));
  page.graphics.drawString(
      _getTotalAmount(grid).toString(), PdfStandardFont(PdfFontFamily.helvetica, 9, style: PdfFontStyle.bold),
      bounds: Rect.fromLTWH(totalPriceCellBounds!.left, result.bounds.bottom + 10, totalPriceCellBounds!.width,
          totalPriceCellBounds!.height));
}

//Draw the invoice footer data.
void _drawFooter(PdfPage page, Size pageSize) {
  final PdfPen linePen = PdfPen(PdfColor(142, 170, 219), dashStyle: PdfDashStyle.custom);
  linePen.dashPattern = <double>[3, 3];
  //Draw line
  page.graphics.drawLine(linePen, Offset(0, pageSize.height - 100), Offset(pageSize.width, pageSize.height - 100));
  const String footerContent =
      '800 Interchange Blvd.\r\n\r\nSuite 2501, Austin, TX 78721\r\n\r\nAny Questions? support@adventure-works.com';
  //Added 30 as a margin for the layout
  page.graphics.drawString(footerContent, PdfStandardFont(PdfFontFamily.helvetica, 9),
      format: PdfStringFormat(alignment: PdfTextAlignment.right),
      bounds: Rect.fromLTWH(pageSize.width - 30, pageSize.height - 70, 0, 0));
}

//Create PDF grid and return
PdfGrid _getGrid() {
  //Create a PDF grid
  final PdfGrid grid = PdfGrid();

  //Set the grid style
  grid.style = PdfGridStyle(
      // cellPadding: PdfPaddings(left: 2, right: 3, top: 4, bottom: 5),
      // backgroundBrush: PdfBrushes.blue,
      // textBrush: PdfBrushes.white,
      font: PdfCjkStandardFont(PdfCjkFontFamily.hanyangSystemsGothicMedium, 13));

  // PdfCjkStandardFont(PdfCjkFontFamily.hanyangSystemsGothicMedium, 20),

  //Specify the columns count to the grid.
  grid.columns.add(count: 5);
  //Create the header row1 of the grid.
  // final PdfGridRow headerRow = grid.headers.add(1)[0];
  //Set style
  // headerRow.style.backgroundBrush = PdfSolidBrush(PdfColor(68, 114, 196));
  // headerRow.style.textBrush = PdfBrushes.white;
  // headerRow.cells[0].value = 'Product Id';
  // headerRow.cells[0].stringFormat.alignment = PdfTextAlignment.center;
  // headerRow.cells[1].value = 'Product Name';
  // headerRow.cells[2].value = 'Price';
  // headerRow.cells[3].value = 'Quantity';
  // headerRow.cells[4].value = 'Total';

  final PdfGridRow row1 = grid.rows.add();
  row1.cells[0].value = "DONATED BY:";
  row1.cells[0].rowSpan = 2;
  row1.cells[1].value = "Donghoon Lee";
  row1.cells[1].rowSpan = 2;
  row1.cells[2].value = "CODE";
  row1.cells[3].value = "NORTH";
  row1.cells[4].value = "48";

  final PdfGridRow row2 = grid.rows.add();
  row2.cells[0].value = "0";
  row2.cells[1].value = "1";
  row2.cells[2].value = "CLASS";
  row2.cells[3].value = "은가람";
  row2.cells[3].columnSpan = 2;
  row2.cells[4].value = "4";

  _addProducts('CA-1098', 'AWC Logo Cap', 8.99, 2, 17.98, grid);
  _addProducts('LJ-0192', 'Long-Sleeve Logo Jersey,M', 49.99, 3, 149.97, grid);
  _addProducts('So-B909-M', 'Mountain Bike Socks,M', 9.5, 2, 19, grid);
  _addProducts('LJ-0192', 'Long-Sleeve Logo Jersey,M', 49.99, 4, 199.96, grid);
  _addProducts('FK-5136', 'ML Fork', 175.49, 6, 1052.94, grid);
  _addProducts('HL-U509', 'Sports-100 Helmet,Black', 34.99, 1, 34.99, grid);
  // grid.applyBuiltInStyle(PdfGridBuiltInStyle.listTable4Accent5);
  grid.columns[0].width = 130;
  grid.columns[1].width = 150;
  grid.columns[2].width = 100;
  grid.columns[3].width = 70;
  grid.columns[4].width = 50;

  grid.rows[0].cells[0].style = PdfGridCellStyle(
    backgroundBrush: PdfSolidBrush(PdfColor(253, 233, 217)),
    // cellPadding: PdfPaddings(left: 2, right: 3, top: 4, bottom: 5),
    font: PdfStandardFont(PdfFontFamily.helvetica, 12),
    // font: PdfCjkStandardFont(PdfCjkFontFamily.hanyangSystemsGothicMedium, 13),
    textBrush: PdfSolidBrush(PdfColor(5, 112, 19)),
    textPen: PdfPen(PdfColor(5, 112, 192), width: 1),
  );

  // for (int i = 0; i < headerRow.cells.count; i++) {
  //   headerRow.cells[i].style.cellPadding = PdfPaddings(bottom: 5, left: 5, right: 5, top: 5);
  // }
  for (int i = 0; i < grid.rows.count; i++) {
    final PdfGridRow row = grid.rows[i];
    for (int j = 0; j < row.cells.count; j++) {
      final PdfGridCell cell = row.cells[j];

      // if (j == 0) {
      cell.stringFormat.alignment = PdfTextAlignment.center;
      cell.stringFormat.lineAlignment = PdfVerticalAlignment.middle;
      // }
      // cell.style.cellPadding = PdfPaddings(bottom: 5, left: 5, right: 5, top: 5);
    }
  }
  return grid;
}

//Create and row for the grid.
void _addProducts(String productId, String productName, double price, int quantity, double total, PdfGrid grid) {
  final PdfGridRow row = grid.rows.add();
  row.cells[0].value = productId;
  row.cells[1].value = productName;
  row.cells[2].value = price.toString();
  row.cells[3].value = quantity.toString();
  row.cells[4].value = total.toString();
}

//Get the total amount.
double _getTotalAmount(PdfGrid grid) {
  double total = 0;
  for (int i = 0; i < grid.rows.count; i++) {
    final String value = grid.rows[i].cells[grid.columns.count - 1].value as String;
    total += double.parse(value);
  }
  return total;
}
