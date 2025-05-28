import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  Future<void> _launchOpenTDB() async {
    final url = Uri.parse('https://opentdb.com');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('About')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.quiz, size: 80, color: theme.colorScheme.primary),
            const SizedBox(height: 20),
            Text(
              'Quiz App',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'This app allows users to play interactive quizzes across various categories, difficulties, and question counts.',
              style: theme.textTheme.bodyLarge,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(Icons.api, size: 20),
                const SizedBox(width: 8),
                Flexible(
                  child: GestureDetector(
                    onTap: _launchOpenTDB,
                    child: Text(
                      'Powered by Open Trivia Database',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: theme.colorScheme.primary,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),
            const Divider(),
            Text(
              'Created by Your Team or Name',
              style: theme.textTheme.bodySmall,
            ),
            Text(
              '© 2025 • Mobile Programming Mini-Project',
              style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
