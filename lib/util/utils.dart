// utils.dart

import 'package:flutter/material.dart';

// Helper function to get icon based on income source type
IconData getIconForType(String type) {
  switch (type) {
    case 'rental':
      return Icons.house;
    case 'vehicle':
      return Icons.local_shipping;
    case 'coffee':
      return Icons.coffee;
    default:
      return Icons.attach_money;
  }
}

// Helper function to get type name from index
String getTypeName(int index) {
  switch (index) {
    case 0:
      return 'rental';
    case 1:
      return 'vehicle';
    case 2:
      return 'coffee';
    default:
      return '';
  }
}

// Helper function to get index for type
int getTypeIndex(String type) {
  switch (type) {
    case 'rental':
      return 0;
    case 'vehicle':
      return 1;
    case 'coffee':
      return 2;
    default:
      return 0;
  }
}

// Helper function to format currency values
String formatCurrency(double value) {
  if (value.abs() >= 1000000) {
    return '${(value / 1000000).toStringAsFixed(1)}M';
  } else if (value.abs() >= 1000) {
    return '${(value / 1000).toStringAsFixed(1)}K';
  }
  return value.toStringAsFixed(0);
}
