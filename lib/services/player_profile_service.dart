import 'package:shared_preferences/shared_preferences.dart';

class PlayerProfileService {
  static const String defaultName = 'Player';

  static const String _playerNameKey = 'player_name';
  static const String _avatarIndexKey = 'player_avatar_index';

  static Future<String> getPlayerName() async {
    final prefs = await SharedPreferences.getInstance();
    final name = prefs.getString(_playerNameKey);

    if (name == null || name.trim().isEmpty) {
      return defaultName;
    }

    return name;
  }

  static Future<int> getAvatarIndex() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_avatarIndexKey) ?? 0;
  }

  static Future<void> saveProfile({
    required String playerName,
    required int avatarIndex,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    final safeName = playerName.trim().isEmpty
        ? defaultName
        : playerName.trim();

    await prefs.setString(_playerNameKey, safeName);
    await prefs.setInt(_avatarIndexKey, avatarIndex);
  }

  static Future<void> resetProfile() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove(_playerNameKey);
    await prefs.remove(_avatarIndexKey);
  }
}