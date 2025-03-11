import 'dart:convert';
import 'package:e_porter/_core/service/logger_service.dart';
import 'package:e_porter/domain/models/user_entity.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  static const String _userDataKey = "USER_DATA";
  static const String _userDataExpiredKey = "USER_DATA_EXPIRED_AT";
  static const Duration _expireDuration = Duration(days: 1);

  static Future<void> saveUserData(UserData userData) async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = jsonEncode(userData.toMap());
    final expiredAt = DateTime.now().add(_expireDuration).millisecondsSinceEpoch;
    await prefs.setString(_userDataKey, userJson);
    await prefs.setInt(_userDataExpiredKey, expiredAt);
  }

  static Future<UserData?> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final expiredAt = prefs.getInt(_userDataExpiredKey);

    if (expiredAt == null) {
      return null;
    }

    final now = DateTime.now().millisecondsSinceEpoch;
    if (now > expiredAt) {
      await clearUserData();
      logger.d("now: $now, expiredAt: $expiredAt");
      return null;
    }

    final userJson = prefs.getString(_userDataKey);
    if (userJson == null) return null;

    final Map<String, dynamic> map = jsonDecode(userJson);
    final userData = UserData.fromMap(map);
    return userData;
  }

  static Future<void> clearUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userDataKey);
    await prefs.remove(_userDataExpiredKey);
  }
}
