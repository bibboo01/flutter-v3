import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_lab1/controllers/Product_service.dart';
import 'package:flutter_lab1/model/Product_model.dart';
import 'package:flutter_lab1/provider/user_provider.dart';
import 'package:provider/provider.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  List<productModel> _products = [];
  bool _isLoading = true;
  String? _errorMessage;
  Timer? _timer;

  void _fetchAllProducts() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    String? accessToken = userProvider.accessToken;
    String? refreshToken = userProvider.refreshToken;
    try {
      final allProduct = await ProductService()
          .getProducts(context, accessToken!, refreshToken!);
      setState(() {
        _products = allProduct;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false; // Set loading to false
        _errorMessage = e.toString(); // Set error message
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchAllProducts();
    _timer = Timer.periodic(const Duration(seconds: 2), (Timer t) {
      _fetchAllProducts(); // Refetch every 2 seconds
    });
  }

  @override
  void dispose() {
    _timer?.cancel(); // Cancel the timer when the widget is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Text('User Page'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: Logout,
          ),
        ],
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            const Text('This is Product List'),
            const SizedBox(height: 20),
            Expanded(
              child: _isLoading
                  ? const Center(
                      child: CircularProgressIndicator()) // Loading indicator
                  : _errorMessage != null
                      ? Center(
                          child: Text('Error: $_errorMessage')) // Error message
                      : ListView.builder(
                          itemCount: _products.length,
                          itemBuilder: (context, index) {
                            final product = _products[index];
                            return ListTile(
                              title: Text(product.productName),
                              subtitle: Text(
                                "Type: ${product.productType} | Price: ${product.price} | Unit: ${product.unit}",
                              ),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }

  void Logout() {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    userProvider.onLogout();
    Navigator.pushNamed(context, '/');
  }
}
