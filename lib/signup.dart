import 'package:flutter/material.dart';

import 'database/user.dart';

import 'utils.dart';
import 'appbars.dart';

late TextEditingController _firstNameController;
late TextEditingController _lastNameController;
late TextEditingController _emailAdressController;
late TextEditingController _passwordController;

String? validateEmail(String? email) {
  if (email == null || email.isEmpty) {
    return 'Email cannot be empty';
  }
  bool isValid = RegExp(r'^[\w-\.]+@[a-zA-Z]+\.[a-zA-Z]{2,}$').hasMatch(email);
  return isValid ? null : 'Enter a valid email address';
}

String? validateName(String? name) {
  if (name == null || name.isEmpty) {
    return 'Name cannot be empty';
  }
  bool isValid = RegExp('^[A-Za-z][A-Za-z]+([-\'\\\\][A-Za-z]+)*\$').hasMatch(name);
  return isValid ? null : 'Enter a valid name';
}

String? validatePassword(String? password) {
  if (password == null || password.isEmpty) {
    return 'Password cannot be empty';
  }
  bool isValid = RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).{8,}$').hasMatch(password);
  return isValid ? null : 'Password must be at least 8 characters long and include a number, an uppercase and a lowercase letter';
}

void signupFunc(BuildContext context, bool mounted, GlobalKey<FormState> formKey) async {
  if (formKey.currentState!.validate()) {
    try {
      await isarService.saveUser(User(_firstNameController.text, _lastNameController.text, _emailAdressController.text, _passwordController.text));
      _firstNameController.text = '';
      _lastNameController.text = '';
      _emailAdressController.text = '';
      _passwordController.text = '';
      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Theme.of(context).colorScheme.onBackground,
            content: Text(
              'Email already in use',
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
}

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  @override
  void initState() {
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _emailAdressController = TextEditingController();
    _passwordController = TextEditingController();
    super.initState();
  }
  final _formKey = GlobalKey<FormState>();

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
                  Column(
                    children: [
                      accountAppBar(context),
                      titleText(context),
                      const SizedBox(height: 50),
                      signupForm(context),
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

  Column titleText(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'Sign up',
          style: TextStyle(
            fontSize: 50,
            fontWeight: FontWeight.w500,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
        Text(
          'Create your account',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.w500,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ],
    );
  }

  Form signupForm(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          inputField(context, '${assetDir}user.png', 'First Name', controller: _firstNameController, validateFn: validateName),
          const SizedBox(height: 20),
          inputField(context, '${assetDir}user.png', 'Last Name', controller: _lastNameController, validateFn: validateName),
          const SizedBox(height: 20),
          inputField(context, '${assetDir}email.png', 'Email Adress', controller: _emailAdressController, validateFn: validateEmail),
          const SizedBox(height: 20),
          inputField(context, '${assetDir}password.png', 'Password', controller: _passwordController, validateFn: validatePassword),
          const SizedBox(height: 5),
          Row(
            children: [
              const SizedBox(width: 30),
              Text(
                '-At least 8 characters long\n-Contains at least one uppercase letter\n-Contains at least one lowercase letter\n-Contains at least one digit',
                style: TextStyle(
                  fontSize: 12,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),
          commonButton(context, 150, 60, Theme.of(context).colorScheme.secondary, Theme.of(context).colorScheme.onSecondary, 'SignUp', () => signupFunc(context, mounted, _formKey)),
        ],
      ),
    );
  }
}