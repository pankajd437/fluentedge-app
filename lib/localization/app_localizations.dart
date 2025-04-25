import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AppLocalizations {
  final Locale locale;
  AppLocalizations(this.locale);

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  static const List<Locale> supportedLocales = [
    Locale('en'),
    Locale('hi'),
  ];

  static AppLocalizations of(BuildContext context) =>
      Localizations.of<AppLocalizations>(context, AppLocalizations)!;

  // ------------------------------------------------------------
  // Common Buttons & Labels
  // ------------------------------------------------------------
  String get continueButton => Intl.message('Continue', name: 'continueButton');
  String get okButton => Intl.message('OK', name: 'okButton');
  String get registerButton => Intl.message('Register', name: 'registerButton');

  // ------------------------------------------------------------
  // Welcome Screen
  // ------------------------------------------------------------
  String get welcomeMessage => Intl.message(
        "Hi! I'm your AI English Mentor – let’s make learning English simple and fun!",
        name: 'welcomeMessage',
      );

  String get welcomeMessageHindi => Intl.message(
        "नमस्ते! मैं आपकी AI इंग्लिश मेंटर हूँ – चलिए अंग्रेजी को आसान और मजेदार बनाते हैं!",
        name: 'welcomeMessageHindi',
      );

  String get welcomeSubtitle => Intl.message(
        "Master English speaking with real-time AI guidance. Let's begin today!",
        name: 'welcomeSubtitle',
      );

  String get welcomeSubtitleHi => Intl.message(
        "रीयल-टाइम AI मार्गदर्शन के साथ अंग्रेजी बोलना सीखें।",
        name: 'welcomeSubtitleHi',
      );

  String get nameFieldLabel => Intl.message('What can I call you?', name: 'nameFieldLabel');
  String get nameRequiredError => Intl.message('Please enter your name!', name: 'nameRequiredError');
  String get englishLanguageName => Intl.message('English', name: 'englishLanguageName');
  String get hindiLanguageName => Intl.message('हिंदी', name: 'hindiLanguageName');
  String get languageSelectionLabel => Intl.message('Choose Language:', name: 'languageSelectionLabel');

  String getLocalizedNameFieldLabel(String lang) {
    return lang.toLowerCase().contains('hi')
        ? "आपका नाम क्या है?"
        : "What can I call you?";
  }

  // ------------------------------------------------------------
  // Registration Form
  // ------------------------------------------------------------
  String get registrationTitle => Intl.message('User Registration', name: 'registrationTitle');
  String get registrationSubtitle => Intl.message('Let’s personalize your learning journey!', name: 'registrationSubtitle');

  String get nameLabel => Intl.message('Your Name', name: 'nameLabel');
  String get nameHint => Intl.message('e.g. John', name: 'nameHint');

  String get emailLabel => Intl.message('Email', name: 'emailLabel');
  String get emailHint => Intl.message('Enter your email', name: 'emailHint');
  String get emailRequiredError => Intl.message('Please enter your email!', name: 'emailRequiredError');
  String get invalidEmailError => Intl.message('Enter a valid email', name: 'invalidEmailError');

  String get ageLabel => Intl.message('Age', name: 'ageLabel');
  String get ageHint => Intl.message('Enter your age', name: 'ageHint');
  String get invalidAgeError => Intl.message('Enter a valid age', name: 'invalidAgeError');

  String get genderLabel => Intl.message('Gender', name: 'genderLabel');
  String get genderHint => Intl.message('Enter your gender', name: 'genderHint');
  String get genderRequiredError => Intl.message('Please enter your gender!', name: 'genderRequiredError');

  String get goalLabel => Intl.message('Learning Goal', name: 'goalLabel');
  String get goalRequiredError => Intl.message('Please select your learning goal!', name: 'goalRequiredError');

  // ------------------------------------------------------------
  // Goal Options
  // ------------------------------------------------------------
  String get goalImproveSpeaking => Intl.message('Improve Speaking Fluency', name: 'goalImproveSpeaking');
  String get goalInterviewPrep => Intl.message('Prepare for Interviews', name: 'goalInterviewPrep');
  String get goalBuildConfidence => Intl.message('Build Confidence', name: 'goalBuildConfidence');
  String get goalLearnFromZero => Intl.message('Learn from Zero', name: 'goalLearnFromZero');
  String get goalTravel => Intl.message('Travel Communication', name: 'goalTravel');
  String get goalProfessionalEnglish => Intl.message('Professional English', name: 'goalProfessionalEnglish');

  // ------------------------------------------------------------
  // Profiling Chat / Ice Breaker Chat
  // ------------------------------------------------------------
  String chatTitle(String userName) => Intl.message('Chat with $userName', name: 'chatTitle', args: [userName]);

  String get messageHint => Intl.message('Type your message...', name: 'messageHint');
  String get languageInfoTitle => Intl.message('Practice Language', name: 'languageInfoTitle');

  String getAIResponse(String userName, String lang) {
    return lang.toLowerCase().contains('hi')
        ? 'हाय $userName! आप मुझसे कुछ भी पूछ सकते हैं।'
        : 'Hi $userName! Ask me anything.';
  }

  String getPracticeLanguageMessage(String lang) {
    return lang.toLowerCase().contains('hi')
        ? 'आप अभी हिंदी में अभ्यास कर रहे हैं।'
        : 'You’re currently practicing in English.';
  }

  String getWelcomeResponse(String userName, String langPref) {
    if (langPref.toLowerCase().contains('hi')) {
      return 'नमस्ते $userName! अभ्यास के लिए तैयार?';
    } else {
      return 'Hi $userName! Ready to practice?';
    }
  }

  // ------------------------------------------------------------
  // Skill Check
  // ------------------------------------------------------------
  String get skillCheckTitle => Intl.message('Skill Check', name: 'skillCheckTitle');

  String skillCheckProgressLabel(int current, int total) => Intl.message(
        'Question $current of $total',
        name: 'skillCheckProgressLabel',
        args: [current, total],
      );

  String get audioTestInstruction => Intl.message('Listen and choose the correct answer.', name: 'audioTestInstruction');
  String get tryAgain => Intl.message('Almost! Give it another try.', name: 'tryAgain');
  String get wellDone => Intl.message('Well done! You got it right.', name: 'wellDone');
  String get playAudioButton => Intl.message('Play Audio', name: 'playAudioButton');

  // ------------------------------------------------------------
  // Tips & Feedback
  // ------------------------------------------------------------
  String get tipMessage => Intl.message('Not sure? Go with what feels closest to you.', name: 'tipMessage');

  // ------------------------------------------------------------
  // Skill Check & Onboarding Navigation
  // ------------------------------------------------------------
  String get onboardingComplete => Intl.message('You’re all set! Let’s start learning.', name: 'onboardingComplete');

  // ------------------------------------------------------------
  // Course Recommendations
  // ------------------------------------------------------------
  String get yourRecommendations => Intl.message('Your Personalized Courses', name: 'yourRecommendations');
  String get noDataError => Intl.message('No data provided.', name: 'noDataError');
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) =>
      AppLocalizations.supportedLocales.any((l) => l.languageCode == locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async {
    Intl.defaultLocale = locale.languageCode;
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
