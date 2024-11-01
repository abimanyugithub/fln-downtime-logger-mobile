import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Import for SystemChrome
import 'package:rflutter_alert/rflutter_alert.dart';
import '../services/api_service.dart'; // Import ApiService
import '../models/models.dart'; // Import model Mesin
import 'widget/roles.dart'; // Impor file information_tab.dart
import 'widget/downtime.dart'; // Impor file graph_tab.dart

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
    _tabController = TabController(length: 2, vsync: this);
    futureMesin = apiService.fetchMesinDetail(widget.idMesin); // Initialize futureMesin here
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitUp,
    ]);
  }

  void refreshData() {
    setState(() {
      futureMesin = apiService.fetchMesinDetail(widget.idMesin); // Refresh data
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Mesin?>(
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
          final screenWidth = MediaQuery.of(context).size.width; // Get the screen width

          
          return Scaffold(
            /* appBar: AppBar(
              title: Text('Detail'),
            ), */
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

                const SizedBox(height: 20), // Space between card and role buttons

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0), // Horizontal padding
                  child: Card(
                    color: Colors.blue.withOpacity(0.1),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Container(
                      width: screenWidth, // Set card width to full screen width
                      padding: const EdgeInsets.all(16.0), // Inner padding for text content
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'No. Mesin: ${mesinDetail.noMachine}',
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Kategori: ${mesinDetail.categoryName ?? "Tidak ada kategori"}',
                            style: TextStyle(fontSize: 18),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Status: ${mesinDetail.status ?? "Tidak ada status"}',
                            style: TextStyle(fontSize: 18),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20), // Space between card and role buttons

                // Container to add padding to TabBar
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16.0), // Padding kiri dan kanan
                  child: TabBar(
                    controller: _tabController,
                    tabs: [
                      Tab(text: 'Roles'),
                      Tab(text: 'Downtime'),
                    ],
                  ),
                ),

                const SizedBox(height: 20), // Space between tab bar and content
                Expanded( // Use Expanded to allow TabBarView to take available space
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      // Memanggil fungsi yang telah didefinisikan sebelumnya
                      buildRolesTab(context, mesinDetail, apiService, refreshData),
                      buildDowntimeTab(context, mesinDetail, apiService, refreshData),
                    ],
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
