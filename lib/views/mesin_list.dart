import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Import for SystemChrome
import '../models/mesin.dart';
import '../services/api_service.dart';
import 'machine_detail.dart';

class MesinList extends StatelessWidget {
  final ApiService apiService = ApiService();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Mesin>>(
      stream: apiService.getMesins(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No active machines available'));
        }

        final mesins = snapshot.data!;
        /* return ListView(
          children: ListTile.divideTiles(
            context: context,
            tiles: mesins.map((machine) {
              return MachineListTile(machine: machine);
            }),
          ).toList(),
        ); */
        return ListView.separated(
          itemCount: mesins.length,
          itemBuilder: (context, index) {
            return MachineListTile(machine: mesins[index]);
          },
          separatorBuilder: (context, index) => const Divider(),
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

    // Menentukan warna berdasarkan status mesin
    Color tileColor;
    Color iconColor;

    switch (machine.status) {
      case 'ready':
        tileColor = Colors.green.withOpacity(0.1); // Warna untuk status aktif
        iconColor = Colors.green;
        break;
      case 'maintence':
      case 'pending': // Menggunakan dua case untuk satu blok kode
        tileColor = Colors.orange.withOpacity(0.1); // Warna untuk status maintenance atau pending
        iconColor = Colors.orange;
        break;
      default:
        tileColor = Colors.grey.withOpacity(0.1); // Warna default
        iconColor = Colors.grey;
    }
    return ListTile(
      leading: Icon(Icons.factory, size: 48, color: iconColor),
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
      tileColor: tileColor, // Warna latar belakang tile
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
