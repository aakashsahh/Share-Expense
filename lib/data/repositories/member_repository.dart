import 'package:share_expenses/data/datasources/local/member_local_datasource.dart';

import '../models/member.dart';

abstract class MemberRepository {
  Future<List<Member>> getAllMembers();
  Future<Member?> getMemberById(String id);
  Future<void> addMember(Member member);
  Future<void> updateMember(Member member);
  Future<void> deleteMember(String id);
}

class MemberRepositoryImpl implements MemberRepository {
  final MemberLocalDataSource localDataSource;

  MemberRepositoryImpl(this.localDataSource);

  @override
  Future<List<Member>> getAllMembers() async {
    return await localDataSource.getAllMembers();
  }

  @override
  Future<Member?> getMemberById(String id) async {
    return await localDataSource.getMemberById(id);
  }

  @override
  Future<void> addMember(Member member) async {
    await localDataSource.addMember(member);
  }

  @override
  Future<void> updateMember(Member member) async {
    await localDataSource.updateMember(member);
  }

  @override
  Future<void> deleteMember(String id) async {
    await localDataSource.deleteMember(id);
  }
}
