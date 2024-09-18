import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_lab1/controllers/Product_service.dart';
import 'package:flutter_lab1/model/Product_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class edit_page extends StatefulWidget {
  @override
  _edit_pageState createState() => _edit_pageState();
}

class _edit_pageState extends State<edit_page> {
  final _formKey = GlobalKey<FormState>();
  final _productNameController = TextEditingController();
  final _productTypeController = TextEditingController();
  final _priceController = TextEditingController();
  final _unitController = TextEditingController();

  String? product_name;
  String? product_type;
  int? price;
  String? unit;

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
        // title: Text('Welcome ${myname ?? 'UnKnown'} to Edit Product'),
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
                    if (_formKey.currentState!.validate()) {
                      // Process the data
                      print('Product Name: ${_productNameController.text}');
                      print('Product Type: ${_productTypeController.text}');
                      print('Price: ${_priceController.text}');
                      print('Unit: ${_unitController.text}');
                    }
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
