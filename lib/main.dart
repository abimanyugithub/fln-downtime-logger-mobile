// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Tambahkan import ini
import 'widgets/mesin_list.dart';

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
      home: Scaffold(
        appBar: AppBar(title: Text('Mesin Aktif')),
        body: MesinList(), // Menggunakan widget MesinList
      ),
    );
  }
}
