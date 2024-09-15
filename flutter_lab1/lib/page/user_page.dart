import 'package:flutter/material.dart';
import 'package:flutter_lab1/controllers/Product_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserPage extends StatefulWidget {
  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  String? myname;
  String? A_token;
  String? R_token;

  void loadData() async {
    final SharedPreferences data_DB = await SharedPreferences.getInstance();
    setState(() {
      myname = data_DB.getString('Myname');
      A_token = data_DB.getString('A_token');
      R_token = data_DB.getString('R_token');
    });
  }

  void removeData() async {
    final SharedPreferences data_DB = await SharedPreferences.getInstance();
    await data_DB.remove('Myname');
    await data_DB.remove('A_token');
    await data_DB.remove('R_token');
  }

  @override
  void initState() {
    loadData();
    super.initState();
  }

  // Sample data for the DataTable
  final List<Map<String, dynamic>> products = [
    {
      'ID': 1,
      'product_name': 'Product A',
      'product_type': 'Type 1',
      'price': 10.0,
      'unit': 'pcs'
    },
    {
      'ID': 2,
      'product_name': 'Product B',
      'product_type': 'Type 2',
      'price': 20.0,
      'unit': 'pcs'
    },
    {
      'ID': 3,
      'product_name': 'Product C',
      'product_type': 'Type 3',
      'price': 30.0,
      'unit': 'pcs'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Text('Welcome ${myname ?? 'Unknown'} to User Page'),
            SizedBox(height: 20),
            ElevatedButton(
              child: Text('Post'),
              onPressed: () {
                Navigator.pushNamed(context, '/post_page');
              },
            ),
            SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: [
                    DataColumn(label: Text('ID')),
                    DataColumn(label: Text('Product Name')),
                    DataColumn(label: Text('Product Type')),
                    DataColumn(label: Text('Price')),
                    DataColumn(label: Text('Unit')),
                    DataColumn(label: Text('Action')),
                  ],
                  rows: products.map((product) {
                    return DataRow(cells: [
                      DataCell(Text(product['ID'].toString())),
                      DataCell(Text(product['product_name'])),
                      DataCell(Text(product['product_type'])),
                      DataCell(Text('\$${product['price']}')),
                      DataCell(Text(product['unit'])),
                      DataCell(Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () {
                              Navigator.pushNamed(context, '/edit_page');
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.delete),
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
            SizedBox(height: 20),
            ElevatedButton(
              child: Text('Logout'),
              onPressed: () {
                removeData();
                Navigator.pushNamed(context, '/');
              },
            ),
          ],
        ),
      ),
    );
  }
}
