// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api, use_build_context_synchronously

import 'package:e_wallet/api/customer_api_service.dart';
import 'package:e_wallet/screen/home_page.dart';
import 'package:flutter/material.dart';
import 'package:e_wallet/models/customer.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _mobileNoController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _pinController = TextEditingController();

  bool _isLoading = false;

  Future<void> _register() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      final newCustomer = Customer(
        customerId: 0,
        fullName: _fullNameController.text,
        mobileNo: _mobileNoController.text,
        email: _emailController.text,
        password: _passwordController.text,
        status: 'A',
        pin: _pinController.text,
      );

      final registeredCustomer =
          await ApiService().registerCustomer(newCustomer);

      if (registeredCustomer != null) {
        // Registration successful, navigate to HomePage.
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const HomePage(),
          ),
        );
      } else {
        // Registration failed, show an error message.
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Registration failed. Please try again.')),
        );
      }

      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
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
                    controller: _fullNameController,
                    decoration: const InputDecoration(labelText: 'Full Name'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your full name';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _mobileNoController,
                    decoration:
                        const InputDecoration(labelText: 'Mobile Number'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your mobile number';
                      }
                      return null;
                    },
                  ),
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
                  TextFormField(
                    controller: _pinController,
                    decoration: const InputDecoration(labelText: 'PIN'),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your PIN';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _register,
                    child: const Text('Register'),
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
