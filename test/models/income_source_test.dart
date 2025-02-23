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
      );

      expect(source.id, 1);
      expect(source.name, 'Rental Property');
      expect(source.type, 'rental');
      expect(source.amount, 1000.0);
      expect(source.costs, isEmpty);
    });

    test('creates an IncomeSource instance with costs', () {
      final source = IncomeSource(
        id: 1,
        name: 'Rental Property',
        type: 'rental',
        amount: 1000.0,
        costs: [
          Cost(name: 'Maintenance', amount: 100.0),
          Cost(name: 'Insurance', amount: 50.0),
        ],
      );

      expect(source.costs.length, 2);
      expect(source.costs.first.name, 'Maintenance');
      expect(source.costs.first.amount, 100.0);
      expect(source.costs.last.name, 'Insurance');
      expect(source.costs.last.amount, 50.0);
    });

    group('JSON Serialization', () {
      test('fromJson creates correct IncomeSource instance', () {
        final json = {
          'id': 1,
          'name': 'Rental Property',
          'type': 'rental',
          'amount': 1000.0,
          'costs': [
            {'name': 'Maintenance', 'amount': 100.0},
            {'name': 'Insurance', 'amount': 50.0},
          ],
        };

        final source = IncomeSource.fromJson(json);

        expect(source.id, 1);
        expect(source.name, 'Rental Property');
        expect(source.type, 'rental');
        expect(source.amount, 1000.0);
        expect(source.costs.length, 2);
        expect(source.costs.first.name, 'Maintenance');
        expect(source.costs.first.amount, 100.0);
      });

      test('toJson creates correct JSON map', () {
        final source = IncomeSource(
          id: 1,
          name: 'Rental Property',
          type: 'rental',
          amount: 1000.0,
          costs: [
            Cost(name: 'Maintenance', amount: 100.0),
            Cost(name: 'Insurance', amount: 50.0),
          ],
        );

        final json = source.toJson();

        expect(json['id'], 1);
        expect(json['name'], 'Rental Property');
        expect(json['type'], 'rental');
        expect(json['amount'], 1000.0);
        expect(json['costs'], [
          {'name': 'Maintenance', 'amount': 100.0},
          {'name': 'Insurance', 'amount': 50.0},
        ]);
      });

      test('handles empty costs array in JSON', () {
        final json = {
          'id': 1,
          'name': 'Rental Property',
          'type': 'rental',
          'amount': 1000.0,
          'costs': [],
        };

        final source = IncomeSource.fromJson(json);
        expect(source.costs, isEmpty);
      });

      test('handles missing costs array in JSON', () {
        final json = {
          'id': 1,
          'name': 'Rental Property',
          'type': 'rental',
          'amount': 1000.0,
        };

        final source = IncomeSource.fromJson(json);
        expect(source.costs, isEmpty);
      });
    });

    group('Cost', () {
      test('creates a Cost instance with required properties', () {
        final cost = Cost(name: 'Maintenance', amount: 100.0);

        expect(cost.name, 'Maintenance');
        expect(cost.amount, 100.0);
      });

      test('fromJson creates correct Cost instance', () {
        final json = {
          'name': 'Maintenance',
          'amount': 100.0,
        };

        final cost = Cost.fromJson(json);

        expect(cost.name, 'Maintenance');
        expect(cost.amount, 100.0);
      });

      test('toJson creates correct JSON map', () {
        final cost = Cost(name: 'Maintenance', amount: 100.0);

        final json = cost.toJson();

        expect(json['name'], 'Maintenance');
        expect(json['amount'], 100.0);
      });
    });

    test('calculates total costs correctly', () {
      final source = IncomeSource(
        id: 1,
        name: 'Rental Property',
        type: 'rental',
        amount: 1000.0,
        costs: [
          Cost(name: 'Maintenance', amount: 100.0),
          Cost(name: 'Insurance', amount: 50.0),
          Cost(name: 'Property Tax', amount: 150.0),
        ],
      );

      final totalCosts =
          source.costs.fold(0.0, (sum, cost) => sum + cost.amount);
      expect(totalCosts, 300.0);
    });

    test('net income calculation is correct', () {
      final source = IncomeSource(
        id: 1,
        name: 'Rental Property',
        type: 'rental',
        amount: 1000.0,
        costs: [
          Cost(name: 'Maintenance', amount: 100.0),
          Cost(name: 'Insurance', amount: 50.0),
        ],
      );

      final totalCosts =
          source.costs.fold(0.0, (sum, cost) => sum + cost.amount);
      final netIncome = source.amount - totalCosts;
      expect(netIncome, 850.0);
    });
  });
}
