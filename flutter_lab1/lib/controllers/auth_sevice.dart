import 'dart:convert';
import 'package:flutter_lab1/model/Product_model.dart';
import 'package:flutter_lab1/model/user_model.dart';
import 'package:flutter_lab1/varibles.dart';
import 'package:http/http.dart' as http;

class AuthService {
  Future<List<Product>> getproducts() async {
    final response = await http.get(
      Uri.parse("$apiURL/api/products"),
      headers: {
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((item) => Product.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load products');
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
}
