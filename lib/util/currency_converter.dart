// Hardcoded exchange rates for now
const Map<String, Map<String, double>> exchangeRates = {
  'USD': {
    'THB': 35.0,
    'RUB': 95.0,
  },
  'THB': {
    'USD': 0.028,
    'RUB': 2.7,
  },
  'RUB': {
    'USD': 0.010,
    'THB': 0.37,
  },
};

double convertCurrency(double amount, String fromCurrency, String toCurrency) {
  if (fromCurrency == toCurrency) {
    return amount;
  }
  final rate = exchangeRates[fromCurrency]?[toCurrency];
  if (rate == null) {
    throw ArgumentError(
        'Invalid currency conversion: $fromCurrency to $toCurrency');
  }
  return amount * rate;
}
