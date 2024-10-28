import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Import for SystemChrome
import '../services/api_service.dart'; // Pastikan import ApiService
import '../models/mesin.dart'; // Import model Mesin

class MachineDetailPage extends StatefulWidget {
  final String idMesin;  // Parameter for machine number
  // final String namaKategori; // Parameter for category name

  MachineDetailPage({
    required this.idMesin, 
    // required this.namaKategori,
  });

  @override
  _MachineDetailPageState createState() => _MachineDetailPageState();
}

class _MachineDetailPageState extends State<MachineDetailPage> {
  final ApiService apiService = ApiService();
  
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);

    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Mesin'),
      ),
      //body: StreamBuilder<Mesin?>(
        // stream: apiService.fetchMesinDetail(widget.namaKategori, widget.nomerMesin),
      body: FutureBuilder<Mesin?>(
        future: apiService.fetchMesinDetail(widget.idMesin),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return Center(child: Text('Data tidak ditemukan'));
          } else {
            final mesinDetail = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('No Mesin: ${mesinDetail.noMachine}', 
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  Text('Kategori: ${mesinDetail.categoryName ?? "Tidak ada kategori"}', 
                      style: TextStyle(fontSize: 18)),
                  SizedBox(height: 10),
                  Text('Status: ${mesinDetail.status ?? "Tidak ada status"}', 
                      style: TextStyle(fontSize: 18)),
                  // Tambahkan lebih banyak detail sesuai kebutuhan
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
