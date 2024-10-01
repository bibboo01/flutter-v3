import 'package:flutter/material.dart';
import 'package:flutter_lab1/controllers/auth_sevice.dart';
import 'package:flutter_lab1/model/user_model.dart';
import 'package:flutter_lab1/provider/user_provider.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void _login() async {
    if (_formKey.currentState!.validate()) {
      final username = _usernameController.text;
      final password = _passwordController.text;

      try {
        final User? UserModel = await AuthService().login(username, password);

        Provider.of<UserProvider>(context, listen: false)
            .saveUser(UserModel!.user, UserModel.token);

        final String? role = UserModel.user.role;

        _showLoginSuccessDialog(role!,role);
        _usernameController.clear();
        _passwordController.clear();
      } catch (e) {
        print(e);
        _showErrorDialog('Fail to Login');
      }
    }
  }

  void _showLoginSuccessDialog(String _Role,String name) {
    if (_Role == 'Admin') {
      Navigator.pushReplacementNamed(context, '/admin_page');
    } else if (_Role == 'User') {
      Navigator.pushReplacementNamed(context, '/user_page');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Unknown role: $_Role')),
      );
    }
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Login Successful'),
          content: Text('Welcome $name to Page'),
          actions: <Widget>[
            TextButton(
              child: Center(child: Text('OK')),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(child: Text('Warning')),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Center(child: Text('OK')),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      controller: _usernameController,
                      decoration: InputDecoration(labelText: 'Username'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a username';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _passwordController,
                      decoration: InputDecoration(labelText: 'Password'),
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a password';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _login,
                      child: Text('Login'),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/register');
                      },
                      child: Text('Register'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
