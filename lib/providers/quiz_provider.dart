import 'package:flutter/material.dart';
import '../models/question.dart';

class QuizProvider with ChangeNotifier {
  List<Question> _questions = [];
  int _currentQuestionIndex = 0;
  int _score = 0;
  bool _isAnswered = false;
  String? _selectedAnswer;
  int _timeLeft = 30; // 30 seconds per question
  List<String> _shuffledAnswers = []; // Store shuffled answers

  List<Question> get questions => _questions;
  int get currentQuestionIndex => _currentQuestionIndex;
  int get score => _score;
  bool get isAnswered => _isAnswered;
  String? get selectedAnswer => _selectedAnswer;
  int get timeLeft => _timeLeft;
  List<String> get shuffledAnswers => _shuffledAnswers;

  void setQuestions(List<Question> questions) {
    _questions = questions;
    _currentQuestionIndex = 0;
    _score = 0;
    _isAnswered = false;
    _selectedAnswer = null;
    _timeLeft = 30;
    _shuffleAnswers(); // Shuffle answers for the first question
    notifyListeners();
  }

  void _shuffleAnswers() {
    if (_questions.isNotEmpty) {
      final question = _questions[_currentQuestionIndex];
      _shuffledAnswers = [question.correctAnswer, ...question.incorrectAnswers]
        ..shuffle();
    }
  }

  void answerQuestion(String answer) {
    _selectedAnswer = answer;
    _isAnswered = true;
    if (answer == _questions[_currentQuestionIndex].correctAnswer) {
      _score++;
    }
    notifyListeners();
  }

  void nextQuestion() {
    if (_currentQuestionIndex < _questions.length - 1) {
      _currentQuestionIndex++;
      _isAnswered = false;
      _selectedAnswer = null;
      _timeLeft = 30;
      _shuffleAnswers(); // Shuffle answers for the next question
      notifyListeners();
    }
  }

  void updateTimer() {
    if (_timeLeft > 0) {
      _timeLeft--;
      notifyListeners();
    }
  }
}
