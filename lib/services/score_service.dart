import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/score.dart';

class ScoreService {
  static const _key = 'scores';

  Future<void> saveScore(Score score) async {
    final prefs = await SharedPreferences.getInstance();
    final scores = await getScores();
    scores.add(score);
    final encoded = scores.map((s) => s.toJson()).toList();
    await prefs.setString(_key, jsonEncode(encoded));
  }

  Future<List<Score>> getScores() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_key);
    if (data == null) return [];
    final decoded = jsonDecode(data) as List;
    return decoded.map((e) => Score.fromJson(e)).toList();
  }

  Future<void> clearScores() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
