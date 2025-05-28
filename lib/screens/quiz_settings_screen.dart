import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/category.dart';
import 'quiz_screen.dart';

class QuizSettingsScreen extends StatefulWidget {
  const QuizSettingsScreen({super.key});

  @override
  _QuizSettingsScreenState createState() => _QuizSettingsScreenState();
}

class _QuizSettingsScreenState extends State<QuizSettingsScreen> {
  List<TriviaCategory> categories = [];
  int? selectedCategoryId;
  String selectedDifficulty = 'easy';
  int selectedQuestionCount = 5;

  @override
  void initState() {
    super.initState();
    _fetchCategories();
  }

  Future<void> _fetchCategories() async {
    final apiService = ApiService();
    categories = await apiService.fetchCategories();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Quiz Settings')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DropdownButton<int>(
              hint: const Text('Select Category'),
              value: selectedCategoryId,
              items: categories
                  .map((category) => DropdownMenuItem(
                        value: category.id,
                        child: Text(category.name),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectedCategoryId = value;
                });
              },
            ),
            DropdownButton<String>(
              hint: const Text('Select Difficulty'),
              value: selectedDifficulty,
              items: ['easy', 'medium', 'hard']
                  .map((difficulty) => DropdownMenuItem(
                        value: difficulty,
                        child: Text(difficulty.capitalize()),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectedDifficulty = value!;
                });
              },
            ),
            DropdownButton<int>(
              hint: const Text('Number of Questions'),
              value: selectedQuestionCount,
              items: [5, 10, 15]
                  .map((count) => DropdownMenuItem(
                        value: count,
                        child: Text('$count Questions'),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectedQuestionCount = value!;
                });
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: selectedCategoryId != null
                  ? () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => QuizScreen(
                            categoryId: selectedCategoryId!,
                            difficulty: selectedDifficulty,
                            questionCount: selectedQuestionCount,
                          ),
                        ),
                      );
                    }
                  : null,
              child: const Text('Start Quiz'),
            ),
          ],
        ),
      ),
    );
  }
}

// Extension to capitalize strings
extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}
