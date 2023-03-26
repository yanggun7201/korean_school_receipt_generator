import 'package:flutter/services.dart' show Uint8List, rootBundle;
import 'package:korean_school_receipt_generator/models/invoice.dart';
import 'package:korean_school_receipt_generator/models/korean_fonts.dart';
import 'package:korean_school_receipt_generator/pdf/widgets/pdf_body.dart';
import 'package:korean_school_receipt_generator/pdf/widgets/pdf_footer.dart';
import 'package:korean_school_receipt_generator/pdf/widgets/pdf_header.dart';
import 'package:korean_school_receipt_generator/pdf/widgets/pdf_introduction.dart';
import 'package:pdf/widgets.dart';

const logoSize = 84.0;
const signImageSize = 124.0;
const String nanumSquareRoundBPath = 'assets/fonts/NanumSquareRoundB.ttf';
const String nanumSquareRoundLPath = 'assets/fonts/NanumSquareRoundL.ttf';

Future<Uint8List> makePdf(Invoice invoice) async {
  Font koreanLightFont = Font.ttf(await rootBundle.load(nanumSquareRoundLPath));
  Font koreanBoldFont = Font.ttf(await rootBundle.load(nanumSquareRoundBPath));
  var koreanFonts = KoreanFonts(light: koreanLightFont, bold: koreanBoldFont);

  final logoImage = MemoryImage((await rootBundle.load('assets/images/korean_school_logo.png')).buffer.asUint8List());
  final signImage = MemoryImage((await rootBundle.load('assets/images/korean_school_sign.png')).buffer.asUint8List());

  final pdf = Document();

  pdf.addPage(
    Page(
      build: (context) {
        return Column(
          children: [
            SizedBox(height: 10),
            PdfIntroduction(logoSize: logoSize, logoImage: logoImage),
            SizedBox(height: 30),
            PdfHeader(year: invoice.currentYear),
            SizedBox(height: 20),
            PdfBody(invoice: invoice, koreanFonts: koreanFonts),
            PdfFooter(invoice: invoice, signImageSize: signImageSize, signImage: signImage)
          ],
        );
      },
    ),
  );
  return pdf.save();
}
