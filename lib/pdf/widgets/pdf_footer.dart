import 'package:korean_school_receipt_generator/models/invoice.dart';
import 'package:pdf/widgets.dart';

class PdfFooter extends StatelessWidget {
  final Invoice invoice;
  final double signImageSize;
  final MemoryImage signImage;

  PdfFooter({
    required this.invoice,
    required this.signImageSize,
    required this.signImage,
  });

  @override
  Widget build(Context context) {
    return SizedBox(
      width: 500,
      child: Stack(
        children: [
          Column(
            children: [
              Padding(
                padding: EdgeInsets.all(50),
              ),
              Padding(
                child: Center(
                  child: Text(
                    "Issue Date: ${invoice.issueDate}",
                    style: TextStyle(fontSize: 14),
                  ),
                ),
                padding: EdgeInsets.all(6),
              ),
              Padding(
                child: Text(
                  "The Korean School of Auckland",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                padding: EdgeInsets.all(10),
              ),
              Padding(
                padding: EdgeInsets.all(20),
              ),
            ],
          ),
          Positioned(
            right: 40,
            bottom: 20,
            child: SizedBox(height: signImageSize, width: signImageSize, child: Image(signImage)),
          )
        ],
      ),
    );
  }
}
