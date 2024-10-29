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
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitUp,
    ]);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // Align content to the left
        children: [
          const SizedBox(height: 40), // Space above the title
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Detail', // Title above ListView
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          FutureBuilder<Mesin?>(
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
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width - 32, // Lebar card
                    child: Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('No Mesin: ${mesinDetail.noMachine}', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 10),
                            Text('Kategori: ${mesinDetail.categoryName ?? "Tidak ada kategori"}', style: TextStyle(fontSize: 18)),
                            const SizedBox(height: 10),
                            Text('Status: ${mesinDetail.status ?? "Tidak ada status"}', style: TextStyle(fontSize: 18)),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            _showBottomSheet(context, widget.idMesin);
          },
          child: const Icon(Icons.waving_hand),
        ),
    );
  }
  void _showBottomSheet(BuildContext context, String idMesin) {
    // Simulated API call to fetch mesinDetail again or use existing detail
    apiService.fetchMesinDetail(idMesin).then((mesinDetail) {
      if (mesinDetail != null) {
        showModalBottomSheet(
          context: context,
          builder: (BuildContext context) {
            return Container(
              height: 300,
              child: ListView.builder(
                itemCount: mesinDetail.roleName.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    //title: Text(mesinDetail.roleName[index]),
                  );
                },
              ),
            );
          },
        );
      }
    });
  }
}
