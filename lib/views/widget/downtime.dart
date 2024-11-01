import 'package:flutter/material.dart';
import '../../models/models.dart'; // Pastikan jalur ini benar
import '../../services/api_service.dart';
import 'bottom_modal.dart';

Widget buildDowntimeTab(BuildContext context, Mesin mesinDetail, ApiService apiService, Function refreshData) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16.0), 
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
                      onTap: role.downtimeRoleStatus == "done"
                          ? null
                          : () {
                              showBottomModal(context, role, refreshData, apiService);
                            }, // Nonaktifkan onTap
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
                                  // 'Downtime Role ID: ${role.downtimeRoleID}',
                                  'Attempt: ${role.downtimeRoleAttempt}',
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