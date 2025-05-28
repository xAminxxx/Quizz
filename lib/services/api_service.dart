import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/category.dart';
import '../models/question.dart';

class ApiService {
  static const String baseUrl = 'https://opentdb.com';

  // Fetch categories
  Future<List<TriviaCategory>> fetchCategories() async {
    final response = await http.get(Uri.parse('$baseUrl/api_category.php'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return (data['trivia_categories'] as List)
          .map((json) => TriviaCategory.fromJson(json))
          .toList();
    } else {
      throw Exception('Failed to load categories');
    }
  }

  // Fetch questions
  Future<List<Question>> fetchQuestions({
    required int amount,
    required int categoryId,
    required String difficulty,
  }) async {
    final response = await http.get(Uri.parse(
      '$baseUrl/api.php?amount=$amount&category=$categoryId&difficulty=$difficulty&type=multiple',
    ));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return (data['results'] as List)
          .map((json) => Question.fromJson(json))
          .toList();
    } else {
      throw Exception('Failed to load questions');
    }
  }
}
