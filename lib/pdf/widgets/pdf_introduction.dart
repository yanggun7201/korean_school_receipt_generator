import 'package:pdf/widgets.dart';

class PdfIntroduction extends StatelessWidget {
  final ImageProvider logoImage;
  final double logoSize;

  PdfIntroduction({required this.logoImage, required this.logoSize});

  @override
  Widget build(Context context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(height: logoSize, width: logoSize, child: Image(logoImage)),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text("The Korean School of Auckland", style: TextStyle(fontSize: 13, fontWeight: FontWeight.normal)),
            SizedBox(height: 3),
            Text("Email: email@korea.school.nz", style: const TextStyle(fontSize: 11)),
          ],
        ),
      ],
    );
  }
}
