import 'package:flutter/material.dart';
import 'package:flutter_chatapp/views/screens/home/home_body.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  static String routeName = "/home";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: HomeBody(),
    );
  }
}
