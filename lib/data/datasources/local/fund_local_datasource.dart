import 'package:share_expenses/core/databases/database_helper.dart';
import 'package:uuid/uuid.dart';

import '../../../core/constants/app_constants.dart';
import '../../models/fund.dart';

abstract class FundLocalDataSource {
  Future<List<Fund>> getAllFunds();
  Future<Fund?> getFundById(String id);
  Future<void> addFund(Fund fund);
  Future<void> updateFund(Fund fund);
  Future<void> deleteFund(String id);
  Future<List<Fund>> getFundsByMember(String memberId);
}

class FundLocalDataSourceImpl implements FundLocalDataSource {
  final DatabaseHelper databaseHelper;
  final Uuid uuid = const Uuid();

  FundLocalDataSourceImpl(this.databaseHelper);

  @override
  Future<List<Fund>> getAllFunds() async {
    final db = await databaseHelper.database;
    final maps = await db.query(AppConstants.fundsTable, orderBy: 'date DESC');

    return maps.map((map) => Fund.fromJson(map)).toList();
  }

  @override
  Future<Fund?> getFundById(String id) async {
    final db = await databaseHelper.database;
    final maps = await db.query(
      AppConstants.fundsTable,
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (maps.isEmpty) return null;
    return Fund.fromJson(maps.first);
  }

  @override
  Future<void> addFund(Fund fund) async {
    final db = await databaseHelper.database;
    final fundWithId = fund.copyWith(id: fund.id.isEmpty ? uuid.v4() : fund.id);

    await db.insert(AppConstants.fundsTable, fundWithId.toJson());
  }

  @override
  Future<void> updateFund(Fund fund) async {
    final db = await databaseHelper.database;
    await db.update(
      AppConstants.fundsTable,
      fund.toJson(),
      where: 'id = ?',
      whereArgs: [fund.id],
    );
  }

  @override
  Future<void> deleteFund(String id) async {
    final db = await databaseHelper.database;
    await db.delete(AppConstants.fundsTable, where: 'id = ?', whereArgs: [id]);
  }

  @override
  Future<List<Fund>> getFundsByMember(String memberId) async {
    final db = await databaseHelper.database;
    final maps = await db.query(
      AppConstants.fundsTable,
      where: 'member_id = ?',
      whereArgs: [memberId],
      orderBy: 'date DESC',
    );

    return maps.map((map) => Fund.fromJson(map)).toList();
  }
}
