import 'package:korean_school_receipt_generator/models/payment.dart';

class Invoice {
  final String className;
  final String koreanName;
  final String englishName;
  final int receiptNumber;
  final String irdEnglishName;
  final double regularClassCost;
  final String regularClassPaidDate;
  final double specialClassCost;
  final String specialClassPaidDate;
  final double totalCost;
  final String issueDate;
  final String currentYear;
  final String schoolLocation;

  Invoice({
    required this.className,
    required this.koreanName,
    required this.englishName,
    required this.receiptNumber,
    required this.irdEnglishName,
    required this.regularClassCost,
    required this.regularClassPaidDate,
    required this.specialClassCost,
    required this.specialClassPaidDate,
    required this.totalCost,
    required this.issueDate,
    required this.currentYear,
    required this.schoolLocation,
  });

  String getSummary() {
    return "$className-$receiptNumber-$koreanName-$irdEnglishName-$totalCost";
  }

  Payment getRegularClassPayment() {
    return Payment(
      name: englishName,
      classCost: regularClassCost,
      classPaidDate: regularClassPaidDate,
      classTypeName: "AM",
    );
  }

  Payment? getSpecialClassPayment() {
    if (specialClassCost == 0) {
      return null;
    }

    return Payment(
      name: englishName,
      classCost: specialClassCost,
      classPaidDate: specialClassPaidDate,
      classTypeName: "PM",
    );
  }

  Invoice copyWith({
    String? className,
    String? koreanName,
    String? englishName,
    int? receiptNumber,
    String? irdEnglishName,
    double? regularClassCost,
    String? regularClassPaidDate,
    double? specialClassCost,
    String? specialClassPaidDate,
    double? totalCost,
    String? issueDate,
    String? currentYear,
    String? schoolLocation,
  }) {
    return Invoice(
      className: className ?? this.className,
      koreanName: koreanName ?? this.koreanName,
      englishName: englishName ?? this.englishName,
      receiptNumber: receiptNumber ?? this.receiptNumber,
      irdEnglishName: irdEnglishName ?? this.irdEnglishName,
      regularClassCost: regularClassCost ?? this.regularClassCost,
      regularClassPaidDate: regularClassPaidDate ?? this.regularClassPaidDate,
      specialClassCost: specialClassCost ?? this.specialClassCost,
      specialClassPaidDate: specialClassPaidDate ?? this.specialClassPaidDate,
      totalCost: totalCost ?? this.totalCost,
      issueDate: issueDate ?? this.issueDate,
      currentYear: currentYear ?? this.currentYear,
      schoolLocation: schoolLocation ?? this.schoolLocation,
    );
  }
}
