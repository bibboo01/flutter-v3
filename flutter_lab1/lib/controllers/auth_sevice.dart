import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_lab1/model/user_model.dart';
import 'package:flutter_lab1/provider/user_provider.dart';
import 'package:flutter_lab1/varibles.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class AuthService {
  Future<User> login(String username, String password) async {
    final response = await http.post(
      Uri.parse("$apiURL/api/auth/login"),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({"user_name": username, "password": password}),
    );
    print(response.statusCode);

    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to login');
    }
  }

  Future<void> register(
    String username,
    String password,
    String role,
    String name,
  ) async {
    final response = await http.post(
      Uri.parse("$apiURL/api/auth/register"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "user_name": username,
        "password": password,
        "role": role,
        "name": name
      }),
    );
    print(response.statusCode);
  }

  Future<String?> refreshToken(
      BuildContext context, String refreshtoken) async {
    final response = await http.post(Uri.parse('$apiURL/api/auth/refresh'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"token": refreshtoken}));
    print(response.statusCode);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      String newAccessToken = data['accessToken'];

      final userProvider = Provider.of<UserProvider>(context, listen: false);
      userProvider.updateAccessToken(newAccessToken);
      return newAccessToken;
    } else {
      print(
          'Error refreshing token: ${response.statusCode} - ${response.body}');
      return null;
    }
  }
}
