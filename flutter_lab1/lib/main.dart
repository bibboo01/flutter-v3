import 'package:flutter/material.dart';
import 'package:flutter_lab1/page/edit_page.dart';
import 'package:flutter_lab1/page/post_page.dart';
import 'package:flutter_lab1/provider/user_provider.dart';
import 'package:provider/provider.dart';
import './page/homepage.dart';
import './page/register_page.dart';
import './page/login_page.dart';
import './page/admin_page.dart';
import './page/user_page.dart';

void main() {
  runApp(
    ChangeNotifierProvider(create: (context) => UserProvider(), child: MyApp()),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'User Authentication',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => HomePage(),
        '/register': (context) => RegisterPage(),
        '/login': (context) => LoginPage(),
        '/admin_page': (context) => AdminPage(),
        '/user_page': (context) => UserPage(),
        '/edit_page': (context) => EditPage(),
        '/post_page': (context) => post_product(),
      },
    );
  }
}
