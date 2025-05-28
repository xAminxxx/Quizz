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

  // ... (imports et extension StringExtension inchangés)

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Quiz Settings')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('Select Category',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            DropdownButtonFormField<int>(
              decoration: const InputDecoration(border: OutlineInputBorder()),
              value: selectedCategoryId,
              items: categories
                  .map((category) => DropdownMenuItem(
                        value: category.id,
                        child: Text(category.name),
                      ))
                  .toList(),
              onChanged: (value) => setState(() => selectedCategoryId = value),
            ),
            const SizedBox(height: 20),
            const Text('Select Difficulty',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(border: OutlineInputBorder()),
              value: selectedDifficulty,
              items: ['easy', 'medium', 'hard']
                  .map((difficulty) => DropdownMenuItem(
                        value: difficulty,
                        child: Text(difficulty),
                      ))
                  .toList(),
              onChanged: (value) => setState(() => selectedDifficulty = value!),
            ),
            const SizedBox(height: 20),
            const Text('Number of Questions',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            DropdownButtonFormField<int>(
              decoration: const InputDecoration(border: OutlineInputBorder()),
              value: selectedQuestionCount,
              items: [5, 10, 15]
                  .map((count) => DropdownMenuItem(
                        value: count,
                        child: Text('$count Questions'),
                      ))
                  .toList(),
              onChanged: (value) =>
                  setState(() => selectedQuestionCount = value!),
            ),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              icon: const Icon(Icons.play_circle_fill),
              label: const Text('Start Quiz'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
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
            ),
          ],
        ),
      ),
    );
  }
}
