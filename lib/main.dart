import 'package:flutter/material.dart';
import 'package:korean_school_receipt_generator/pages/pdf_config_page/pdf_config_page.dart';
import 'package:korean_school_receipt_generator/theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: title,
      debugShowCheckedModeBanner: false,
      theme: theme(context),
      home: const PdfConfigPage(title: title),
    );
  }
}
