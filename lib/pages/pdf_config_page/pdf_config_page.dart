import 'dart:io';

import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:korean_school_receipt_generator/models/invoice.dart';
import 'package:korean_school_receipt_generator/pages/pdf_preview_page/pdf_preview_page.dart';
import 'package:korean_school_receipt_generator/pdf/pdfexport.dart';
import 'package:korean_school_receipt_generator/utils/file_utils.dart';
import 'package:korean_school_receipt_generator/utils/number_utils.dart';
import 'package:korean_school_receipt_generator/utils/snack_bar_utils.dart';
import 'package:path_provider/path_provider.dart';

const title = 'The Korean School of Auckland';

const locations = [
  "NORTH",
  "WEST",
  "EAST",
];

const pdfFileDirectoryPrefix = "한국학교영수증_";

class PdfConfigPage extends StatefulWidget {
  const PdfConfigPage({super.key, required this.title});

  final String title;

  @override
  State<PdfConfigPage> createState() => _PdfConfigPageState();
}

class _PdfConfigPageState extends State<PdfConfigPage> {
  String year = '';
  String location = 'NORTH';
  int dataCount = 0;
  int genCount = 0;
  String issueDate = '';
  String savedDirectory = '';
  bool isGenerating = false;
  bool isSelectingCsvFile = false;
  List<Invoice> invoices = [];
  final DateFormat dateFormat = DateFormat("dd/MM/yyyy");
  final DateFormat directoryFormat = DateFormat("yyyy_MM_dd_HH_mm_ss");
  final globalKey = GlobalKey<ScaffoldState>();
  final TextEditingController yearController = TextEditingController();

  @override
  void initState() {
    super.initState();

    var currentYear = '${DateTime.now().year}';

    setState(() {
      year = currentYear;
      yearController.text = currentYear;
      issueDate = dateFormat.format(DateTime.now());
    });
  }

