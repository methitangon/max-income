import 'package:flutter_test/flutter_test.dart';
import 'package:http/testing.dart';
import 'package:http/http.dart' as http;
import 'package:max_income/models/income_source.dart';
import 'package:max_income/services/api_service.dart';

void main() {
  group('ApiService', () {
    late http.Client client;
    late ApiService apiService;

    test('fetchIncomeSources returns a list of IncomeSource objects on success',
        () async {
      client = MockClient((request) async {
        if (request.url.toString() == '${ApiService.baseUrl}/income_sources') {
          return http.Response(
              '[{"id": 1, "name": "Rental A", "type": "rental"}, {"id": 2, "name": "Truck B", "type": "vehicle"}]',
              200);
        }
        return http.Response('Not found', 404);
      });

      apiService = ApiService(client: client);

      // Call the method
      final result = await apiService.fetchIncomeSources();

      // Verify the result
      expect(result, isA<List<IncomeSource>>());
      expect(result.length, 2);
      expect(result[0].id, 1);
      expect(result[0].name, 'Rental A');
      expect(result[0].type, 'rental');
      expect(result[1].id, 2);
      expect(result[1].name, 'Truck B');
      expect(result[1].type, 'vehicle');
    });

    test('fetchIncomeSources handles error responses', () async {
      client = MockClient((request) async {
        return http.Response('Failed to fetch data', 500);
      });

      apiService = ApiService(client: client);

      // Call the method and expect an exception
      expect(() => apiService.fetchIncomeSources(), throwsException);
    });
  });
}
