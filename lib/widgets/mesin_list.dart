// lib/widgets/mesin_list.dart
import 'package:flutter/material.dart';
import '../models/mesin.dart';
import '../services/api_service.dart';

class MesinList extends StatelessWidget {
  final ApiService apiService = ApiService();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Mesin>>(
      stream: apiService.getMesins(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No active machines available'));
        } else {
          final mesins = snapshot.data!;
          return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // Menampilkan 2 kolom
              childAspectRatio: 2, // Rasio tinggi dan lebar kartu
              crossAxisSpacing: 10, // Jarak antar kolom
              mainAxisSpacing: 10, // Jarak antar baris
            ),
            itemCount: mesins.length,
            itemBuilder: (context, index) {
              return Card(
                elevation: 5,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    children: [
                      Icon(Icons.device_hub, size: 48), // Ikon di sebelah kiri
                      SizedBox(width: 8), // Jarak antara ikon dan teks
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              mesins[index].noMachine,
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Category: ${mesins[index].categoryName ?? "No Category"}',
                              style: TextStyle(fontSize: 10),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }
}