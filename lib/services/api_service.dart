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

  Future<IncomeSource> createIncomeSource(IncomeSource incomeSource) async {
    final response = await client.post(
      Uri.parse('$baseUrl/income_sources'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(incomeSource.toJson()),
    );

    if (response.statusCode == 201) {
      // Successful creation
      final jsonResponse = json.decode(response.body);
      return IncomeSource.fromJson(jsonResponse);
    } else {
      throw Exception('Failed to create income source');
    }
  }

  Future<void> updateIncomeSource(IncomeSource incomeSource) async {
    final response = await client.put(
      Uri.parse('$baseUrl/income_sources/${incomeSource.id}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(incomeSource.toJson()),
    );

    if (response.statusCode == 200) {
      // Successful update
      return; // No content to return
    } else {
      throw Exception('Failed to update income source');
    }
  }

  Future<void> deleteIncomeSource(int id) async {
    final response = await client.delete(
      Uri.parse('$baseUrl/income_sources/$id'),
    );

    if (response.statusCode == 204) {
      // Successful deletion
      return; // No content to return
    } else {
      throw Exception('Failed to delete income source');
    }
  }
}
