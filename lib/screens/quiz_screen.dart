import 'dart:async';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vibration/vibration.dart';
import '../services/api_service.dart';
import '../providers/quiz_provider.dart';
import 'result_screen.dart';
import '../models/question.dart';

class QuizScreen extends StatefulWidget {
  final int categoryId;
  final String difficulty;
  final int questionCount;

  const QuizScreen({
    super.key,
    required this.categoryId,
    required this.difficulty,
    required this.questionCount,
  });

  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _fetchQuestions();
    _startTimer();
  }

  Future<void> _fetchQuestions() async {
    final apiService = ApiService();
    final questions = await apiService.fetchQuestions(
      amount: widget.questionCount,
      categoryId: widget.categoryId,
      difficulty: widget.difficulty,
    );
    Provider.of<QuizProvider>(context, listen: false).setQuestions(questions);
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final quizProvider = Provider.of<QuizProvider>(context, listen: false);
      if (quizProvider.timeLeft == 0) {
        quizProvider.nextQuestion();
      } else {
        quizProvider.updateTimer();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Selector<QuizProvider, bool>(
      selector: (_, provider) => provider.questions.isEmpty,
      builder: (context, isQuestionsEmpty, _) {
        if (isQuestionsEmpty) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: Selector<QuizProvider, int>(
              selector: (_, provider) => provider.currentQuestionIndex,
              builder: (context, index, _) {
                final total = Provider.of<QuizProvider>(context, listen: false)
                    .questions
                    .length;
                return Text('Question ${index + 1}/$total');
              },
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Selector<QuizProvider, int>(
                  selector: (_, provider) => provider.timeLeft,
                  builder: (context, timeLeft, _) {
                    return Row(
                      children: [
                        const Icon(Icons.timer, size: 18),
                        const SizedBox(width: 4),
                        Text('$timeLeft s'),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Selector<
                QuizProvider,
                ({
                  Question question,
                  List<String> answers,
                  bool isAnswered,
                  String? selectedAnswer
                })>(
              selector: (_, provider) => (
                question: provider.questions[provider.currentQuestionIndex],
                answers: provider.shuffledAnswers,
                isAnswered: provider.isAnswered,
                selectedAnswer: provider.selectedAnswer,
              ),
              builder: (context, data, _) {
                final theme = Theme.of(context);
                final question = data.question;
                final answers = data.answers;
                final isAnswered = data.isAnswered;
                final selectedAnswer = data.selectedAnswer;

                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        question.question,
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 24),
                      ...answers.map((answer) {
                        final isCorrect = answer == question.correctAnswer;
                        final isSelected = answer == selectedAnswer;

                        Color? backgroundColor;
                        Icon? icon;

                        if (isAnswered) {
                          if (isCorrect) {
                            backgroundColor = Colors.green[400];
                            icon = const Icon(Icons.check, color: Colors.white);
                          } else if (isSelected) {
                            backgroundColor = Colors.red[400];
                            icon = const Icon(Icons.close, color: Colors.white);
                          }
                        }

                        return Card(
                          color: backgroundColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ListTile(
                            leading: icon,
                            title: Text(answer),
                            onTap: isAnswered
                                ? null
                                : () async {
                                    if (!kIsWeb &&
                                        (await Vibration.hasVibrator())) {
                                      Vibration.vibrate(duration: 100);
                                    }
                                    Provider.of<QuizProvider>(context,
                                            listen: false)
                                        .answerQuestion(answer);

                                    Future.delayed(const Duration(seconds: 1),
                                        () {
                                      final quizProvider =
                                          Provider.of<QuizProvider>(context,
                                              listen: false);
                                      if (quizProvider.currentQuestionIndex <
                                          quizProvider.questions.length - 1) {
                                        quizProvider.nextQuestion();
                                      } else {
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) =>
                                                const ResultScreen(),
                                          ),
                                        );
                                      }
                                    });
                                  },
                          ),
                        );
                      }),
                      const SizedBox(height: 20),
                      LinearProgressIndicator(
                        value: (Provider.of<QuizProvider>(context)
                                    .currentQuestionIndex +
                                1) /
                            Provider.of<QuizProvider>(context).questions.length,
                      ),
                      const SizedBox(height: 8),
                      Center(
                        child: Text(
                          'Score: ${Provider.of<QuizProvider>(context).score}',
                          style: theme.textTheme.bodyLarge!
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
