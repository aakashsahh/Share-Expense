import 'package:shared_preferences/shared_preferences.dart';

abstract class AppPreferences {
  Future<bool> isFirstTime();
  Future<void> setFirstTime(bool isFirstTime);
  Future<String?> getThemeMode();
  Future<void> setThemeMode(String themeMode);
}

class AppPreferencesImpl implements AppPreferences {
  final SharedPreferences sharedPreferences;

  AppPreferencesImpl(this.sharedPreferences);

  @override
  Future<bool> isFirstTime() async {
    return sharedPreferences.getBool('first_time') ?? true;
  }

  @override
  Future<void> setFirstTime(bool isFirstTime) async {
    await sharedPreferences.setBool('first_time', isFirstTime);
  }

  @override
  Future<String?> getThemeMode() async {
    return sharedPreferences.getString('theme_mode');
  }

  @override
  Future<void> setThemeMode(String themeMode) async {
    await sharedPreferences.setString('theme_mode', themeMode);
  }
}
