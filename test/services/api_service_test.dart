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
              '[{"id": 1, "name": "Rental A", "type": "rental", "amount": 1000.0, "costs": [], "status": "Active"}, {"id": 2, "name": "Truck B", "type": "vehicle", "amount": 2000.0, "costs": [], "status": "Active"}]',
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
      expect(result[0].amount, 1000);
      expect(result[0].status, IncomeSourceStatus.Active);
      expect(result[1].id, 2);
      expect(result[1].name, 'Truck B');
      expect(result[1].type, 'vehicle');
      expect(result[1].amount, 2000);
      expect(result[1].status, IncomeSourceStatus.Active);
    });

    test('fetchIncomeSources handles error responses', () async {
      client = MockClient((request) async {
        return http.Response('Failed to fetch data', 500);
      });

      apiService = ApiService(client: client);

      // Call the method and expect an exception
      expect(() => apiService.fetchIncomeSources(), throwsException);
    });

    test(
        'createIncomeSource sends a POST request and returns the created IncomeSource object',
        () async {
      final client = MockClient((request) async {
        if (request.method == 'POST' &&
            request.url.toString() == '${ApiService.baseUrl}/income_sources') {
          // Simulate successful creation with a 201 Created response
          return http.Response(
              '{"id": 3, "name": "New Source", "type": "other", "amount": 3000.0, "costs": [], "status": "Active"}',
              201);
        }
        return http.Response('Not found', 404);
      });

      apiService = ApiService(client: client);
      final newSource = IncomeSource(
        id: 3,
        name: 'New Source',
        type: 'other',
        amount: 3000,
        costs: [],
        status: IncomeSourceStatus.Active,
      );

      final createdSource = await apiService.createIncomeSource(newSource);

      expect(createdSource, isA<IncomeSource>());
      expect(createdSource.id, 3);
      expect(createdSource.name, 'New Source');
      expect(createdSource.type, 'other');
      expect(createdSource.amount, 3000);
      expect(createdSource.status, IncomeSourceStatus.Active);
    });

    test('updateIncomeSource sends a PUT request and updates the income source',
        () async {
      final client = MockClient((request) async {
        if (request.method == 'PUT' &&
            request.url.toString() ==
                '${ApiService.baseUrl}/income_sources/1') {
          // Simulate successful update
          return http.Response('Updated successfully', 200);
        }
        return http.Response('Not Found', 404);
      });

      apiService = ApiService(client: client);
      final updatedSource = IncomeSource(
        id: 1,
        name: 'Updated Source',
        type: 'updated',
        amount: 1000,
        costs: [],
        status: IncomeSourceStatus.Active,
      );

      await apiService.updateIncomeSource(updatedSource);

      // Verify that the request was sent correctly (no exceptions thrown)
    });

    test('updateIncomeSource handles error responses', () async {
      final client = MockClient((request) async {
        // Simulate an error response
        return http.Response('Failed to update', 500);
      });

      apiService = ApiService(client: client);
      final updatedSource = IncomeSource(
        id: 1,
        name: 'Updated Source',
        type: 'updated',
        amount: 1000,
        costs: [],
        status: IncomeSourceStatus.Active,
      );

      expect(
          () => apiService.updateIncomeSource(updatedSource), throwsException);
    });

    test(
        'deleteIncomeSource sends a DELETE request and deletes the income source',
        () async {
      final client = MockClient((request) async {
        if (request.method == 'DELETE' &&
            request.url.toString() ==
                '${ApiService.baseUrl}/income_sources/1') {
          // Simulate successful deletion
          return http.Response('', 204); // No content response
        }
        return http.Response('Not Found', 404);
      });

      apiService = ApiService(client: client);

      await apiService.deleteIncomeSource(1);

      // Verify that the request was sent correctly (no exceptions thrown)
    });

    test('deleteIncomeSource handles error responses', () async {
      final client = MockClient((request) async {
        // Simulate an error response
        return http.Response('Failed to delete', 500);
      });

      apiService = ApiService(client: client);

      expect(() => apiService.deleteIncomeSource(1), throwsException);
    });
  });
}
