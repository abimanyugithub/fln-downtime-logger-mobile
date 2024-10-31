import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Import for SystemChrome
import '../services/api_service.dart'; // Import ApiService
import '../models/models.dart'; // Import model Mesin

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
  late Future<Mesin?> futureMesin;

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitUp,
    ]);
  }

  // fungsi refresh setelah onpressed
  void refreshData() {
    setState(() {
      futureMesin = apiService.fetchMesinDetail(widget.idMesin);
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
                            'Machine No: ${mesinDetail.noMachine}',
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Category: ${mesinDetail.categoryName ?? "Tidak ada kategori"}',
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
          
                Padding(
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
                                    title: Text('Role Details'),
                                    content: Text('Anda menekan ${peran.roleName}'),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop(); // Close the dialog
                                        },
                                        child: Text('Close'),
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
                                        child: Text('OK'),
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
                ),
              ],
            ),

            floatingActionButton: FloatingActionButton(
              onPressed: () {
                // Show modal bottom sheet with title and role icons with labels in a row
                showModalBottomSheet(
                  context: context,
                  builder: (BuildContext context) {
                    return Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Select a Role', // Title above buttons
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 16.0), // Space between title and buttons
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal, // Enable horizontal scrolling
                            child: Row(
                              children: mesinDetail.roles.map((peran) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          // Show role detail in a dialog
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: Text('Role Details'),
                                                content: Text('Anda menekan ${peran.roleName}'),
                                                actions: <Widget>[
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.of(context).pop(); // Close the dialog
                                                    },
                                                    child: Text('Close'),
                                                  ),
                                                  TextButton(
                                                    onPressed: () {
                                                      // Call sendRoleToBackend when "OK" is pressed
                                                      apiService.updateMesinStatus(context, mesinDetail.id, peran.roleID).then((_) {
                                                        Navigator.of(context).pop(); // Close the dialog after sending
                                                      });
                                                    },
                                                    child: Text('OK'),
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
                                            borderRadius: BorderRadius.circular(8.0), // Rounded corners
                                          ),
                                          child: Icon(
                                            Icons.person, // Icon for each role
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
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
              child: Icon(Icons.waving_hand), // Icon for FloatingActionButton
              tooltip: 'Show Roles',
            ),
          );
        }
      },
    );
  }
}
