import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import '../models/models.dart';

class ApiService {
  //static const String baseUrl = 'http://10.35.37.165:8000/myapp/mesin';
  static const String baseUrl = 'http://192.168.240.163:8000/myapp/mesin';

  // Stream untuk mengirim list data secara realtime
  /* Stream<List<Mesin>> getMachines() async* {
    while (true) {
      final response = await http.get(Uri.parse('$baseUrl/list/'));
      print('Response status: ${response.statusCode}'); 
      print('Response body: ${response.body}'); 
      
      if (response.statusCode == 200) {
        List jsonResponse = json.decode(response.body);
        yield jsonResponse.map((item) => Mesin.fromJson(item)).toList();
      } else {
        throw Exception('Failed to load machines: ${response.statusCode}'); 
      }
      
      await Future.delayed(Duration(seconds: 5));
    }
  } */ 
 
  Future<List<Mesin>> getMachines() async {
    final response = await http.get(Uri.parse('$baseUrl/list/'));
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
    final response = await http.get(Uri.parse('$baseUrl/$idMesin/'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print('Detail Mesin: $data');
      return Mesin.fromJson(data); // Kembalikan objek Mesin
    } else {
      print('Error: ${response.reasonPhrase}');
      return null; // Mengembalikan null jika gagal
    }
  }

  // Mengambil detail mesin berdasarkan noMachine
  // Stream untuk mengirim detail mesin
  /* Stream<Mesin?> fetchMesinDetail(String categoryName, String noMachine) async* {
    while (true) {
      final response = await http.get(Uri.parse('$baseUrl/$categoryName/$noMachine/'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        yield Mesin.fromJson(data);
      } else {
        yield null; // Mengembalikan null jika gagal
      }
      await Future.delayed(Duration(seconds: 5)); // Delay 5 detik
    }
  } */

  // Function to send the role to the backend
  /* Future<Peran?> sendRoleToBackend(String mesinId, String roleID) async {
    // Example GET request to check if the role exists
    final response = await http.get(Uri.parse('$baseUrl/$mesinId/$roleID/'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return Peran.fromJson(data); // Kembalikan objek
    } else {
      print('Error: ${response.reasonPhrase}');
      return null; // Mengembalikan null jika gagal
    }
  } */

  // Function to send the role to the backend
  Future<void> updateMesinStatus(BuildContext context, String mesinId, String roleID) async {
    final url = Uri.parse('$baseUrl/api/endpoint/'); // Replace with your backend URL

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

      if (response.statusCode == 200) {
        // If successful, parse the response
        // Handle the response from the backend if needed
        print('Role sent successfully: ${response.body}');
        // print('Role sent successfully: $message');
        final responseData = jsonDecode(response.body);
        message = responseData['message'] ?? 'Status mesin berhasil diperbarui!';
      } else {
        // Handle the error response
        final responseData = jsonDecode(response.body);
        message = responseData['message'] ?? 'Terjadi kesalahan, silahkan coba lagi.';
        print('Failed to send role: ${response.statusCode}');
      }

      // Tampilkan SnackBar
      /* ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          duration: Duration(seconds: 2),
        ),
      ); */
      // Tampilkan AlertDialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Info'),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Tutup dialog
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
        
      } catch (error) {
        // Handle any exceptions
        print('Error sending role: $error');
      }
    }
  
    /* if (getResponse.statusCode == 200) {
      // The role exists, now send a POST request
      final postResponse = await http.post(
        Uri.parse('$baseUrl/$mesinId/$roleID/'), // Adjust the endpoint for the POST request
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'role_name': roleID, // Send the role name as a parameter
        }),
      );

      if (postResponse.statusCode == 200) {
        print('Role sent successfully: ${postResponse.body}');
      } else {
        print('Error: ${postResponse.reasonPhrase}');
      }
    } else {
      print('Error: ${getResponse.reasonPhrase}');
    }
  }
  */
}
