class Invoice{
  int number;
  DateTime date;
  double amount;
  String companyName;
  bool hasVat;
  InvoiceStatus status;
}

class InvoiceStatus{
  final String value;
  const InvoiceStatus._internal(this.value);
  static const POSTED = InvoiceStatus._internal("Posted");
  static const PAID = InvoiceStatus._internal("Paid");
  static const CANCELLED = InvoiceStatus._internal("Cancelled");

  static List<InvoiceStatus> toList() {
    return [POSTED, PAID, CANCELLED];
  }
}

class InvoiceFilter{
  int number;
  DateTime minDate;
  DateTime maxDate;
  double minAmount;
  double maxAmount;
  String companyNameLike;
  bool hasVat;
  List<InvoiceStatus> statuses = InvoiceStatus.toList();
}