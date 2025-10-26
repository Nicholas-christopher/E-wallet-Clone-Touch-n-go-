// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'package:e_wallet/api/account_api_service.dart';
import 'package:e_wallet/api/customer_api_service.dart';
import 'package:e_wallet/screen/home_page.dart';
import 'package:e_wallet/screen/register_page.dart';
import 'package:e_wallet/shared_prefs.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoading = false;

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      final email = _emailController.text;
      final password = _passwordController.text;

      final loggedInCustomer =
          await ApiService().loginCustomer(email, password);

      setState(() {
        _isLoading = false;
      });

      if (loggedInCustomer != null) {
        await saveCustomer(loggedInCustomer);

        final account = await AccountApiService()
            .getAccountByCustomerId(loggedInCustomer.customerId);

        if (account != null) {
          await saveAccount(account);
        }

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Login Successful')),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const HomePage(),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Login Failed')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Stack(
          children: [
            Form(
              key: _formKey,
              child: ListView(
                children: [
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(labelText: 'Email'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _passwordController,
                    decoration: const InputDecoration(labelText: 'Password'),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _login,
                    child: const Text('Login'),
                  ),
                  TextButton(
                    onPressed: () {
                      // Navigate to RegisterPage
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RegisterPage(),
                        ),
                      );
                    },
                    child: const Text('Don’t have an account? Register'),
                  ),
                ],
              ),
            ),
            Visibility(
              visible: _isLoading,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
