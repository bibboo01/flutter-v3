import 'dart:convert';
import 'package:flutter_lab1/model/Product_model.dart';
import 'package:flutter_lab1/varibles.dart';
import 'package:http/http.dart' as http;

class ProductService {
  Future<List<productModel>> getProducts() async {
    final response = await http.get(Uri.parse('$apiURL/api/products'));

    if (response.statusCode == 200) {
      final List<dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse
          .map((product) => productModel.fromJson(product))
          .toList();
    } else {
      throw Exception('Failed to load products');
    }
  }

  Future<productModel> getproduct(String id) async {
    final response = await http.get(
      Uri.parse("$apiURL/api/product/$id"),
    );
    print(response.statusCode);
    print(response.body);
    return productModel.fromJson(jsonDecode(response.body));
  }

  Future<void> addProduct(String product_name, String product_type, int price,
      String unit, String token) async {
    final response = await http.post(
      Uri.parse("$apiURL/api/product"),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        "product_name": product_name,
        "product_type": product_type,
        "price": price,
        "unit": unit
      }),
    );
    print(response.statusCode);
  }

  Future<void> deleteProduct(String id, String token) async {
    final response = await http.delete(
      Uri.parse('$apiURL/api/product/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to delete product');
    }
  }

  Future<void> updateProduct(String id, String product_name,
      String product_type, int price, String unit, String token) async {
    final response = await http.put(
      Uri.parse('$apiURL/api/product/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        "product_name": product_name,
        "product_type": product_type,
        "price": price,
        "unit": unit
      }),
    );
    if (response.statusCode == 200) {
      print('Product updated successfully: ${response.body}');
    }
  }
}
