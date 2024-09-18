import 'package:flutter/material.dart';
import 'package:flutter_lab1/controllers/Product_service.dart';
import 'package:flutter_lab1/model/Product_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class post_product extends StatefulWidget {
  @override
  _post_productState createState() => _post_productState();
}

class _post_productState extends State<post_product> {
  final _formKey = GlobalKey<FormState>();
  final _productNameController = TextEditingController();
  final _productTypeController = TextEditingController();
  final _priceController = TextEditingController();
  final _unitController = TextEditingController();

  void addProduct() async {
    if (_formKey.currentState!.validate()) {
      final productName = _productNameController.text;
      final productType = _productTypeController.text;
      final priceString = _priceController.text;
      final unit = _unitController.text;

      // Convert price to int
      final int? price = int.tryParse(priceString);

      if (price == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Invalid price format')),
        );
        return;
      }

      try {
        await ProductService()
            .addProduct(productName, productType, price, unit);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Add Product Successful')),
        );

        // Clear text fields after successful submission
        _productNameController.clear();
        _productTypeController.clear();
        _priceController.clear();
        _unitController.clear();
        Navigator.pushReplacementNamed(context, '/user_page');
      } catch (e) {
        print('Error adding product: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add product')),
        );
      }
    }
  }

  // String? myname;
  // String? A_token;
  // String? R_token;

  // void loadData() async {
  //   final SharedPreferences data_DB = await SharedPreferences.getInstance();
  //   setState(() {
  //     myname = data_DB.getString('Myname');
  //     A_token = data_DB.getString('A_token');
  //     R_token = data_DB.getString('R_token');
  //   });
  // }

  // @override
  // void initState() {
  //   loadData();
  //   super.initState();
  // }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: Text('Welcome ${myname ?? 'UnKnown'} to Post Product'),
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
                    addProduct();
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
