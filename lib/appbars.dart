import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'database/receipt.dart';
import 'database/receipt_reader.dart';

import 'utils.dart';
import 'login.dart';
import 'home.dart';
import 'profile.dart';
import 'settings.dart';
import 'receipt_activity.dart';

void backPage(BuildContext context) {
  Future.microtask(() =>
    Navigator.pop(context),
  );
}

void logoutFn(BuildContext context) {
  UserManager().logoutUser();
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const LoginPage()),
  );
}

IconButton appbarButton(BuildContext context, String icon, String toolTip, void Function() function) {
  return IconButton(
    icon: Transform.scale(
      scale: 1.25,
      child: Image.asset(icon, width: 40, height: 40),
    ),
    tooltip: toolTip,
    onPressed: function,
  );
}

Container homeAppBar(BuildContext context) {
  var user = UserManager().currentUser;
  return Container(
    height: MediaQuery.of(context).size.width * 0.175,
    margin: const EdgeInsets.symmetric(horizontal: 24.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "~Hi, ${user?.firstName}!",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
        appbarButton(context, '${assetDir}profile.png', 'Profile', () => directPage(context, const ProfilePage())),
      ]
    ),
  );
}

Container profileAppBar(BuildContext context) {
  return Container(
    height: MediaQuery.of(context).size.width * 0.175,
    margin: const EdgeInsets.symmetric(horizontal: 24.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        appbarButton(context, '${assetDir}back.png', 'Back', () => backPage(context)),
        appbarButton(context, '${assetDir}signout.png', 'Logout', () => logoutFn(context)),
      ]
    ),
  );
}

Container accountAppBar(BuildContext context) {
  return Container(
    height: MediaQuery.of(context).size.width * 0.175,
    margin: const EdgeInsets.symmetric(horizontal: 24.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        appbarButton(context, '${assetDir}back.png', 'Back', () => backPage(context)),
      ]
    ),
  );
}

Container receiptAppBar(BuildContext context) {
  return Container(
    height: MediaQuery.of(context).size.width * 0.175,
    margin: const EdgeInsets.symmetric(horizontal: 24.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        appbarButton(context, '${assetDir}back.png', 'Back', () => directPage(context, const ReceiptActivityPage())),
        appbarButton(context, '${assetDir}profile.png', 'Profile', () => directPage(context, const ProfilePage())),
      ]
    ),
  );
}

Container appBar(BuildContext context) {
  return Container(
    height: MediaQuery.of(context).size.width * 0.175,
    margin: const EdgeInsets.symmetric(horizontal: 24.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        appbarButton(context, '${assetDir}back.png', 'Back', () => backPage(context)),
        appbarButton(context, '${assetDir}profile.png', 'Profile', () => directPage(context, const ProfilePage())),
      ]
    ),
  );
}

SizedBox footer(BuildContext context) {
  var user = UserManager().currentUser;
  final receiptsModel = Provider.of<ReceiptsModel>(context, listen: false);
  return SizedBox(
    height: MediaQuery.of(context).size.width * 0.23,
    child: ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(64.0),
        topRight: Radius.circular(64.0),
      ),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.2,
        width: MediaQuery.of(context).size.width * 1,
        color: Theme.of(context).colorScheme.surface,
        child: Column(
          children: [
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Container(
                height: 27,
                width: MediaQuery.of(context).size.width * 0.8,
                color: Theme.of(context).colorScheme.onBackground,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          directPage(context, const ReceiptActivityPage());
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              'Search Receipts',
                              style: TextStyle(
                                fontSize: 18,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ],
                        )
                      ),
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        height: 27,
                        width: MediaQuery.of(context).size.width * 0.15,
                        color: Theme.of(context).colorScheme.onSecondary,
                        child: TextButton(
                          onPressed: () async {
                            bool imagePicked = await receiptsModel.getImage();
                            if (imagePicked) {
                              var result = await readReceipt(receiptsModel.image!.path);
                              if (result['error'] != Null) {
                                await isarService.addReceipt(user, Receipt(receiptsModel.image?.path, result['establishment'] ?? 'Unknown Location', result['date'] ?? 'Unknown Date', result['amount'] ?? '0.00'));
                                Future.delayed(Duration.zero, () {
                                  final receiptsModel = Provider.of<ReceiptsModel>(context, listen: false);
                                  receiptsModel.updateReceipts(context, UserManager().getReceipts());
                                });
                              }
                            }
                          },
                          child: ImageIcon(
                            const AssetImage('${assetDir}scan.png'),
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _footerItem('Home', '${assetDir}home.png', const HomePage(), context),
                _footerItem('Receipts', '${assetDir}receipt.png', const ReceiptActivityPage(), context),
                _footerItem('Sheet', '${assetDir}sheet.png', const HomePage(), context),
                _footerItem('Settings', '${assetDir}settings.png', const SettingsPage(), context),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

Widget _footerItem(String title, String imagePath, page, BuildContext context) {
  return TextButton(
    onPressed: () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => page),
      );
    },
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(imagePath, width: 25, height: 25),
        Text(
          title,
          style: TextStyle(
            fontSize: 12,
            color: Theme.of(context).colorScheme.onBackground,
          ),
        ),
      ],
    ),
  );
}