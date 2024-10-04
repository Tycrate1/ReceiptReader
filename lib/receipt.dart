import 'dart:io';
import 'package:flutter/material.dart';
import 'package:personal_finance/utils.dart';
import 'package:provider/provider.dart';

import 'database/receipt.dart';
import 'database/receipt_reader.dart';

import 'appbars.dart';

void downloadFn() {

}

Future<void> uploadFn(BuildContext context, Receipt receipt) async {
  final receiptsModel = Provider.of<ReceiptsModel>(context, listen: false);
  bool imagePicked = await receiptsModel.getImage();
  if (imagePicked) {
    var result = await readReceipt(receiptsModel.image!.path);
    if (result['error'] != Null) {
      await isarService.updateReceipt(receipt, receiptsModel.image?.path, result['establishment'] ?? 'Unknown Location', result['date'] ?? 'Unknown Date', result['amount'] ?? '0.00');
      Future.delayed(Duration.zero, () {
        final receiptsModel = Provider.of<ReceiptsModel>(context, listen: false);
        receiptsModel.updateReceipts(context, UserManager().getReceipts());
      });
    }
  }
}

class ReceiptPage extends StatefulWidget {
  const ReceiptPage({super.key, required this.receipt});
  final Receipt receipt;

  @override
  State<ReceiptPage> createState() => _ReceiptPageState();
}

class _ReceiptPageState extends State<ReceiptPage> {

  @override
  Widget build(BuildContext context) {
    final receipt = widget.receipt;
    Image receiptImage = Image.file(File(receipt.receiptPhoto!), fit: BoxFit.cover,);
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              clipBehavior: Clip.none,
              child: Column(
                children: [
                  receiptAppBar(context),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      commonButton(context, 160, 70, Theme.of(context).colorScheme.onPrimary, Theme.of(context).colorScheme.onBackground, 'Download', image: '${assetDir}download.png', () => downloadFn()),
                      commonButton(context, 160, 70, Theme.of(context).colorScheme.onBackground, Theme.of(context).colorScheme.onPrimary, 'Re-Scan', image: '${assetDir}upload.png', () async {await uploadFn(context, receipt); setState(() {});}),
                    ],
                  ),
                  const SizedBox(height: 20),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.6,
                      width: MediaQuery.of(context).size.width * 0.9,
                      color: Theme.of(context).colorScheme.onBackground,
                      child: receiptImage,
                    ),
                  ),
                  const SizedBox(height: 30),
                  receiptDetails(context, receipt),
                ],
              ),
            ),
          ),
          footer(context),
        ],
      ),
    );
  }

  Column receiptDetails(BuildContext context, Receipt receipt) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(width: 30),
            Text(
              "Details",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        infoCard(context, receipt.location!),
        const SizedBox(height: 10),
        infoCard(context, receipt.date!),
        const SizedBox(height: 10),
        infoCard(context, receipt.amount!),
        const SizedBox(height: 10),
      ],
    );
  }
}

ClipRRect infoCard(BuildContext context, String info) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(16),
    child: Container(
      height: 50,
      width: MediaQuery.of(context).size.width * 0.8,
      color: Theme.of(context).colorScheme.onBackground,
      child: Center(
        child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: Text(
              info,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
          ),
        ),
      ),
    ),
  );
}