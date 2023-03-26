import 'package:pdf/widgets.dart';

class PdfHeader extends StatelessWidget {
  final String year;

  PdfHeader({
    required this.year,
  });

  @override
  Widget build(Context context) {
    return Column(children: [
      Text("RECEIPT", style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold)),
      SizedBox(height: 18),
      Text("for $year School Donation", style: const TextStyle(fontSize: 16)),
      SizedBox(height: 6),
      Text("GST No 69-324-002", style: const TextStyle(fontSize: 14)),
    ]);
  }
}
