import 'package:flutter/material.dart';

import 'utils.dart';
import 'home.dart';
import 'signup.dart';

late TextEditingController _emailAdressController;
late TextEditingController _passwordController;

void loginFunc(BuildContext context, bool mounted) async {
  final user = await isarService.validateUser(_emailAdressController.text, _passwordController.text);
  if (user != null) {
    if (mounted) {
      UserManager().loginUser(user);
      directPage(context, const HomePage());
    }
  } else {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Theme.of(context).colorScheme.onBackground,
          content: Text(
            'Invalid email or password',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).colorScheme.error,
            ),
          ),
        ),
      );
    }
  }
}

void signupFunc(BuildContext context) {
  _emailAdressController.text = '';
  _passwordController.text = '';

  directPage(context, const SignupPage());
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  void initState() {
    _emailAdressController = TextEditingController();
    _passwordController = TextEditingController();
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
                  Image.asset('${assetDir}profileImage.png', width: 175, height: 175),
                  inputField(context, '${assetDir}email.png', 'Email', controller: _emailAdressController),
                  const SizedBox(height: 10),
                  inputField(context, '${assetDir}password.png', 'Password', controller: _passwordController),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      commonButton(context, 150, 60, Theme.of(context).colorScheme.secondary, Theme.of(context).colorScheme.onSecondary, 'Login', () => loginFunc(context, mounted)),
                      commonButton(context, 150, 60, Theme.of(context).colorScheme.secondary, Theme.of(context).colorScheme.onSecondary, 'SignUp', () => signupFunc(context))
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}