import 'package:isar/isar.dart';

import 'receipt.dart';

part 'user.g.dart';

@collection
class User {
  User(this.firstName, this.lastName, this.emailAdress, this.password);
  Id id = Isar.autoIncrement;
  String? firstName;
  String? lastName;
  
  @Index(unique: true)
  String? emailAdress;

  String? password;

  final receipts = IsarLinks<Receipt>();
}