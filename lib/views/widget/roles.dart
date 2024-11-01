import 'package:flutter/material.dart';
import '../../services/api_service.dart'; // Import ApiService
import '../../models/models.dart'; // Pastikan jalur ini benar

Widget buildRolesTab(BuildContext context, Mesin mesinDetail, ApiService apiService, Function refreshData) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16.0), // Horizontal padding for role buttons
    child: GridView.builder(
      shrinkWrap: true, // Use this to avoid infinite height issues
      physics: const NeverScrollableScrollPhysics(), // Disable scrolling
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4, // Set 4 columns
        childAspectRatio: 0.7, // Adjust aspect ratio for better fit
        crossAxisSpacing: 8.0, // Spacing between columns
        mainAxisSpacing: 8.0, // Spacing between rows
      ),
      itemCount: mesinDetail.roles.length, // Number of items
      itemBuilder: (context, index) {
        final peran = mesinDetail.roles[index]; // Access each role
        return Column( // Use Column to stack button and text
          children: [
            GestureDetector(
              onTap: () {
                // Show role detail in a dialog
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Terjadi masalah pada mesin?'),
                      content: Text('Silakan pilih "Lanjutkan" untuk mengirimkan notifikasi kepada ${peran.roleName}.'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(); // Close the dialog
                          },
                          child: Text('Tutup'),
                        ),
                        TextButton(
                          onPressed: () {
                            // Call sendRoleToBackend when "OK" is pressed
                            apiService.updateMesinStatus(context, mesinDetail.id, peran.roleID).then((_) {
                              // Close the dialog after sending
                              Navigator.of(context).pop();
                              refreshData(); // Refresh data after update
                            });
                          },
                          child: Text('Lanjutkan'),
                        ),
                      ],
                    );
                  },
                );
              },
              child: Container(
                width: 60.0, // Fixed width for square button
                height: 60.0, // Fixed height for square button
                decoration: BoxDecoration(
                  color: Colors.blue, // Background color for button
                  borderRadius: BorderRadius.circular(15.0), // Rounded corners
                ),
                child: Icon(
                  Icons.waving_hand, // Icon for each role
                  color: Colors.white, // Icon color
                ),
              ),
            ),
            SizedBox(height: 4.0), // Space between icon and text
            SizedBox(
              width: 60.0, // Fixed width for text
              child: Text(
                peran.roleName,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis, // Ellipsis for long text
                style: TextStyle(fontSize: 12.0), // Adjust font size if needed
              ),
            ),
          ],
        );
      },
    ),
  );
}