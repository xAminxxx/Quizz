import 'package:html/parser.dart' show parse;

class Question {
  final String question;
  final String correctAnswer;
  final List<String> incorrectAnswers;
  final String difficulty;

  Question({
    required this.question,
    required this.correctAnswer,
    required this.incorrectAnswers,
    required this.difficulty,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      question: _decodeHtml(json['question'] ?? ''),
      correctAnswer: _decodeHtml(json['correct_answer'] ?? ''),
      incorrectAnswers: (json['incorrect_answers'] as List<dynamic>?)
              ?.map((answer) => _decodeHtml(answer.toString()))
              .toList() ??
          [],
      difficulty: json['difficulty'] ?? '',
    );
  }

  // Decode HTML entities to plain text
  static String _decodeHtml(String htmlString) {
    // Remove HTML tags and decode entities
    final document = parse(htmlString);
    final decodedString = document.body?.text ?? htmlString;
    return decodedString;
  }
}
