import 'package:flutter/material.dart';
import '../../models/models.dart'; // Pastikan jalur ini benar

Widget buildDowntimeTab(BuildContext context, Mesin mesinDetail) {
  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: mesinDetail.downtimePeran.length,
            itemBuilder: (context, index) {
              final role = mesinDetail.downtimePeran[index];
              return Stack(
                children: [
                  Card(
                    elevation: 4,
                    margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    child: InkWell(
                      onTap: () {
                        _showBottomModal(context, role);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  role.downtimeRoleName,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'Downtime Role ID: ${role.downtimeRoleID}',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                            Icon(
                              Icons.access_alarm,
                              color: Colors.blue,
                              size: 30,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 16, // Aligns with card's right edge
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        role.downtimeRoleStatus, // Replace with your badge text
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    ),
  );
}



void _showBottomModal(BuildContext context, DowntimePeran role) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true, // Allow the bottom sheet to use the full screen height
    backgroundColor: Colors.transparent, // Make background transparent
    builder: (BuildContext context) {
      return Container(
        width: double.infinity, // Set width to fill the screen
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white, // Background color of the modal
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)), // Rounded corners
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              ('(${role.downtimeRoleStatus}) ${role.downtimeRoleName}'),
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text('Ambil tindakan sebagai ${role.downtimeRoleName}'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Accept action here
                Navigator.pop(context); // Close the modal
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, backgroundColor: Colors.green, // Text color
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text('Accept'),
            ),
          ],
        ),
      );
    },
  );
}
