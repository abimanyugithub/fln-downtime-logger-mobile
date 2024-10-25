// lib/services/api_service.dart
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/mesin.dart';

class ApiService {
  static const String url = 'http://10.35.37.165:8000/myapp/mesin/list/';

  // Stream untuk mengirim data secara realtime
  Stream<List<Mesin>> getMesins() async* {
    while (true) {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        List jsonResponse = json.decode(response.body);
        yield jsonResponse.map((item) => Mesin.fromJson(item)).toList();
      } else {
        throw Exception('Failed to load mesins');
      }
      await Future.delayed(Duration(seconds: 10)); // Delay untuk menghindari terlalu banyak request
    }
  }
}

