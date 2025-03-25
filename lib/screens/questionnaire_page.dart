import 'package:flutter/material.dart';
import 'package:fluentedge_app/services/api_service.dart';
import 'package:fluentedge_app/localization/app_localizations.dart';

class QuestionnairePage extends StatefulWidget {
  final String userName;
  final String languagePreference;

  const QuestionnairePage({
    super.key,
    required this.userName,
    required this.languagePreference,
  });

  @override
  State<QuestionnairePage> createState() => _QuestionnairePageState();
}

class _QuestionnairePageState extends State<QuestionnairePage> {
  int _step = 0;

  String? motivation;
  String? englishLevel;
  String? learningStyle;
  String? difficultyArea;
  String? dailyTime;
  String? learningTimeline;

  late AppLocalizations localizations;

  // 🔁 Use dynamic getters to pull localized content
  List<String> get localizedMotivations => localizations.getMotivationOptions(widget.languagePreference);
  List<String> get localizedLevels => localizations.getEnglishLevelOptions(widget.languagePreference);
  List<String> get localizedStyles => localizations.getLearningStyleOptions(widget.languagePreference);
  List<String> get localizedDifficulties => localizations.getDifficultyOptions(widget.languagePreference);
  List<String> get localizedTimeOptions => localizations.getTimeOptions(widget.languagePreference);
  List<String> get localizedTimelineOptions => localizations.getTimelineOptions(widget.languagePreference);

  void _handleNext(String selectedValue) {
    setState(() {
      switch (_step) {
        case 0:
          motivation = selectedValue;
          break;
        case 1:
          englishLevel = selectedValue;
          break;
        case 2:
          learningStyle = selectedValue;
          break;
        case 3:
          difficultyArea = selectedValue;
          break;
        case 4:
          dailyTime = selectedValue;
          break;
        case 5:
          learningTimeline = selectedValue;
          break;
      }

      if (_step < 5) {
        _step++;
      } else {
        _submitUserData();
      }
    });
  }

  Future<void> _submitUserData() async {
    try {
      final result = await ApiService.saveUserResponses(
        name: widget.userName,
        motivation: motivation ?? '',
        englishLevel: englishLevel ?? '',
        learningStyle: learningStyle ?? '',
        difficultyArea: difficultyArea ?? '',
        dailyTime: dailyTime ?? '',
        learningTimeline: learningTimeline ?? '',
      );

      final course = result['recommended_course'] ?? 'FluentEdge Starter Course';

      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text("🎯 ${localizations.languageInfoTitle}"),
          content: Text(
            "${localizations.getLocalizedWelcomeMessage(widget.languagePreference)}\n\n📘 $course",
            style: const TextStyle(fontSize: 16),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(localizations.continueButton),
            )
          ],
        ),
      );
    } catch (e) {
      debugPrint("❌ Submission error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("❗ ${localizations.nameRequiredError}")),
      );
    }
  }

  Widget _buildOptions(List<String> options) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: options.map((option) {
        return ElevatedButton(
          onPressed: () => _handleNext(option),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blueAccent,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
          child: Text(option, style: const TextStyle(color: Colors.white)),
        );
      }).toList(),
    );
  }

  Widget _buildStepUI() {
    localizations = AppLocalizations.of(context) ?? AppLocalizations(const Locale('en'));
    final theme = Theme.of(context).textTheme;

    String getQuestion() {
      switch (_step) {
        case 0:
          return localizations.getStep1Question(widget.languagePreference);
        case 1:
          return localizations.getStep2Question(widget.languagePreference);
        case 2:
          return localizations.getStep3Question(widget.languagePreference);
        case 3:
          return localizations.getStep4Question(widget.languagePreference);
        case 4:
          return localizations.getStep5Question(widget.languagePreference);
        case 5:
          return localizations.getStep6Question(widget.languagePreference);
        default:
          return '';
      }
    }

    List<String> getOptions() {
      switch (_step) {
        case 0:
          return localizedMotivations;
        case 1:
          return localizedLevels;
        case 2:
          return localizedStyles;
        case 3:
          return localizedDifficulties;
        case 4:
          return localizedTimeOptions;
        case 5:
          return localizedTimelineOptions;
        default:
          return [];
      }
    }

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 40.0), // Extra spacing for safety
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Hi ${widget.userName}! 👋", style: theme.headlineSmall),
            const SizedBox(height: 10),
            Text(getQuestion(), style: theme.titleLarge),
            const SizedBox(height: 20),
            _buildOptions(getOptions()),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("📝 Your English Journey"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _buildStepUI(),
      ),
    );
  }
}
