import 'package:flutter/material.dart';

import 'utils.dart';
import 'appbars.dart';
import 'home.dart';
import 'profile.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {  
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
                  linkCard(context, "Privacy", Theme.of(context).colorScheme.onPrimary, () => directPage(context, const HomePage())),
                  const SizedBox(height: 10),
                  linkCard(context, "Appearance", Theme.of(context).colorScheme.onPrimary, () => directPage(context, const HomePage())),
                  const SizedBox(height: 10),
                  linkCard(context, "Language", Theme.of(context).colorScheme.onPrimary, () => directPage(context, const HomePage())),
                  const SizedBox(height: 10),
                  linkCard(context, "Accessibility", Theme.of(context).colorScheme.onPrimary, () => directPage(context, const HomePage())),
                  const SizedBox(height: 10),
                  linkCard(context, "Profile", Theme.of(context).colorScheme.onPrimary, () => directPage(context, const ProfilePage())),
                  const SizedBox(height: 10),
                  linkCard(context, "Export Settings", Theme.of(context).colorScheme.onPrimary, () => directPage(context, const HomePage())),
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