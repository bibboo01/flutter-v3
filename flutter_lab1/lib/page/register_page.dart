import 'package:flutter/material.dart';
import 'package:flutter_lab1/controllers/auth_sevice.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _nameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  String? _selectedRole;
  final _formKey = GlobalKey<FormState>();

  final List<String> _roles = ['Admin', 'User']; // Updated roles list

  void _register() async {
    if (_formKey.currentState!.validate()) {
      final name = _nameController.text;
      final username = _usernameController.text;
      final password = _passwordController.text;
      final role = _selectedRole;

      try {
        final user =
            await AuthService().register(username, password, role!, name);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Register successful')),
        );
      } catch (e) {
        print(e);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Register Fail')),
        );
      }
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Register')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
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
              Wrap(
                spacing: 8.0,
                children: _roles.map((role) {
                  return ChoiceChip(
                    label: Text(role),
                    selected: _selectedRole == role,
                    onSelected: (isSelected) {
                      setState(() {
                        _selectedRole = isSelected ? role : null;
                      });
                    },
                  );
                }).toList(),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _register,
                child: Text('Register'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
