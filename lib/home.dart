import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'utils.dart';
import 'appbars.dart';
import 'receipt_activity.dart';
import 'settings.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              clipBehavior: Clip.none,
              child: Column(
                children: [
                  homeAppBar(context),
                  const SizedBox(height: 10),
                  expenseCard(context),
                  const SizedBox(height: 25),
                  recentActivity(context),
                  const SizedBox(height: 30),
                  quickLinks(context),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
          footer(context),
        ],
      ),
    );
  }
}

ClipRRect expenseCard(BuildContext context) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(16),
    child: Container(
      width: MediaQuery.of(context).size.width * 0.9,
      height: MediaQuery.of(context).size.height * 0.35,
      color: Theme.of(context).colorScheme.primary,
      child: Align(
        alignment: Alignment.topCenter,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 30),
            Text(
              "Monthly Expense",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
            Text(
              "\$2546.71",
              style: TextStyle(
                fontSize: 50,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                commonButton(context, 135, 70, Theme.of(context).colorScheme.onPrimary, Theme.of(context).colorScheme.onBackground, 'Sheet', image: '${assetDir}sheet.png', () => directPage(context, const HomePage())),
                commonButton(context, 135, 70, Theme.of(context).colorScheme.onBackground, Theme.of(context).colorScheme.onPrimary, 'Receipts', image: '${assetDir}receipt.png', () => directPage(context, const ReceiptActivityPage())),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

Column recentActivity(BuildContext context) {
  final receiptsModel = Provider.of<ReceiptsModel>(context, listen: false);
  receiptsModel.buildReceipts(context, UserManager().getReceipts());
  return Column(
    children: [
      Container(
        width: MediaQuery.of(context).size.width * 0.9,
        margin: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Recent Activity",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
          ],
        ),
      ),
      const SizedBox(height: 10),
      Consumer<ReceiptsModel>(
        builder: (context, model, child) {
          List<Widget> lastTwoItems = model.receiptWidgets.length > 2 ? model.receiptWidgets.sublist(0, 2).toList() : model.receiptWidgets;
          List<Widget> itemsWithSpacing = [];
          if (lastTwoItems.isNotEmpty) {
            itemsWithSpacing.add(lastTwoItems.first);
            
            if (lastTwoItems.length > 1) {
              itemsWithSpacing.add(const SizedBox(height: 10));
              itemsWithSpacing.add(lastTwoItems[1]);
            }
          } else {
            return Column(
              children: [
                const SizedBox(height: 10),
                Text(
                  "No recent receipts",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
              ],
            );
          }
          return Column(
            children: itemsWithSpacing,
          );
        },
      ),
    ],
  );
}

Column quickLinks(BuildContext context) {
  return Column(
    children: [
      Container(
        margin: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              "Quick Links",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
          ],
        ),
      ),
      const SizedBox(height: 10),
      ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.15,
          width: MediaQuery.of(context).size.width * 0.9,
          color: Theme.of(context).colorScheme.primary,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _quickLinkItem(context, 'Sheet', '${assetDir}sheetCircle.png', const HomePage()),
              _quickLinkItem(context, 'Settings', '${assetDir}settingsCircle.png', const SettingsPage()),
              _quickLinkItem(context, 'Privacy', '${assetDir}privacyCircle.png', const HomePage()),
              _quickLinkItem(context, 'Receipts', '${assetDir}receiptCircle.png', const ReceiptActivityPage()),
            ],
          ),
        ),
      ),
    ],
  );
}

Widget _quickLinkItem(BuildContext context, String title, String imagePath, link) {
  return TextButton(
    onPressed: () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => link),
      );
    },
    child: SizedBox(
      height: MediaQuery.of(context).size.height * 0.15,
      width: MediaQuery.of(context).size.width * 0.15,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(imagePath, width: 50, height: 50),
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
        ],
      ),
    ),
  );
}