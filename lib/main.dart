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
        backgroundColor: const Color(0xFFF2F2F7), // Mengatur warna latar belakang body
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // Mengatur alignment ke kiri
          children: [
            const SizedBox(height: 40), // Menambahkan ruang di atas judul
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Mesin', // Judul di atas ListView
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: MachineList(), // Menggunakan mesin widget list
            ),
          ],
        ),
      ),
    );
  }
}
