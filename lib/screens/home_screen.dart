import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../providers/locale_provider.dart';
import 'quiz_settings_screen.dart';
import 'about_screen.dart';
import 'score_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final t = AppLocalizations.of(context)!;
    final localeProvider = Provider.of<LocaleProvider>(context);
    final currentLang = localeProvider.locale.languageCode;

    return Scaffold(
      appBar: AppBar(title: Text(t.appTitle)),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.quiz, size: 100, color: theme.primaryColor),
              const SizedBox(height: 40),

              // Start Quiz
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: const Icon(Icons.play_arrow),
                label: Text(t.startQuiz),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const QuizSettingsScreen()),
                  );
                },
              ),
              const SizedBox(height: 20),

              // Leaderboard
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: const Icon(Icons.leaderboard),
                label: Text(t.leaderboard),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ScoreScreen()),
                  );
                },
              ),
              const SizedBox(height: 20),

              // About
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: const Icon(Icons.info_outline),
                label: Text(t.about),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const AboutScreen()),
                  );
                },
              ),
              const SizedBox(height: 30),

              // 🌍 Language switcher
              TextButton.icon(
                onPressed: () {
                  localeProvider.toggleLocale();
                },
                icon: const Icon(Icons.language),
                label: Text('Language: ${currentLang.toUpperCase()}'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
