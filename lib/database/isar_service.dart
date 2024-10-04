import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:isar/isar.dart';

import 'user.dart';
import 'receipt.dart';

// Functions to communicate with isar database
class IsarService {
  late Future<Isar> db;
  IsarService() {
    db = openDB();
  }

  Future<Isar> openDB() async {
    var dir = await getApplicationDocumentsDirectory();
    if (Isar.instanceNames.isEmpty) {
      return await Isar.open(
        [UserSchema, ReceiptSchema],
        directory: dir.path,
      );
    }
    return Future.value(Isar.getInstance());
  }
  
  Future<void> saveUser(User newUser) async {
    final isar = await db;
    isar.writeTxnSync(() => isar.users.putSync(newUser));
  }
  
  Future<void> updateUser(User user) async {
    final isar = await db;
    await isar.writeTxn(() async {
      await isar.users.put(user);
    });
  }
  
  Future<void> deleteUser(User? user) async {
    final isar = await db;

    isar.writeTxn(() {
      for (var receipt in user!.receipts) {
        isar.receipts.delete(receipt.id);
      }

      return isar.users.delete(user.id);
    });
  }

  Future<User?> validateUser(String email, String password) async {
    final isar = await db;
    final user = await isar.users.filter()
      .emailAdressEqualTo(email)
      .and()
      .passwordEqualTo(password)
      .findFirst();
    return user;
  }

  Future<void> addReceipt(User? user, Receipt receipt) async {
    final isar = await db;
    isar.writeTxnSync(() => isar.receipts.putSync(receipt));
    user?.receipts.add(receipt);
    await isar.writeTxn(() async {
      await user?.receipts.save();
    });
    saveImageToFileSystem(File(receipt.receiptPhoto!));
  }

  Future<void> updateReceipt(Receipt receipt, image, location, date, amount) async {
    final isar = await db;
    await isar.writeTxn(() async {
      receipt.receiptPhoto = image;
      receipt.location = location;
      receipt.date = date;
      receipt.amount = amount;
      await isar.receipts.put(receipt);
    });
  }

  Future<String> saveImageToFileSystem(File imageFile) async {
    final directory = await getApplicationDocumentsDirectory();
    final fileName = path.basename(imageFile.path);
    final savedImagePath = path.join(directory.path, fileName);
    await imageFile.copy(savedImagePath);
    return savedImagePath;
  }
}