import 'package:flutter/material.dart';
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
    final grouped = <String, List<Score>>{};
    final loaded = await service.getScores();
    loaded.sort((a, b) => b.score.compareTo(a.score));
    setState(() => scores = loaded);

    for (final score in loaded) {
      final key = '${score.category} | ${score.difficulty}';
      grouped.putIfAbsent(key, () => []).add(score);
    }
  }

  Future<void> _clearScores() async {
    final service = ScoreService();
    await service.clearScores();
    setState(() => scores = []);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Leaderboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_forever),
            onPressed: _clearScores,
            tooltip: 'Clear all scores',
          ),
        ],
      ),
      body: scores.isEmpty
          ? const Center(child: Text('No scores yet.'))
          : ListView(
              children: _buildGroupedScores(),
            ),
    );
  }

  List<Widget> _buildGroupedScores() {
    final grouped = <String, List<Score>>{};
    for (final score in scores) {
      final key = '${score.category} | ${score.difficulty}';
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
            title: Text('Score: ${score.score}'),
            subtitle:
                Text('${score.timestamp.toLocal().toString().split(".")[0]}'),
          )));
      widgets.add(const Divider());
    }
    return widgets;
  }
}
