import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:frontend/screens/login.dart';
import 'package:frontend/screens/todos.dart';
import 'package:frontend/utils/apis.dart';
import 'package:frontend/utils/functions.dart';
import 'package:http/http.dart' as http;

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() {
    return _RegisterState();
  }
}

class _RegisterState extends State<Register> {
  final _emailContoller = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordConfirmController = TextEditingController();

  void register() async {
    if (_passwordController.text.trim() !=
        _passwordConfirmController.text.trim()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Passwords did not match'),
          duration: Duration(seconds: 4),
        ),
      );
    } else if (_emailContoller.text.trim().isEmpty ||
        _passwordController.text.trim().isEmpty ||
        _passwordConfirmController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please make sure that you have filled all the fields'),
          duration: Duration(seconds: 4),
        ),
      );
    } else {
      final response = await http.post(
        Uri.parse(registerAPI),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(
          {
            'email': _emailContoller.text,
            'password': _passwordController.text,
          },
        ),
      );
      print(response.statusCode);
      if (response.statusCode > 200 && response.statusCode<400 && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Successfully registered'),
            duration: Duration(seconds: 4),
          ),
        );
        login(_emailContoller.text, _passwordController.text, context);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ToDos(),
          ),
        );
      } else {
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              json.decode(response.body)['email'][0],
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _emailContoller,
                  decoration: customInputDesign('Enter a email'),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _passwordController,
                  decoration: customInputDesign('Enter a password'),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _passwordConfirmController,
                  decoration: customInputDesign('Confirm a password'),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: register,
                        style: customButtonStyle,
                        child: Text(
                          'Register',
                          style: customTextStyle,
                        ),
                      ),
                    ),
                  ],
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Login(),
                      ),
                    );
                  },
                  child: const Text('Already have account?'),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
