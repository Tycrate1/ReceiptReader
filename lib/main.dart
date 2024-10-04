import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'utils.dart';
import 'login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await runFlaskServer();
  runApp(
    ChangeNotifierProvider(
      create: (context) => ReceiptsModel(),
      child: const MyApp(),
    ),
  );
}

Future<void> runFlaskServer() async {
  await Process.start('C:/Dev/InterfaceDesign/Flutter/personal_finance/venv/Scripts/python.exe', ['lib/pythonOCR/app.py']);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Personal Finance',
      theme: ThemeData(
        colorScheme: lightThemeColors(context),
      ),
      home: const LoginPage(),
    );
  }
}