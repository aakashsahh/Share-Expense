import 'package:share_expenses/core/constants/app_constants.dart';
import 'package:share_expenses/core/databases/database_helper.dart';
import 'package:uuid/uuid.dart';

import '../../models/member.dart';

abstract class MemberLocalDataSource {
  Future<List<Member>> getAllMembers();
  Future<Member?> getMemberById(String id);
  Future<void> addMember(Member member);
  Future<void> updateMember(Member member);
  Future<void> deleteMember(String id);
}

class MemberLocalDataSourceImpl implements MemberLocalDataSource {
  final DatabaseHelper databaseHelper;
  final Uuid uuid = const Uuid();

  MemberLocalDataSourceImpl(this.databaseHelper);

  @override
  Future<List<Member>> getAllMembers() async {
    final db = await databaseHelper.database;
    final maps = await db.query(
      AppConstants.membersTable,
      orderBy: 'created_at DESC',
    );

    return maps.map((map) => Member.fromJson(map)).toList();
  }

  @override
  Future<Member?> getMemberById(String id) async {
    final db = await databaseHelper.database;
    final maps = await db.query(
      AppConstants.membersTable,
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (maps.isEmpty) return null;
    return Member.fromJson(maps.first);
  }

  @override
  Future<void> addMember(Member member) async {
    final db = await databaseHelper.database;
    final memberWithId = member.copyWith(
      id: member.id.isEmpty ? uuid.v4() : member.id,
    );

    await db.insert(AppConstants.membersTable, memberWithId.toJson());
  }

  @override
  Future<void> updateMember(Member member) async {
    final db = await databaseHelper.database;
    await db.update(
      AppConstants.membersTable,
      member.toJson(),
      where: 'id = ?',
      whereArgs: [member.id],
    );
  }

  @override
  Future<void> deleteMember(String id) async {
    final db = await databaseHelper.database;
    await db.delete(
      AppConstants.membersTable,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
