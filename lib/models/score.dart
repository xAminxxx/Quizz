class Score {
  final String category;
  final String difficulty;
  final int score;
  final DateTime timestamp;

  Score({
    required this.category,
    required this.difficulty,
    required this.score,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() => {
        'category': category,
        'difficulty': difficulty,
        'score': score,
        'timestamp': timestamp.toIso8601String(),
      };

  factory Score.fromJson(Map<String, dynamic> json) => Score(
        category: json['category'],
        difficulty: json['difficulty'],
        score: json['score'],
        timestamp: DateTime.parse(json['timestamp']),
      );
}
