import 'package:flutter/material.dart';
import '../../models/models.dart'; // Import your model
import '../../services/api_service.dart'; // Import your API service

void showBottomModal(BuildContext context, DowntimePeran role, Function refreshData, ApiService apiService) {
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  ('Pilih ${role.downtimeRoleName}'),
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () {
                    Navigator.pop(context); // Close the modal
                  },
                ),
              ],
            ),
            Divider(), // Garis di bawah
            SizedBox(height: 10),
            /* Text(
              ('(${role.downtimeRoleStatus}) ${role.downtimeRoleName}'),
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ), 
            SizedBox(height: 10),*/
            // Conditional display based on downtimeRoleName
            // Using if-else to conditionally display text
            if (role.downtimeRoleStatus == "waiting")
              Text('Lakukan tindakan sebagai ${role.downtimeRoleName} sekarang?')
            else
              Text('Apakah perbaikannya sudah selesai?'),

            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center, // Center the buttons
              children: [
                ElevatedButton(
                  onPressed: () {
                    // First action here
                    // Call sendRoleToBackend when "OK" is pressed
                    apiService.updateRoleStatus(context, role).then((_) {
                      // Close the dialog after sending
                      Navigator.of(context).pop();
                      refreshData(); // Refresh data after update
                    });
                    Navigator.pop(context); // Close the modal
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.green,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text('Konfirmasi'),
                ),
                SizedBox(width: 10), // Add a small gap between buttons
                if (role.downtimeRoleStatus == "waiting")
                  ElevatedButton(
                    onPressed: () {
                      // Second action here
                      Navigator.pop(context); // Close the modal
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.red,
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text('Batalkan'),
                  ),
                ],
            ),

          ],
        ),
      );
    },
  );
}
