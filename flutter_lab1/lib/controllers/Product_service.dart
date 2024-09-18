import 'dart:convert';
import 'package:flutter_lab1/model/Product_model.dart';
import 'package:flutter_lab1/varibles.dart';
import 'package:http/http.dart' as http;

class ProductService {
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

  Future<Product> getproduct(String id) async {
    final response = await http.get(
      Uri.parse("$apiURL/api/product/$id"),
    );
    return Product.fromJson(jsonDecode(response.body));
  }

  Future<void> addProduct(
    String product_name,
    String product_type,
    int price,
    String unit,
  ) async {
    final response = await http.post(
      Uri.parse("$apiURL/api/product"),
      headers: {
        'Content-Type': 'application/json',
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

  Future<void> deleteProduct(int id) async {
    final response = await http.delete(Uri.parse('$apiURL/api/product/$id'));
    if (response.statusCode != 200) {
      throw Exception('Failed to delete product');
    }
  }
}
