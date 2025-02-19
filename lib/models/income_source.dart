class IncomeSource {
  final int id;
  final String name;
  final String type;
  final double amount;
  IncomeSource({
    required this.id,
    required this.name,
    required this.type,
    required this.amount,
  });

  factory IncomeSource.fromJson(Map<String, dynamic> json) {
    return IncomeSource(
      id: json['id'] as int,
      name: json['name'] as String,
      type: json['type'] as String,
      amount: json['amount'] as double,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'amount': amount,
    };
  }
}
