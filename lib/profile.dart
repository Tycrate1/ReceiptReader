import 'package:flutter/material.dart';

import 'utils.dart';
import 'appbars.dart';
import 'login.dart';
import 'home.dart';
import 'settings.dart';

void deleteFn(BuildContext context, bool mounted) async {
  var user = UserManager().currentUser;
  if (mounted) {
    isarService.deleteUser(user);
    UserManager().logoutUser();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }
}

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {  
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
                  profileAppBar(context),
                  const SizedBox(height: 8),
                  infoCard(context),
                  const SizedBox(height: 32),
                  links(context, mounted),
                  const SizedBox(height: 8),
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

Column infoCard(BuildContext context) {
  var user = UserManager().currentUser;
  return Column(
    children: [
      Image.asset('${assetDir}profileImage.png', width: 150, height: 150),
      infoField(context, '${assetDir}user.png', 'Name', '${user?.firstName} ${user?.lastName}'),
      const SizedBox(height: 10),
      infoField(context, '${assetDir}email.png', 'Email', '${user?.emailAdress}'),
      const SizedBox(height: 10),
      infoField(context, '${assetDir}password.png', 'Password', '${user?.password}'),
    ],
  );
}

Row infoField(BuildContext context, String image, String text, String info) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Container(
          height: 40,
          width: MediaQuery.of(context).size.width * 0.8,
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
                          fontSize: 20,
                          color: Theme.of(context).colorScheme.onSecondary,
                        ),
                      ),
                    ],
                  )
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  info,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ],
  );
}

Column links(BuildContext context, mounted) {
  return Column(
    children: [
      linkCard(context, "Settings", Theme.of(context).colorScheme.onPrimary, () => directPage(context, const SettingsPage())),
      const SizedBox(height: 10),
      linkCard(context, "Language", Theme.of(context).colorScheme.onPrimary, () => directPage(context, const HomePage())),
      const SizedBox(height: 10),
      linkCard(context, "Privacy", Theme.of(context).colorScheme.onPrimary, () => directPage(context, const HomePage())),
      const SizedBox(height: 10),
      linkCard(context, 'Delete Account', Theme.of(context).colorScheme.error, () => deleteFn(context, mounted))
    ],
  );
}