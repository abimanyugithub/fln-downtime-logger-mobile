import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Import for SystemChrome
import '../services/api_service.dart'; // Import ApiService
import '../models/mesin.dart'; // Import model Mesin

class MachineDetailPage extends StatefulWidget {
  final String idMesin; // Parameter for machine number

  MachineDetailPage({
    required this.idMesin,
  });

  @override
  _MachineDetailPageState createState() => _MachineDetailPageState();
}

class _MachineDetailPageState extends State<MachineDetailPage> {
  final ApiService apiService = ApiService();

  @override
  void initState() {
    super.initState();
    // Set preferred orientations when the page is initialized
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  @override
  void dispose() {
    // Reset preferred orientations when the page is disposed
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F7), // Mengatur warna latar belakang body
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // Mengatur alignment ke kiri
        children: [
          const SizedBox(height: 40), // Menambahkan ruang di atas judul
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Detail', // Judul di atas ListView
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          
          Expanded(
            child: FutureBuilder<Mesin?>(
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
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Kolom kiri
                        Expanded(
                          flex: 1,
                          child: Card(
                            // color: Colors.white,
                            elevation: 0, // Mengatur elevasi (bayangan) card
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10), // Sudut melengkung
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0), // Padding di dalam card
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Machine No: ${mesinDetail.noMachine}',
                                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    'Category: ${mesinDetail.categoryName ?? "Tidak ada kategori"}',
                                    style: TextStyle(fontSize: 18),
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    'Status: ${mesinDetail.status ?? "Tidak ada status"}',
                                    style: TextStyle(fontSize: 18),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 16), // Spacer antara dua kolom

                        // Kolom kanan
                        Expanded(
                          flex: 1, 
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: ListView.builder(
                                  itemCount: mesinDetail.roleName.length,
                                  itemBuilder: (context, index) {
                                    final peran = mesinDetail.roleName[index];
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 8.0), // Jarak vertikal antar ListTile
                                      child: ListTile(
                                        title: Text(peran.roleName),
                                        tileColor: Colors.blue[100], // Warna latar belakang
                                        onTap: () {
                                          // Show modal with role details
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: Text('Role Details'),
                                                content: Text('Anda menekan ${peran.roleName}'),
                                                actions: <Widget>[
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.of(context).pop();
                                                    },
                                                    child: Text('Close'),
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        },
                                        selectedTileColor: Colors.blue[300], // Warna saat ditekan
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: Container(
        width: 56.0, // Ukuran lebar tombol
        height: 56.0, // Ukuran tinggi tombol
        decoration: const BoxDecoration(
          color: Colors.blue, // Warna latar belakang tombol
          shape: BoxShape.circle, // Bentuk lingkaran
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 6.0,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: IconButton(
          icon: Icon(Icons.waving_hand, color: Colors.black), // Ikon di dalam tombol
          onPressed: () {
            // Aksi ketika tombol ditekan
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat, // Menempatkan FAB di kiri bawah
    );
  }
}