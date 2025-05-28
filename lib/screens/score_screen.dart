import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../services/score_service.dart';
import '../models/score.dart';

class ScoreScreen extends StatefulWidget {
  const ScoreScreen({super.key});

  @override
  State<ScoreScreen> createState() => _ScoreScreenState();
}

class _ScoreScreenState extends State<ScoreScreen> {
  List<Score> scores = [];

  @override
  void initState() {
    super.initState();
    _loadScores();
  }

  Future<void> _loadScores() async {
    final service = ScoreService();
    final loaded = await service.getScores();
    loaded.sort((a, b) => b.score.compareTo(a.score));
    setState(() => scores = loaded);
  }

  Future<void> _clearScores() async {
    final service = ScoreService();
    await service.clearScores();
    setState(() => scores = []);
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(t.leaderboard),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_forever),
            tooltip: t.clearScores,
            onPressed: _clearScores,
          ),
        ],
      ),
      body: scores.isEmpty
          ? Center(child: Text(t.noScores))
          : ListView(children: _buildGroupedScores(t)),
    );
  }

  List<Widget> _buildGroupedScores(AppLocalizations t) {
    final grouped = <String, List<Score>>{};
    for (final score in scores) {
      final key =
          '${score.category} | ${_translateDifficulty(score.difficulty, t)}';
      grouped.putIfAbsent(key, () => []).add(score);
    }

    final widgets = <Widget>[];
    for (final entry in grouped.entries) {
      widgets.add(Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(entry.key,
            style: const TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue)),
      ));
      widgets.addAll(entry.value.map((score) => ListTile(
            leading: CircleAvatar(child: Text('${score.score}')),
            title: Text('${t.scoreLabel}: ${score.score}'),
            subtitle: Text(
              '${score.timestamp.toLocal().toString().split(".")[0]}',
              style: const TextStyle(fontSize: 12),
            ),
          )));
      widgets.add(const Divider());
    }
    return widgets;
  }

  String _translateDifficulty(String difficulty, AppLocalizations t) {
    switch (difficulty) {
      case 'easy':
        return t.difficultyEasy;
      case 'medium':
        return t.difficultyMedium;
      case 'hard':
        return t.difficultyHard;
      default:
        return difficulty;
    }
  }
}
