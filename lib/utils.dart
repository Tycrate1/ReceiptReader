import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:isar/isar.dart';

import 'database/isar_service.dart';
import 'database/user.dart';
import 'database/receipt.dart';

import 'receipt.dart';

const assetDir = 'assets/';

IsarService isarService = IsarService();

ColorScheme lightThemeColors(context) {
  return const ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xFFB2C0D4),
    onPrimary: Color(0xFF2C3044),
    secondary: Color(0xFF7C92AE),
    onSecondary: Color(0xFFDCE8F5),
    error: Color(0xFFED4337),
    onError: Color(0xFFED4337),
    background: Color(0xFFF2F1F1),
    onBackground: Color(0xFFFFFFFF),
    surface: Color(0xFF889FBB),
    onSurface: Color(0xFFFFFFFF),
  );
}

class UserManager {
  static final UserManager _instance = UserManager._internal();
  factory UserManager() => _instance;
  UserManager._internal();

  User? currentUser;

  void loginUser(User user) {
    currentUser = user;
  }

  void logoutUser() {
    currentUser = null;
  }

  IsarLinks<Receipt>? getReceipts() {
    return currentUser?.receipts;
  }
}

class ReceiptsModel with ChangeNotifier {
  List<Widget> receiptWidgets = [];
  final possibleFormats = [
    'MM-dd-yy',
    'MM/dd/yy',
    'MM-dd-yyyy',
    'MM/dd/yyyy',
    'dd-MM-yy',
    'dd/MM/yy',
    'dd-MM-yyyy',
    'dd/MM/yyyy',
    'yyyy-MM-dd',
    'yyyy/MM/dd',
    'yy-MM-dd',
    'yy/MM/dd',
    'dd-MMM-yyyy',
    'MMMM dd, yyyy',
    'dd MMM yyyy',
    'MMMM dd yyyy',
    'EEE, dd MMM yyyy HH:mm:ss Z',
  ];
  final ImagePicker picker = ImagePicker();
  XFile? image;

  void updateReceipts(BuildContext context, receipts) {
    buildReceipts(context, receipts);
    notifyListeners();
  }

  DateTime? tryParseDate(String dateString) {
    for (final format in possibleFormats) {
      try {
        return DateFormat(format).parse(dateString);
      } catch (e) {
        //
      }
    }
    return null;
  }

  void buildReceipts(BuildContext context, receipts) {
    receiptWidgets = [];

    if (receipts != null) {
      List<Receipt> receiptList = receipts.toList();

      receiptList.sort((a, b) =>
        (tryParseDate(a.date ?? "") ?? DateTime(2000, 1, 1))
            .compareTo(tryParseDate(b.date ?? "") ?? DateTime(2000, 1, 1)));
      
      receiptList = receiptList.reversed.toList();

      for (final r in receiptList) {
        receiptWidgets.add(recentActivityCard(context, r));
      }
    }
  }

  void searchReceipts(BuildContext context, String text) async {
    final receipts = UserManager().getReceipts();
    final receiptMatches = await receipts?.filter().locationContains(text, caseSensitive: false).findAll();
    Future.delayed(Duration.zero, () {
      final receiptsModel = Provider.of<ReceiptsModel>(context, listen: false);
      receiptsModel.updateReceipts(context, receiptMatches);
    });
  }

  Future<bool> getImage() async {
    final XFile? selection = await picker.pickImage(source: ImageSource.gallery);

    if (selection != null) {
      image = selection;
      return true;
    } else {
      return false;
    }
  }
}

Row inputField(BuildContext context, String image, String text, {TextEditingController? controller, String? Function(String?)? validateFn}) {
  return Row(
    children: [
      const SizedBox(width: 24),
      ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          height: 50,
          color: Theme.of(context).colorScheme.onSecondary,
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  height: 50,
                  width: 125,
                  color: Theme.of(context).colorScheme.secondary,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ImageIcon(
                        AssetImage(image),
                        color: Theme.of(context).colorScheme.onSecondary,
                      ),
                      Text(
                        text,
                        style: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).colorScheme.onSecondary,
                        ),
                      ),
                    ],
                  )
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextFormField(
                  controller: controller,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(25),
                  ],
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                  ),
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  validator: validateFn,
                ),
              ),
            ],
          ),
        ),
      ),
    ],
  );
}

TextButton commonButton(BuildContext context, double? width, double? height, Color? backgroundColor, Color? textColor, String text, void Function()? function, {String? image}) {
  return TextButton(
    onPressed: function,
    child: ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: width,
        height: height,
        color: backgroundColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (image != null) ...[
              ImageIcon(
                AssetImage(image),
                color: textColor,
                size: 30,
              ),
              const SizedBox(width: 3),
            ],
            Text(
              text,
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w500,
                color: textColor,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

Column linkCard(BuildContext context, String text, Color? textColor, void Function() function) {
  return Column(
    children: [
      ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          height: MediaQuery.of(context).size.height * 0.125,
          margin: const EdgeInsets.symmetric(vertical: 4.0),
          color: Theme.of(context).colorScheme.onBackground,
          child: TextButton(
            onPressed: function,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(width: 10),
                Text(
                  text,
                  style: TextStyle(
                    fontSize: 32,
                    color: textColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ],
  );
}

Column recentActivityCard(BuildContext context, Receipt receipt) {
  return Column(
    children: [
      ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          height: 90,
          color: Theme.of(context).colorScheme.onBackground,
          child: TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ReceiptPage(receipt: receipt), settings: RouteSettings(arguments: UniqueKey())),
              );
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            receipt.location!,
                            style: TextStyle(
                              fontSize: 24,
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
                          ),
                          Text(
                            receipt.date!,
                            style: TextStyle(
                              fontSize: 16,
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Text(
                  '-${receipt.amount!}',
                  style: TextStyle(
                    fontSize: 20,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ],
  );
}

void directPage(BuildContext context, page) {
  Future.microtask(() =>
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    )
  );
}