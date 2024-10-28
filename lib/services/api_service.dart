import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/mesin.dart';

class ApiService {
  // static const String baseUrl = 'http://10.35.37.165:8000/myapp/mesin';
  static const String baseUrl = 'http://192.168.240.163:8000/myapp/mesin';

  // Stream untuk mengirim list data secara realtime
  Stream<List<Mesin>> getMesins() async* {
    while (true) {
      final response = await http.get(Uri.parse('$baseUrl/list/'));
      print('Response status: ${response.statusCode}'); 
      print('Response body: ${response.body}'); 
      
      if (response.statusCode == 200) {
        List jsonResponse = json.decode(response.body);
        yield jsonResponse.map((item) => Mesin.fromJson(item)).toList();
      } else {
        throw Exception('Failed to load mesins: ${response.statusCode}'); 
      }
      
      await Future.delayed(Duration(seconds: 5));
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
}
