import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Import for SystemChrome
import '../services/api_service.dart'; // Import ApiService
import '../models/models.dart'; // Import model Mesin

class MachineDetailPage extends StatefulWidget {
  final String idMesin;

  MachineDetailPage({required this.idMesin});

  @override
  _MachineDetailPageState createState() => _MachineDetailPageState();
}

class _MachineDetailPageState extends State<MachineDetailPage> with SingleTickerProviderStateMixin {
  final ApiService apiService = ApiService();
  late Future<Mesin?> futureMesin;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    futureMesin = apiService.fetchMesinDetail(widget.idMesin);
    _tabController = TabController(length: 2, vsync: this); // Set jumlah tab di sini
  }

  @override
  void dispose() {
    _tabController.dispose(); // Dispose tab controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Mesin?>(
      future: futureMesin,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data == null) {
          return Center(child: Text('Data tidak ditemukan'));
        } else {
          final mesinDetail = snapshot.data!;
          return Scaffold(
            appBar: AppBar(
              title: Text('Detail Mesin'),
              bottom: TabBar(
                controller: _tabController,
                tabs: [
                  Tab(text: 'Informasi'),
                  Tab(text: 'Grafik'),
                ],
              ),
            ),
            body: TabBarView(
              controller: _tabController,
              children: [
                // Bagian untuk informasi mesin
                _buildInformationTab(mesinDetail),
                // Bagian untuk grafik (dapat ditambahkan nanti)
                _buildGraphTab(),
              ],
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                // Tindakan FAB di sini
              },
              child: Icon(Icons.add),
              tooltip: 'Add Data',
            ),
          );
        }
      },
    );
  }

  Widget _buildInformationTab(Mesin mesinDetail) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Detail Mesin',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
        // Konten untuk detail mesin, sama seperti sebelumnya
        Text('Machine No: ${mesinDetail.noMachine}'),
        Text('Category: ${mesinDetail.categoryName ?? "Tidak ada kategori"}'),
        Text('Status: ${mesinDetail.status ?? "Tidak ada status"}'),
        // Tambahkan lebih banyak detail sesuai kebutuhan
      ],
    );
  }

  Widget _buildGraphTab() {
    return Center(child: Text('Grafik akan ditampilkan di sini.'));
  }
}
