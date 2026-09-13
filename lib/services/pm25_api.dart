import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/pm25_data.dart';

class Pm25Api {
  static const String baseUrl = 'https://ss.devlaos.com';

  Future<Pm25Simple> fetchSimple(double lat, double lon) async {
    final response = await http.get(Uri.parse('$baseUrl/pm25/simple?lat=$lat&lon=$lon'));

    if (response.statusCode == 200) {
      return Pm25Simple.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load simple PM2.5 data');
    }
  }

  Future<Pm25Detail> fetchDetail(double lat, double lon) async {
    final response = await http.get(Uri.parse('$baseUrl/pm25?lat=$lat&lon=$lon'));

    if (response.statusCode == 200) {
      return Pm25Detail.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load detailed PM2.5 data');
    }
  }
}
