import 'package:korean_school_receipt_generator/models/invoice.dart';
import 'package:korean_school_receipt_generator/models/korean_fonts.dart';
import 'package:korean_school_receipt_generator/models/payment.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';

class PdfBody extends StatelessWidget {
  final Invoice invoice;
  final KoreanFonts koreanFonts;

  PdfBody({
    required this.invoice,
    required this.koreanFonts,
  });

  @override
  Widget build(Context context) {
    Payment regularClassPayment = invoice.getRegularClassPayment();
    Payment? specialClassPayment = invoice.getSpecialClassPayment();

    return Table(
      border: TableBorder.all(color: PdfColors.black),
      children: [
        TableRow(
          children: [_buildFirstBlock(invoice, koreanFonts)],
        ),
        TableRow(
          children: [_buildBlankBlock(invoice, koreanFonts, 6)],
        ),
        TableRow(
          children: [_buildThirdBlock(invoice, koreanFonts)],
        ),
        TableRow(
          children: [_buildPaymentBlock(regularClassPayment, koreanFonts)],
        ),
        if (specialClassPayment != null)
          TableRow(
            children: [
              _buildPaymentBlock(specialClassPayment, koreanFonts),
            ],
          ),
        TableRow(
          children: [
            _buildBlankBlock(
              invoice,
              koreanFonts,
              (specialClassPayment == null) ? 46 : 30,
            ),
          ],
        ),
        TableRow(
          children: [_buildLastSummaryBlock(invoice, koreanFonts)],
        ),
      ],
    );
  }

  Widget _buildFirstBlock(Invoice invoice, KoreanFonts koreanFonts) {
    Map<int, TableColumnWidth> columnWidths = {};

    //515
    columnWidths.putIfAbsent(0, () => const FixedColumnWidth(130.0));
    columnWidths.putIfAbsent(1, () => const FixedColumnWidth(170.0));
    columnWidths.putIfAbsent(2, () => const FixedColumnWidth(80.0));
    columnWidths.putIfAbsent(3, () => const FixedColumnWidth(135.0));

    const headerTextStyle = TextStyle(color: PdfColor.fromInt(0xff0570c0));
    const headerBackgroundStyle = PdfColor.fromInt(0xfffde9d9);

    return Table(
      border: TableBorder.all(color: PdfColors.black),
      columnWidths: columnWidths,
      children: [
        TableRow(
          children: [
            Container(
              height: 60,
              child: Center(
                child: Text("DONATED BY:", style: headerTextStyle),
              ),
              color: headerBackgroundStyle,
            ),
            Container(
              height: 60,
              child: Center(child: Text(invoice.irdEnglishName)),
            ),
            Table(border: TableBorder.all(color: PdfColors.black), children: [
              TableRow(children: [
                Container(
                    height: 30,
                    color: headerBackgroundStyle,
                    child: Center(child: Text("CODE", style: headerTextStyle)))
              ]),
              TableRow(children: [
                Container(
                    height: 30,
                    color: headerBackgroundStyle,
                    child: Center(child: Text("CLASS", style: headerTextStyle)))
              ]),
            ]),
            Table(border: TableBorder.all(color: PdfColors.black), children: [
              TableRow(
                children: [
                  Table(border: TableBorder.all(color: PdfColors.black), children: [
                    TableRow(children: [
                      Container(height: 30, child: Center(child: Text(invoice.schoolLocation))),
                      Container(height: 30, width: 20, child: Center(child: Text("${invoice.receiptNumber}"))),
                    ]),
                  ]),
                ],
              ),
              TableRow(
                children: [
                  Container(
                      height: 30,
                      child: Center(child: Text(invoice.className, style: TextStyle(font: koreanFonts.bold)))),
                ],
              ),
            ]),
          ],
        )
      ],
    );
  }

  Widget _buildBlankBlock(Invoice invoice, KoreanFonts koreanFonts, double height) {
    return Table(
      border: TableBorder.all(color: PdfColors.black),
      children: [
        TableRow(
          children: [
            Padding(
              padding: EdgeInsets.all(height),
            )
          ],
        )
      ],
    );
  }

  Widget _buildThirdBlock(Invoice invoice, KoreanFonts koreanFonts) {
    Map<int, TableColumnWidth> columnWidths = {};

    columnWidths.putIfAbsent(0, () => const FixedColumnWidth(130.0));
    columnWidths.putIfAbsent(1, () => const FixedColumnWidth(515 - 130 - 135));
    columnWidths.putIfAbsent(2, () => const FixedColumnWidth(135.0));

    const headerTextStyle = TextStyle(color: PdfColor.fromInt(0xff0570c0));
    const headerBackgroundStyle = PdfColor.fromInt(0xfffde9d9);

    return Table(
      border: TableBorder.all(color: PdfColors.black),
      columnWidths: columnWidths,
      children: [
        TableRow(
          children: [
            Container(
              height: 30,
              child: Center(
                child: Text("DATE", style: headerTextStyle),
              ),
              color: headerBackgroundStyle,
            ),
            Container(
              height: 30,
              child: Center(
                child: Text("DESCRIPTION", style: headerTextStyle),
              ),
              color: headerBackgroundStyle,
            ),
            Container(
              height: 30,
              child: Center(
                child: Text("PAYMENT", style: headerTextStyle),
              ),
              color: headerBackgroundStyle,
            ),
          ],
        )
      ],
    );
  }

  Widget _buildPaymentBlock(Payment payment, KoreanFonts koreanFonts) {
    Map<int, TableColumnWidth> columnWidths = {};

    columnWidths.putIfAbsent(0, () => const FixedColumnWidth(130.0));
    columnWidths.putIfAbsent(1, () => const FixedColumnWidth(170.0));
    columnWidths.putIfAbsent(2, () => const FixedColumnWidth(80.0));
    columnWidths.putIfAbsent(3, () => const FixedColumnWidth(135.0));

    return Table(
      border: TableBorder.all(color: PdfColors.black),
      columnWidths: columnWidths,
      children: [
        TableRow(
          children: [
            Container(
              height: 30,
              child: Center(
                child: Text(payment.classPaidDate),
              ),
            ),
            Container(
              height: 30,
              child: Center(
                child: Text(payment.name),
              ),
            ),
            Container(
              height: 30,
              child: Center(
                child: Text(payment.classTypeName),
              ),
            ),
            Container(
              height: 30,
              child: Center(
                child: Text("${payment.classCost}"),
              ),
            ),
          ],
        )
      ],
    );
  }

  Widget _buildLastSummaryBlock(Invoice invoice, KoreanFonts koreanFonts) {
    const headerTextStyle = TextStyle(color: PdfColor.fromInt(0xff0570c0));
    const headerBackgroundStyle = PdfColor.fromInt(0xfffde9d9);

    return Table(
      border: TableBorder.all(color: PdfColors.black),
      children: [
        TableRow(
          children: [
            Container(
              color: headerBackgroundStyle,
              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Container(
                  height: 50,
                  width: 130,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                          child: Text("합계",
                              style: TextStyle(color: const PdfColor.fromInt(0xff0570c0), font: koreanFonts.bold))),
                      Center(child: Text("(Total Payment)", style: headerTextStyle)),
                    ],
                  ),
                ),
                SizedBox(
                    width: 135,
                    child: Center(child: Text("\$${invoice.totalCost}", style: const TextStyle(fontSize: 16))))
              ]),
            ),
          ],
        )
      ],
    );
  }
}
