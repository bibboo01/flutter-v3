import 'package:flutter/material.dart';
import 'package:flutter_lab1/controllers/Product_service.dart';
import 'package:flutter_lab1/model/Product_model.dart';
import 'package:flutter_lab1/provider/user_provider.dart';
import 'package:provider/provider.dart';

class EditPage extends StatefulWidget {
  @override
  _EditPageState createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  final _formKey = GlobalKey<FormState>();

  String? productId;

  final _productNameController = TextEditingController();
  final _productTypeController = TextEditingController();
  final _priceController = TextEditingController();
  final _unitController = TextEditingController();

  void didChangeDependencies() {
    super.didChangeDependencies();
    final product = ModalRoute.of(context)!.settings.arguments
        as productModel; // Change here
    _fetchProduct(product.id);
  }

  void _fetchProduct(String id) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    String? accessToken = userProvider.accessToken;
    String? refreshToken = userProvider.refreshToken;
    if (id.isNotEmpty) {
      final data = await ProductService()
          .getproduct(context, id, accessToken, refreshToken);
      _productNameController.text = data.productName;
      _productTypeController.text = data.productType;
      _priceController.text = data.price.toString();
      _unitController.text = data.unit;
    }
  }
   void _showDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(child: Text('System')),
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

  void _updateProduct(String id) async {
    if (_formKey.currentState!.validate()) {
      final product_name = _productNameController.text;
      final product_type = _productTypeController.text;
      final priceString = _priceController.text;
      final unit = _unitController.text;

      // Try parsing the price and handle potential null values
      final price = int.tryParse(priceString);
      if (price == null) {
        // Show an error message if the price is invalid
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please enter a valid price.')),
        );
        return;
      }
      // Access the token from UserProvider here
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      String? accessToken = userProvider.accessToken;
      String? refreshToken = userProvider.refreshToken;

      try {
        // Call the update method in the ProductService
        await ProductService().updateProduct(context, id, product_name,
            product_type, price, unit, accessToken, refreshToken);
        // Navigate back after successful update
        Navigator.pushNamed(context, '/user_page');
        _showDialog('Edit Product Successful');
      } catch (e) {
        // Handle any errors during the update process
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Update failed: $e')),
        );
      }
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                controller: _productNameController,
                decoration: InputDecoration(
                  labelText: 'Product Name',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a product name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _productTypeController,
                decoration: InputDecoration(
                  labelText: 'Product Type',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a product type';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _priceController,
                decoration: InputDecoration(
                  labelText: 'Price',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a price';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _unitController,
                decoration: InputDecoration(
                  labelText: 'Unit',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a unit';
                  }
                  return null;
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ElevatedButton(
                  onPressed: () {
                    // Process the data
                    final product = ModalRoute.of(context)!.settings.arguments
                        as productModel; // Change here
                    _updateProduct(product.id);
                  },
                  child: Text('Submit'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
