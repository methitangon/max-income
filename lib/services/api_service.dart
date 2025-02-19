import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/income_source.dart';

class ApiService {
  static const String baseUrl = 'https://your-api-base-url.com';
  final http.Client client;

  ApiService({required this.client});

  Future<List<IncomeSource>> fetchIncomeSources() async {
    final response = await client.get(Uri.parse('$baseUrl/income_sources'));

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => IncomeSource.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch income sources');
    }
  }

  // Implement other CRUD methods (create, update, delete)
  //...
}
