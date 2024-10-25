// lib/main.dart
import 'package:flutter/material.dart';
import 'widgets/mesin_list.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Mesin Aktif')),
        body: MesinList(), // Menggunakan widget MesinList
      ),
    );
  }
}
