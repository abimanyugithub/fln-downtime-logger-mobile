// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Tambahkan import ini
import 'views/mesin_list.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Downtime Logger',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(title: Text('Daftar Mesin')),
        body: MesinList(), // menggunakan mesin widget list
      ),
    );
  }
}