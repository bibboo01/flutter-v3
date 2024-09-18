import 'package:flutter/material.dart';
import 'package:flutter_lab1/controllers/Product_service.dart';
import 'package:flutter_lab1/controllers/auth_sevice.dart';
import 'package:flutter_lab1/model/Product_model.dart';
import 'package:flutter_lab1/provider/user_provider.dart';
import 'package:provider/provider.dart';

class UserPage extends StatefulWidget {
  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  // Sample data for the DataTable
  List<productModel> _products = [];
  bool _isLoading = true;
  String? _errorMessage;

  void _fetchAllProducts() async {
    try {
      final allProduct = await ProductService().getProducts();
      setState(() {
        _products = allProduct;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false; // Set loading to false
      });
    }
  }

  @override
  void initState() {
    _fetchAllProducts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Text('This is ProductPage'),
            const SizedBox(height: 20),
            ElevatedButton(
              child: Text('Post'),
              onPressed: () {
                Navigator.pushNamed(context, '/post_page');
              },
            ),
            const SizedBox(height: 20),
            Expanded(
              child: _isLoading
                  ? Center(
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
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit),
                                    onPressed: () {
                                      Navigator.pushNamed(
                                        context,
                                        '/edit_page',
                                        arguments: product,
                                      );
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete),
                                    onPressed: () {
                                      // Implement delete logic here
                                      _deleteProduct(product.id);
                                    },
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              child: Text('Logout'),
              onPressed: () {
                Logout();
              },
            ),
          ],
        ),
      ),
    );
  }

  // Example delete method
  void _deleteProduct(String productId) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    String? token = userProvider.accessToken;

    // Check if the access token is empty
    // if (token == null || token.isEmpty) {
    //   token = await AuthService().refreshToken(userProvider.refreshToken);
    //   userProvider.updateAccessToken(token!);
    // }

    try {
      await ProductService().deleteProduct(productId,
          userProvider.accessToken); // Replace with actual delete method
      _fetchAllProducts(); // Refresh the product list
    } catch (e) {
      print(e); // Handle error as needed
    }
  }

  void Logout() {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    userProvider.onLogout();
    Navigator.pushNamed(context, '/');
  }
}
