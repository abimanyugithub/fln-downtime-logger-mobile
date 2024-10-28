import 'package:flutter/material.dart';
import '../models/mesin.dart'; // Pastikan import model Mesin
import '../services/api_service.dart'; // Pastikan import ApiService
import 'machine_detail.dart'; // Mengimpor halaman detail
import 'package:flutter/services.dart'; // Untuk mengatur orientasi

class MesinList extends StatelessWidget {
  final ApiService apiService = ApiService();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Mesin>>(
      stream: apiService.getMesins(),
      builder: (context, snapshot) {
        // Loading state
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        // Error state
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        // No data state
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No active machines available'));
        }

        // Data available
        final mesins = snapshot.data!;
        return ListView.builder(
          itemCount: mesins.length,
          itemBuilder: (context, index) {
            return Column(
              children: [
                MachineListTile(machine: mesins[index]),
                Divider(), // Garis di bawah setiap item
              ],
            );
          },
        );
      },
    );
  }
}

class MachineListTile extends StatelessWidget {
  final Mesin machine;

  const MachineListTile({Key? key, required this.machine}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.device_hub, size: 48, color: Colors.blue), // Ikon
      title: Text(
        machine.noMachine,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
      ),
      subtitle: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              machine.categoryName ?? "No Category", // Teks kategori
              style: TextStyle(fontSize: 14),
            ),
          ),
          SizedBox(width: 8), // Spasi antara kategori dan status
          Text(
            'Status: ${machine.status ?? "No Status"}', // Teks status dengan label
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16), // Ikon tambahan
      contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16), // Padding
      tileColor: Colors.lightBlueAccent.withOpacity(0.1), // Warna latar belakang tile
      onTap: () {
        // Navigasi ke halaman detail
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MachineDetailPage(
              idMesin: machine.id,        // Kirim noMachine
            ),
          ),
        ).then((_) {
          // Setelah kembali, set orientasi kembali ke portrait
          SystemChrome.setPreferredOrientations([
            DeviceOrientation.portraitUp,
            DeviceOrientation.portraitDown,
          ]);
        });
      },
    );
  }
}
