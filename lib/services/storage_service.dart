import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  Future<void> saveScore(String category, String difficulty, int score) async {
    final prefs = await SharedPreferences.getInstance();
    final key = '$category-$difficulty';
    final currentHighScore = prefs.getInt(key) ?? 0;
    if (score > currentHighScore) {
      await prefs.setInt(key, score);
    }
  }

  Future<Map<String, int>> getHighScores() async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys();
    final scores = <String, int>{};
    for (var key in keys) {
      scores[key] = prefs.getInt(key) ?? 0;
    }
    return scores;
  }

  Future<void> resetScores() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
