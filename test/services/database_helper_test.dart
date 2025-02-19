import 'package:flutter_test/flutter_test.dart';
import 'package:max_income/services/database_helper.dart';

void main() {
  group('DatabaseHelper Tests', () {
    late DatabaseHelper dbHelper;

    setUp(() async {
      dbHelper = DatabaseHelper.instance;
      final db = await dbHelper.database;
      // Clear the database before each test
      await db.delete('income_sources');
    });

    test('insert income source', () async {
      final db = await dbHelper.database;

      // Insert a new income source
      final id = await db.insert(
          'income_sources', {'name': 'Rental Property A', 'type': 'rental'});

      // Check if the income source was inserted successfully
      expect(id, greaterThan(0));
    });

    test('get all income sources', () async {
      final db = await dbHelper.database;

      // Insert some income sources
      await db.insert(
          'income_sources', {'name': 'Rental Property A', 'type': 'rental'});
      await db.insert(
          'income_sources', {'name': 'Delivery Truck 1', 'type': 'vehicle'});

      // Retrieve all income sources
      final List<Map<String, dynamic>> maps = await db.query('income_sources');

      // Check if the retrieved data is correct
      expect(maps.length, 2);
      expect(maps[0]['name'], 'Rental Property A');
      expect(maps[0]['type'], 'rental');
      expect(maps[1]['name'], 'Delivery Truck 1');
      expect(maps[1]['type'], 'vehicle');
    });

    test('get income source by ID', () async {
      final db = await dbHelper.database;

      // Insert an income source
      final id = await db.insert(
          'income_sources', {'name': 'Rental Property A', 'type': 'rental'});

      // Retrieve the income source by ID
      final List<Map<String, dynamic>> maps = await db.query(
        'income_sources',
        where: 'id = ?',
        whereArgs: [id],
      );

      // Check if the retrieved data is correct
      expect(maps.length, 1);
      expect(maps[0]['id'], id);
      expect(maps[0]['name'], 'Rental Property A');
      expect(maps[0]['type'], 'rental');
    });

    test('update income source', () async {
      final db = await dbHelper.database;

      // Insert an income source
      final id = await db.insert(
          'income_sources', {'name': 'Rental Property A', 'type': 'rental'});

      // Update the income source
      final updateCount = await db.update(
        'income_sources',
        {'name': 'Rental Property B', 'type': 'rental'},
        where: 'id = ?',
        whereArgs: [id],
      );

      // Check if update was successful
      expect(updateCount, 1);

      // Retrieve the updated income source
      final List<Map<String, dynamic>> maps = await db.query(
        'income_sources',
        where: 'id = ?',
        whereArgs: [id],
      );

      // Check if the data was updated correctly
      expect(maps.length, 1);
      expect(maps[0]['name'], 'Rental Property B');
      expect(maps[0]['type'], 'rental');
    });

    test('delete income source', () async {
      final db = await dbHelper.database;

      // Insert an income source
      final id = await db.insert(
          'income_sources', {'name': 'Rental Property A', 'type': 'rental'});

      // Verify the income source was inserted
      var maps = await db.query(
        'income_sources',
        where: 'id = ?',
        whereArgs: [id],
      );
      expect(maps.length, 1);

      // Delete the income source
      final deleteCount = await db.delete(
        'income_sources',
        where: 'id = ?',
        whereArgs: [id],
      );

      // Check if delete was successful
      expect(deleteCount, 1);

      // Try to retrieve the deleted income source
      maps = await db.query(
        'income_sources',
        where: 'id = ?',
        whereArgs: [id],
      );

      // Check if the income source was deleted
      expect(maps.length, 0);
    });
  });
}
