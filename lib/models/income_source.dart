class IncomeSource {
  final int id;
  final String name;
  final String type;
  final double amount;
  final List<Cost> costs; // Add costs property

  IncomeSource({
    required this.id,
    required this.name,
    required this.type,
    required this.amount,
    required this.costs, // Add costs to constructor
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
          [], // Parse costs from JSON
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'amount': amount,
      'costs':
          costs.map((cost) => cost.toJson()).toList(), // Include costs in JSON
    };
  }
}

class Cost {
  final String name;
  final double amount;

  Cost({required this.name, required this.amount});

  factory Cost.fromJson(Map<String, dynamic> json) {
    return Cost(
      name: json['name'] as String,
      amount: json['amount'] as double,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'amount': amount,
    };
  }
}
