import 'package:isar/isar.dart';

part 'receipt.g.dart';

@collection
class Receipt {
  Receipt(this.receiptPhoto, this.location, this.date, this.amount);
  Id id = Isar.autoIncrement;

  String? receiptPhoto;
  String? location;
  String? date;
  String? amount;
}