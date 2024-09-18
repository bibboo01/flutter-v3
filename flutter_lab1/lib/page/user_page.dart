import 'package:flutter/material.dart';
import 'package:flutter_lab1/controllers/Product_service.dart';
import 'package:flutter_lab1/model/Product_model.dart';
// import 'package:flutter_lab1/controllers/Product_service.dart';
// import 'package:flutter_lab1/controllers/auth_sevice.dart';
// import 'package:flutter_lab1/model/user_model.dart';
import 'package:flutter_lab1/provider/user_provider.dart';
import 'package:provider/provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';

class UserPage extends StatefulWidget {
  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {

    // Sample data for the DataTable
  List<Product> _products = [];
  bool _isLoading = true;
  int index = 0;

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

  // void removeData() async {
  //   final SharedPreferences data_DB = await SharedPreferences.getInstance();
  //   await data_DB.remove('Myname');
  //   await data_DB.remove('A_token');
  //   await data_DB.remove('R_token');
  // }

  void _fatchAllProduct()async{
    try {
         final productService = ProductService();
      List<Product> products = await productService.getproducts();
      setState(() {
        _products = products;
        _isLoading = false;
      });
    } catch (e) {
      print(e);
    }

  }

  @override
  void initState() {
    // loadData();
    _fatchAllProduct();
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
            // Text('Welcome ${myname ?? 'Unknown'} to User Page'),
            const SizedBox(height: 20),
            Text("AccessToken"),
            const SizedBox(height: 20),
            Text(context.read<UserProvider>().accessToken),
            const SizedBox(height: 20),
            Text("refreashToken"),
            const SizedBox(height: 20),
            Text(
              context.watch<UserProvider>().refreshToken!,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              child: Text('Update Token'),
              onPressed: () async{
                final refreshToken = context.read<UserProvider>().refreshToken;
                print(refreshToken);
                // await AuthService()
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              child: Text('Post'),
              onPressed: () {
                Navigator.pushNamed(context, '/post_page');
              },
            ),
            const SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text('ID')),
                    DataColumn(label: Text('Product Name')),
                    DataColumn(label: Text('Product Type')),
                    DataColumn(label: Text('Price')),
                    DataColumn(label: Text('Unit')),
                    DataColumn(label: Text('Action')),
                  ],
                  rows: _products.map((product) {
                    return DataRow(cells: [
                      DataCell(Text("${index+1}")),
                      DataCell(Text("${product.product.productName}")),
                      DataCell(Text("${product.product.productType}")),
                      DataCell(Text("${product.product.price}")),
                      DataCell(Text("${product.product.unit}")),

                      DataCell(Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () {
                              Navigator.pushNamed(context, '/edit_page');
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              //del();
                            },
                          ),
                        ],
                      )),
                    ]);
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              child: Text('Logout'),
              onPressed: () {
                // removeData();
                Navigator.pushNamed(context, '/');
              },
            ),
          ],
        ),
      ),
    );
  }
}
