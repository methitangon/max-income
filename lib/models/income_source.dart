// models/income_source.dart

// ignore_for_file: constant_identifier_names

class IncomeSource {
  final int id;
  final String name;
  final String type;
  final double amount;
  final List<Cost> costs;
  final IncomeSourceStatus status;

  IncomeSource({
    required this.id,
    required this.name,
    required this.type,
    required this.amount,
    required this.costs,
    required this.status,
  });

  factory IncomeSource.fromJson(Map<String, dynamic> json) {
    return IncomeSource(
      id: json['id'] as int,
      name: json['name'] as String,
      type: json['type'] as String,
      amount: json['amount'] as double,
      costs: (json['costs'] as List<dynamic>?)
              ?.map((cost) => Cost.fromJson(cost))
              .toList() ??
          [],
      status: IncomeSourceStatus.values.byName(json['status'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'amount': amount,
      'costs': costs.map((cost) => cost.toJson()).toList(),
      'status': status.name,
    };
  }
}

class Cost {
  final String name;
  final double amount;
  final String frequency;

  Cost({required this.name, required this.amount, required this.frequency});

  factory Cost.fromJson(Map<String, dynamic> json) {
    return Cost(
      name: json['name'] as String,
      amount: json['amount'] as double,
      frequency: json['frequency'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'amount': amount,
      'frequency': frequency,
    };
  }
}

enum IncomeSourceStatus {
  Active,
  InActive,
  Underperforming,
  Unpaid,
}
