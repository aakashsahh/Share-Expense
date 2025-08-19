import 'package:flutter/material.dart';
import 'package:share_expenses/core/constants/app_constants.dart';
import 'package:share_expenses/core/databases/database_helper.dart';
import 'package:share_expenses/data/models/category_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';

abstract class CategoryLocalDataSource {
  Future<List<Category>> getAllCategories();
  Future<Category?> getCategoryById(String id);
  Future<void> addCategory(Category category);
  Future<void> updateCategory(Category category);
  Future<void> deleteCategory(String id);
  Future<void> initDefaultCategories();
}

class CategoryLocalDataSourceImpl implements CategoryLocalDataSource {
  final DatabaseHelper databaseHelper;
  final Uuid uuid = const Uuid();

  CategoryLocalDataSourceImpl(this.databaseHelper);

  @override
  Future<List<Category>> getAllCategories() async {
    final db = await databaseHelper.database;
    final maps = await db.query('categories', orderBy: 'name ASC');
    return maps.map((map) => Category.fromJson(map)).toList();
  }

  @override
  Future<Category?> getCategoryById(String id) async {
    final db = await databaseHelper.database;
    final maps = await db.query(
      'categories',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (maps.isEmpty) return null;
    return Category.fromJson(maps.first);
  }

  @override
  Future<void> addCategory(Category category) async {
    final db = await databaseHelper.database;
    final categoryWithId = category.copyWith(
      id: category.id.isEmpty ? uuid.v4() : category.id,
    );
    await db.insert('categories', categoryWithId.toJson());
  }

  @override
  Future<void> updateCategory(Category category) async {
    final db = await databaseHelper.database;
    await db.update(
      'categories',
      category.toJson(),
      where: 'id = ?',
      whereArgs: [category.id],
    );
  }

  @override
  Future<void> deleteCategory(String id) async {
    final db = await databaseHelper.database;
    await db.delete('categories', where: 'id = ?', whereArgs: [id]);
  }

  @override
  Future<void> initDefaultCategories() async {
    final db = await databaseHelper.database;

    final count = Sqflite.firstIntValue(
      await db.rawQuery('SELECT COUNT(*) FROM categories'),
    );

    if (count == 0) {
      final defaults = [
        {
          "name": "Others",
          "iconCodePoint": Icons.more_horiz.codePoint,
          "iconFontFamily": Icons.more_horiz.fontFamily,
          "type": "expense",
          "color": 0xFF9E9E9E, // grey
        },
        {
          "name": "Food and Dining",
          "iconCodePoint": Icons.restaurant.codePoint,
          "iconFontFamily": Icons.restaurant.fontFamily,
          "type": "expense",
          "color": 0xFFFF9800, // orange
        },
        {
          "name": "Shopping",
          "iconCodePoint": Icons.shopping_cart.codePoint,
          "iconFontFamily": Icons.shopping_cart.fontFamily,
          "type": "expense",
          "color": 0xFF2196F3, // blue
        },
        {
          "name": "Travelling",
          "iconCodePoint": Icons.directions_car.codePoint,
          "iconFontFamily": Icons.directions_car.fontFamily,
          "type": "expense",
          "color": 0xFF9C27B0, // purple
        },

        {
          "name": "Personal Care",
          "iconCodePoint": Icons.spa.codePoint,
          "iconFontFamily": Icons.spa.fontFamily,
          "type": "expense",
          "color": 0xFF5D4037, // brown
        },
        {
          "name": "Education",
          "iconCodePoint": Icons.school.codePoint,
          "iconFontFamily": Icons.school.fontFamily,
          "type": "expense",
          "color": 0xFF3F51B5, // indigo
        },
        {
          "name": "Investments",
          "iconCodePoint": Icons.trending_up.codePoint,
          "iconFontFamily": Icons.trending_up.fontFamily,
          "type": "expense",
          "color": 0xFF4CAF50, // green
        },
        {
          "name": "Rent",
          "iconCodePoint": Icons.home.codePoint,
          "iconFontFamily": Icons.home.fontFamily,
          "type": "expense",
          "color": 0xFF009688, // teal
        },

        {
          "name": "Gifts and Donation",
          "iconCodePoint": Icons.card_giftcard.codePoint,
          "iconFontFamily": Icons.card_giftcard.fontFamily,
          "type": "expense",
          "color": 0xFFF06292, // pink
        },
        {
          "name": "Kitchen",
          "iconCodePoint": Icons.restaurant_menu.codePoint,
          "iconFontFamily": Icons.restaurant_menu.fontFamily,
          "type": "expense",
          "color": 0xFF388E3C, // dark green
        },

        {
          "name": "Salary",
          "iconCodePoint": Icons.work.codePoint,
          "iconFontFamily": Icons.work.fontFamily,
          "type": "income",
          "color": 0xFF81C784, // green
        },
      ];

      for (final cat in defaults) {
        await db.insert(AppConstants.categoriesTable, {
          "id": const Uuid().v4(),
          "name": cat["name"],
          "iconCodePoint": cat["iconCodePoint"],
          "iconFontFamily": cat["iconFontFamily"],
          "type": cat["type"],
          "color": cat["color"],
        });
      }
    }
  }
}
