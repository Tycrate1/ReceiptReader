import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'utils.dart';
import 'appbars.dart';

late TextEditingController _searchController;

void updateSearch(BuildContext context, String text) {
  _searchController.text = text;
  Future.delayed(Duration.zero, () {
    final receiptsModel = Provider.of<ReceiptsModel>(context, listen: false);
    receiptsModel.searchReceipts(context, _searchController.text);
  });
}

class ReceiptActivityPage extends StatefulWidget {
  const ReceiptActivityPage({super.key});

  @override
  State<ReceiptActivityPage> createState() => _ReceiptActivityPageState();
}

class _ReceiptActivityPageState extends State<ReceiptActivityPage> {
  @override
  void initState() {
    _searchController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              clipBehavior: Clip.none,
              child: Column(
                children: [
                  appBar(context),
                  const SizedBox(height: 10),
                  searchBar(context),
                  const SizedBox(height: 30),
                  recentActivity(context),
                  const SizedBox(height: 20),
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

ClipRRect searchBar(BuildContext context) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(16),
    child: Container(
      height: MediaQuery.of(context).size.height * 0.05,
      width: MediaQuery.of(context).size.width * 0.9,
      color: Theme.of(context).colorScheme.onBackground,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(width: 8,),
          Expanded(
            child: TextField(
              controller: _searchController,
              onSubmitted: (value) {
                Future.delayed(Duration.zero, () {
                  final receiptsModel = Provider.of<ReceiptsModel>(context, listen: false);
                  receiptsModel.searchReceipts(context, _searchController.text);
                });
              },
              decoration: InputDecoration(
                hintText: 'Search Receipt Locations...',
                hintStyle: TextStyle(
                  fontSize: 18,
                  color: Theme.of(context).colorScheme.onSecondary,
                ),
                border: InputBorder.none
              ),
              style: TextStyle(
                fontSize: 18,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Future.delayed(Duration.zero, () {
                final receiptsModel = Provider.of<ReceiptsModel>(context, listen: false);
                receiptsModel.searchReceipts(context, _searchController.text);
              });
            },
            child: ImageIcon(
              const AssetImage('${assetDir}search.png'),
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ],
      ),
    )
  );
}

Consumer<ReceiptsModel> recentActivity(BuildContext context) {
  final receiptsModel = Provider.of<ReceiptsModel>(context, listen: false);
  receiptsModel.buildReceipts(context, UserManager().getReceipts());
  return Consumer<ReceiptsModel>(
    builder: (context, model, child) {
      if (model.receiptWidgets.isNotEmpty) {
        List<Widget> modifiedReceipts = [];

        for (int i = 0; i < model.receiptWidgets.length; i++) {
          modifiedReceipts.add(model.receiptWidgets[i]);

          if (i < model.receiptWidgets.length - 1) {
            modifiedReceipts.add(const SizedBox(height: 10));
          }
        }
        return Column(
          children: modifiedReceipts,
        );
      } else {
        return Column(
          children: [
            Text(
              "No recent receipts",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
          ],
        );
      }
    },
  );
}