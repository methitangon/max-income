import 'package:max_income/models/income_source.dart';

final List<IncomeSource> mockIncomeSources = [
  IncomeSource(
    id: 1,
    name: 'Rental Property A',
    type: 'rental',
    amount: 1000,
    costs: [
      Cost(name: 'Maintenance', amount: 500, frequency: 'yearly'),
      Cost(name: 'Property Tax', amount: 100, frequency: 'yearly'),
    ],
    status: 'active',
  ),
  IncomeSource(
    id: 2,
    name: 'Delivery Truck 1',
    type: 'vehicle',
    amount: 2000,
    costs: [
      Cost(name: 'Insurance', amount: 100, frequency: 'monthly'),
      Cost(name: 'Fuel', amount: 200, frequency: 'monthly'),
    ],
    status: 'active',
  ),
  IncomeSource(
    id: 3,
    name: 'Coffee Machine X',
    type: 'coffee',
    amount: 3000,
    costs: [
      Cost(name: 'Maintenance', amount: 50, frequency: 'monthly'),
      Cost(name: 'Supplies', amount: 100, frequency: 'monthly'),
    ],
    status: 'active',
  ),
  IncomeSource(
    id: 4,
    name: 'Rental Property B',
    type: 'rental',
    amount: 4000,
    costs: [
      Cost(name: 'Repair', amount: 200, frequency: 'monthly'),
      Cost(name: 'Utilities', amount: 1500, frequency: 'monthly'),
    ],
    status: 'inActive',
  ),
  IncomeSource(
    id: 5,
    name: 'Delivery Truck 2',
    type: 'vehicle',
    amount: 5000,
    costs: [
      Cost(name: 'Insurance', amount: 150, frequency: 'monthly'),
      Cost(name: 'Fuel', amount: 3000, frequency: 'monthly'),
    ],
    status: 'active',
  ),
];
