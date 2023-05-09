import 'package:shared_preferences/shared_preferences.dart';

abstract class AuthLocalDataSource {
  Future<bool> saveUser(String uid);
  Future<bool> removeUser(String uid);
  String? getUser();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SharedPreferences sharedPreferences;

  const AuthLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<bool> saveUser(String uid) async {
    return await sharedPreferences.setString('uid', uid);
  }

  @override
  Future<bool> removeUser(String uid) async {
    return await sharedPreferences.remove(uid);
  }

  @override
  String? getUser() {
    return sharedPreferences.getString('uid');
  }
}
