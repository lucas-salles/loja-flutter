import 'package:flutter/material.dart';
import 'package:gerente_loja/screens/home_screen.dart';
import 'package:gerente_loja/screens/login_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Flutter's Clothing Manager",
      theme: ThemeData(
        primaryColor: Colors.pinkAccent,
      ),
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),
    );
  }
}