  void _previewInvoice() async {
    if (invoices.isNotEmpty) {
      Navigator.push(context, MaterialPageRoute(builder: (_) => PdfPreviewPage(invoice: invoices.elementAt(0))));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: globalKey,
      appBar: AppBar(title: Text(widget.title)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            _buildYearTextFormField(),
            const SizedBox(height: 10),
            _buildLocationTextFormField(),
            const SizedBox(height: 30),
            if (dataCount == 0) const Text('CSV 파일을 선택해 주세요.', style: TextStyle(fontSize: 20)),
            if (dataCount != 0) ...[
              if (isGenerating == false && genCount == 0)
                Text('처리할 데이터가 $dataCount 건 입니다.', style: const TextStyle(fontSize: 20)),
              if (isGenerating == false && genCount == dataCount)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('$dataCount 건의 영수증 PDF 파일을 생성하였습니다.', style: const TextStyle(fontSize: 20)),
                    const SizedBox(width: 10),
                    ElevatedButton(onPressed: _openSavedDirectory, child: const Text('폴더 열기')),
                  ],
                ),
              if (isGenerating == true) Text('$genCount / $dataCount 처리 중 입니다.', style: const TextStyle(fontSize: 20)),
              const SizedBox(height: 20),
              ElevatedButton(onPressed: _generatePdfFiles, child: const Text('영수증 만들기')),
              const SizedBox(height: 50),
            ],
            const SizedBox(height: 20),
            ElevatedButton(onPressed: _selectCsvFile, child: const Text('Select CSV File')),
          ],
        ),
      ),
      floatingActionButton: Visibility(
        visible: dataCount > 0,
        child: FloatingActionButton(
          onPressed: _previewInvoice,
          tooltip: '영수증 미리보기',
          child: const Icon(Icons.preview),
        ),
      ),
    );
  }

  Widget _buildYearTextFormField() {
    return SizedBox(
      width: 300,
      child: TextFormField(
        controller: yearController,
        // style: const TextStyle(color: Colors.deepPurple),
        decoration: const InputDecoration(
          icon: Icon(Icons.calendar_month),
          hintText: '년도를 입력하세요.',
          labelText: 'Year *',
          hintStyle: TextStyle(fontSize: 18),
          labelStyle: TextStyle(fontSize: 18),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.deepPurpleAccent),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.deepPurpleAccent),
          ),
        ),
        style: TextStyle(fontSize: 18),
        onChanged: (newValue) {
          setState(() {
            year = newValue;
          });
        },
      ),
    );
  }

  Widget _buildLocationTextFormField() {
    return SizedBox(
      width: 300,
      child: DropdownButtonFormField<String>(
        value: location,
        decoration: const InputDecoration(
          hintText: '학교 위치를 선택하세요.',
          labelText: 'Location *',
          hintStyle: TextStyle(fontSize: 18),
          labelStyle: TextStyle(fontSize: 18),
          prefixIcon: Icon(Icons.location_city),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.deepPurpleAccent),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.deepPurpleAccent),
          ),
        ),
        style: const TextStyle(fontSize: 18, color: Colors.black),
        items: locations.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: (newValue) {
          setState(() {
            location = newValue!;
          });
        },
      ),
    );
  }

  void _selectCsvFile() async {
    if (isSelectingCsvFile) {
      return;
    }

    isSelectingCsvFile = true;
    setState(() {
      isSelectingCsvFile = true;
    });

    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv'],
    );

    isSelectingCsvFile = false;
    setState(() {
      isSelectingCsvFile = false;
    });

    if (result != null) {
      final file = File(result.files.single.path!);
      final contents = await file.readAsString();
      List<List<dynamic>> rowsAsListOfValues = const CsvToListConverter().convert(contents);

      _initState();

      List<Invoice> invoiceList = [];
      for (List<dynamic> row in rowsAsListOfValues) {
        if (row[0].toString().isEmpty || row[0].toString() == "#") {
          continue;
        }
        invoiceList.add(toInvoice(row));
      }

      setState(() {
        dataCount = invoiceList.length;
        invoices = invoiceList;
      });
    }
  }

  void _initState() {
    setState(() {
      genCount = 0;
      dataCount = 0;
      isGenerating = false;
      invoices = [];
      savedDirectory = '';
    });
  }

  Invoice toInvoice(List<dynamic> row) {
    Invoice invoice = Invoice(
      // number: row[0],
      className: row[1],
      koreanName: row[2],
      englishName: row[3],
      receiptNumber: row[4],
      irdEnglishName: row[5],
      regularClassCost: NumberUtils.parseDouble(row[6].toString()),
      regularClassPaidDate: row[7],
      specialClassCost: NumberUtils.parseDouble(row[8].toString()),
      specialClassPaidDate: row[9],
      totalCost: NumberUtils.parseDouble(row[10].toString()),
      issueDate: issueDate,
      currentYear: year,
      schoolLocation: location,
    );

    _validateOf(invoice);

    return invoice;
  }

  void _generatePdfFiles() async {
    setState(() {
      genCount = 0;
      isGenerating = true;
    });

    var distDirectory = await _getDistDirectory();

    if (await FileUtils.createNewDirectory(distDirectory) == null) {
      SnackBarUtils.showSnackBar(context, "디렉토리를 생성하는데 실패하였습니다.");
      return;
    }

    List<Invoice> targetInvoices = getInvoicesWithConfigurations();

    for (Invoice invoice in targetInvoices) {
      final file = File('$distDirectory$s${invoice.getSummary()}.pdf');
      await file.writeAsBytes(await makePdf(invoice));
      setState(() {
        genCount = genCount + 1;
      });
    }

    SnackBarUtils.showSnackBar(context, '$distDirectory 폴더에 저장되었습니다.');

    setState(() {
      savedDirectory = distDirectory;
      isGenerating = false;
    });
  }

  List<Invoice> getInvoicesWithConfigurations() {
    return invoices.map((e) => e.copyWith(currentYear: year, schoolLocation: location)).toList();
  }

  void _openSavedDirectory() {
    FileUtils.openSavedDirectory(context, savedDirectory);
  }

  String get s => Platform.pathSeparator;

  Future<String> _getDistDirectory() async {
    final documentsDirectory = await _getDocumentDirectory();
    return '$documentsDirectory${s}Documents$s$pdfFileDirectoryPrefix$year$s${directoryFormat.format(DateTime.now())}';
  }

  Future<String> _getDocumentDirectory() async {
    if (Platform.isMacOS) {
      return Directory.current.absolute.path;
    }

    final applicationDocumentsDirectory = await getApplicationDocumentsDirectory();
    return applicationDocumentsDirectory.parent.parent.path;
  }

  void _validateOf(Invoice invoice) {
    if (invoice.totalCost != (invoice.regularClassCost + invoice.specialClassCost)) {
      var validationErrorMessage = '[${invoice.receiptNumber} - ${invoice.koreanName}] 정규반+특활반 금액이 합계 금액과 일치하지 않습니다.';
      SnackBarUtils.showSnackBar(context, validationErrorMessage);
      assert(invoice.totalCost == (invoice.regularClassCost + invoice.specialClassCost), validationErrorMessage);
    }
  }
}
