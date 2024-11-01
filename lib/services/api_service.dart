import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import '../models/models.dart';

class ApiService {
  static const String baseUrl = 'http://10.35.37.165:8000/dt-log';
  //static const String baseUrl = 'http://192.168.240.163:8000/myapp'; 
 
  Future<List<Mesin>> getMachines() async {
    final response = await http.get(Uri.parse('$baseUrl/mesin/list/'));
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((item) => Mesin.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load machines: ${response.statusCode}');
    }
  }

  // Mengambil detail mesin berdasarkan idMesin
  Future<Mesin?> fetchMesinDetail(String idMesin) async {
    final response = await http.get(Uri.parse('$baseUrl/mesin/$idMesin/'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print('Detail Mesin: $data');
      return Mesin.fromJson(data); // Kembalikan objek Mesin
    } else {
      print('Error: ${response.reasonPhrase}');
      return null; // Mengembalikan null jika gagal
    }
  }

  // Fungsi handle update "status mesin" pada roles.dart
  Future<void> updateMesinStatus(BuildContext context, String mesinId, String roleID) async {
    final url = Uri.parse('$baseUrl/downtime-mesin/api/endpoint/'); // Replace with your backend URL

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'id_mesin': mesinId,
          'id_role': roleID,
        }),
      );

      String message; // Initialize message with a default value
      String status;

      if (response.statusCode == 200) {
        // If successful, parse the response
        // Handle the response from the backend if needed
        print('Role sent successfully: ${response.body}');
        // print('Role sent successfully: $message');
        final responseData = jsonDecode(response.body);
        message = responseData['message'];
        status = responseData['status'];
        // Panggil fungsi showAlert untuk menampilkan alert
        // showAlert(context, message);
      } else {
        // Handle the error response
        final responseData = jsonDecode(response.body);
        message = responseData['message'];
        status = responseData['status'];
        print('Failed to send role: ${response.statusCode}');
      }

      // Tampilkan SnackBar
      // Show customized Snackbar
      // Set the background color based on the status
      Color backgroundColor;
      Color textColor;

      if (status == 'error') {
        backgroundColor = Colors.red; // Error background color
        textColor = Colors.white;
      } else if (status == 'success') {
        backgroundColor = Colors.green; // Warning background color
        textColor = Colors.white;
      } else {
        backgroundColor = Colors.blue; // Success background color
        textColor = Colors.white;
      }
      _showCustomSnackbar(context, backgroundColor, message, status, textColor);

      } catch (error) {
        // Handle any exceptions
        print('Error sending role: $error');
        // showAlert(context, 'Terjadi kesalahan, silahkan coba lagi.');
      }
    }

  // Fungsi handle update "status role" pada roles.dart
  Future<void> updateRoleStatus(BuildContext context, DowntimePeran role) async {
    final url = Uri.parse('$baseUrl/downtime-peran/api/endpoint/'); // Replace with your backend URL

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'id_downtime': role.downtimeMesinID,
          'id_downtime_role': role.downtimeRoleID,
        }),
      );

      if (response.statusCode == 200) {
        print('Role sent successfully: ${response.body}');
      } else {
        print('Failed to send role: ${response.statusCode}');
      }
      } catch (error) {
        print('Error sending role: $error');
      }
    }


  void _showCustomSnackbar(BuildContext context, Color backgroundColor, String message, String status, Color textColor) {
    final snackBar = SnackBar(
      content: Row(
        children: [
          Icon(Icons.info_outline, color: Colors.white), // Icon
          SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      
      backgroundColor: backgroundColor, // Background color
      duration: Duration(seconds: 5),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12), // Rounded corners
      ),
      margin: EdgeInsets.all(16), // Margin
      action: SnackBarAction(
        label: 'OK', // Changed from "Undo" to "OK"
        textColor: textColor, // Action text color
        onPressed: () {
          // Add your action code here
          print('OK action pressed');
        },
      ),
    );

      ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

}