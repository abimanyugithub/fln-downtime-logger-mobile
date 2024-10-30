import 'package:flutter/material.dart';
import '../../models/mesin.dart'; // Pastikan jalur ini benar

Widget buildDowntimeTab(BuildContext context, Mesin mesinDetail) {
  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Gunakan Expanded untuk menghindari overflow
        Expanded(
          child: ListView.builder(
            itemCount: mesinDetail.id.length,
            itemBuilder: (context, index) {
              final role = mesinDetail.noMachine[index];
              // return Text('Downtime Role ID: ${role.noMachine}');
            },
          ),
        ),
      ],
    ),
  );
}
