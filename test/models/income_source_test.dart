import 'package:flutter_test/flutter_test.dart';
import 'package:max_income/models/income_source.dart';

void main() {
  group('IncomeSource', () {
    test('creates an IncomeSource instance with required properties', () {
      final source = IncomeSource(
        id: 1,
        name: 'Rental Property',
        type: 'rental',
        amount: 1000.0,
        costs: [],
        status: IncomeSourceStatus.Active,
      );

      expect(source.id, 1);
      expect(source.name, 'Rental Property');
      expect(source.type, 'rental');
      expect(source.amount, 1000.0);
      expect(source.costs, isEmpty);
      expect(source.status, IncomeSourceStatus.Active);
      expect(source.currency, 'USD');
    });

    test('creates an IncomeSource instance with custom currency', () {
      final source = IncomeSource(
        id: 1,
        name: 'Rental Property',
        type: 'rental',
        amount: 1000.0,
        costs: [],
        status: IncomeSourceStatus.Active,
        currency: 'EUR',
      );

      expect(source.currency, 'EUR');
    });

    test('creates an IncomeSource instance with costs', () {
      final source = IncomeSource(
        id: 1,
        name: 'Rental Property',
        type: 'rental',
        amount: 1000.0,
        costs: [
          Cost(name: 'Maintenance', amount: 100.0, frequency: 'monthly'),
          Cost(name: 'Insurance', amount: 50.0, frequency: 'monthly'),
        ],
        status: IncomeSourceStatus.Active,
      );

      expect(source.costs.length, 2);
      expect(source.costs.first.name, 'Maintenance');
      expect(source.costs.first.amount, 100.0);
      expect(source.costs.first.currency, 'USD');
      expect(source.costs.last.name, 'Insurance');
      expect(source.costs.last.amount, 50.0);
      expect(source.costs.last.currency, 'USD');
    });

    group('JSON Serialization', () {
      test('fromJson creates correct IncomeSource instance', () {
        final json = {
          'id': 1,
          'name': 'Rental Property',
          'type': 'rental',
          'amount': 1000.0,
          'currency': 'EUR',
          'costs': [
            {
              'name': 'Maintenance',
              'amount': 100.0,
              'frequency': 'monthly',
              'currency': 'EUR',
            },
            {
              'name': 'Insurance',
              'amount': 50.0,
              'frequency': 'monthly',
              'currency': 'EUR',
            },
          ],
          'status': 'Active',
        };

        final source = IncomeSource.fromJson(json);

        expect(source.id, 1);
        expect(source.name, 'Rental Property');
        expect(source.type, 'rental');
        expect(source.amount, 1000.0);
        expect(source.currency, 'EUR');
        expect(source.costs.length, 2);
        expect(source.costs.first.name, 'Maintenance');
        expect(source.costs.first.amount, 100.0);
        expect(source.costs.first.currency, 'EUR');
      });

      test('toJson creates correct JSON map', () {
        final source = IncomeSource(
          id: 1,
          name: 'Rental Property',
          type: 'rental',
          amount: 1000.0,
          currency: 'EUR',
          costs: [
            Cost(
              name: 'Maintenance',
              amount: 100.0,
              frequency: 'monthly',
              currency: 'EUR',
            ),
            Cost(
              name: 'Insurance',
              amount: 50.0,
              frequency: 'monthly',
              currency: 'EUR',
            ),
          ],
          status: IncomeSourceStatus.Active,
        );

        final json = source.toJson();

        expect(json['id'], 1);
        expect(json['name'], 'Rental Property');
        expect(json['type'], 'rental');
        expect(json['amount'], 1000.0);
        expect(json['currency'], 'EUR');
        expect(json['costs'], [
          {
            'name': 'Maintenance',
            'amount': 100.0,
            'frequency': 'monthly',
            'currency': 'EUR',
          },
          {
            'name': 'Insurance',
            'amount': 50.0,
            'frequency': 'monthly',
            'currency': 'EUR',
          },
        ]);
        expect(json['status'], 'Active');
      });

      test('handles missing currency in JSON', () {
        final json = {
          'id': 1,
          'name': 'Rental Property',
          'type': 'rental',
          'amount': 1000.0,
          'costs': [],
          'status': 'Active',
        };

        final source = IncomeSource.fromJson(json);
        expect(source.currency, 'USD');
      });

      test('handles empty costs array in JSON', () {
        final json = {
          'id': 1,
          'name': 'Rental Property',
          'type': 'rental',
          'amount': 1000.0,
          'costs': [],
          'status': 'Active',
        };

        final source = IncomeSource.fromJson(json);
        expect(source.costs, isEmpty);
        expect(source.status, IncomeSourceStatus.Active);
        expect(source.currency, 'USD');
      });

      test('handles missing costs array in JSON', () {
        final json = {
          'id': 1,
          'name': 'Rental Property',
          'type': 'rental',
          'amount': 1000.0,
          'status': 'Active',
        };

        final source = IncomeSource.fromJson(json);
        expect(source.costs, isEmpty);
        expect(source.status, IncomeSourceStatus.Active);
        expect(source.currency, 'USD');
      });
    });

    group('Cost', () {
      test('creates a Cost instance with required properties', () {
        final cost = Cost(
          name: 'Maintenance',
          amount: 100.0,
          frequency: 'monthly',
        );

        expect(cost.name, 'Maintenance');
        expect(cost.amount, 100.0);
        expect(cost.frequency, 'monthly');
        expect(cost.currency, 'USD');
      });

      test('creates a Cost instance with custom currency', () {
        final cost = Cost(
          name: 'Maintenance',
          amount: 100.0,
          frequency: 'monthly',
          currency: 'EUR',
        );

        expect(cost.currency, 'EUR');
      });

      test('fromJson creates correct Cost instance', () {
        final json = {
          'name': 'Maintenance',
          'amount': 100.0,
          'frequency': 'monthly',
          'currency': 'EUR',
        };

        final cost = Cost.fromJson(json);

        expect(cost.name, 'Maintenance');
        expect(cost.amount, 100.0);
        expect(cost.frequency, 'monthly');
        expect(cost.currency, 'EUR');
      });

      test('fromJson uses default currency when missing', () {
        final json = {
          'name': 'Maintenance',
          'amount': 100.0,
          'frequency': 'monthly',
        };

        final cost = Cost.fromJson(json);
        expect(cost.currency, 'USD');
      });

      test('toJson creates correct JSON map', () {
        final cost = Cost(
          name: 'Maintenance',
          amount: 100.0,
          frequency: 'monthly',
          currency: 'EUR',
        );

        final json = cost.toJson();

        expect(json['name'], 'Maintenance');
        expect(json['amount'], 100.0);
        expect(json['frequency'], 'monthly');
        expect(json['currency'], 'EUR');
      });
    });

    test('calculates total costs correctly', () {
      final source = IncomeSource(
        id: 1,
        name: 'Rental Property',
        type: 'rental',
        amount: 1000.0,
        costs: [
          Cost(name: 'Maintenance', amount: 100.0, frequency: 'monthly'),
          Cost(name: 'Insurance', amount: 50.0, frequency: 'monthly'),
          Cost(name: 'Property Tax', amount: 150.0, frequency: 'monthly'),
        ],
        status: IncomeSourceStatus.Active,
      );

      final totalCosts =
          source.costs.fold(0.0, (sum, cost) => sum + cost.amount);
      expect(totalCosts, 300.0);
      expect(source.status, IncomeSourceStatus.Active);
      expect(source.currency, 'USD');
    });

    test('net income calculation is correct', () {
      final source = IncomeSource(
        id: 1,
        name: 'Rental Property',
        type: 'rental',
        amount: 1000.0,
        costs: [
          Cost(name: 'Maintenance', amount: 100.0, frequency: 'monthly'),
          Cost(name: 'Insurance', amount: 50.0, frequency: 'monthly'),
          Cost(name: 'Property Tax', amount: 150.0, frequency: 'monthly'),
        ],
        status: IncomeSourceStatus.Active,
      );

      final totalCosts =
          source.costs.fold(0.0, (sum, cost) => sum + cost.amount);
      final netIncome = source.amount - totalCosts;
      expect(netIncome, 700.0);
      expect(source.status, IncomeSourceStatus.Active);
      expect(source.currency, 'USD');
    });
  });
}
