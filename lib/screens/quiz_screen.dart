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
              builder: (context, currentQuestionIndex, _) {
                return Text('Question ${currentQuestionIndex + 1}');
              },
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Selector<QuizProvider, int>(
                  selector: (_, provider) => provider.timeLeft,
                  builder: (context, timeLeft, _) {
                    return Text('Time: ${timeLeft}s');
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
                final question = data.question;
                final answers = data.answers;
                final isAnswered = data.isAnswered;
                final selectedAnswer = data.selectedAnswer;

                return Column(
                  children: [
                    Text(
                      question.question,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    ...answers.map((answer) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: isAnswered
                                  ? (answer == question.correctAnswer
                                      ? Colors.green
                                      : (answer == selectedAnswer
                                          ? Colors.red
                                          : null))
                                  : null,
                            ),
                            onPressed: isAnswered
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
                            child: AnimatedScale(
                              scale: isAnswered && selectedAnswer == answer
                                  ? 1.1
                                  : 1.0,
                              duration: const Duration(milliseconds: 100),
                              child: Text(answer),
                            ),
                          ),
                        )),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }
}
