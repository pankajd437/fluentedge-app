import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AppLocalizations {
  final Locale locale;
  AppLocalizations(this.locale);

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static const List<Locale> supportedLocales = [
    Locale('en'),
    Locale('hi'),
  ];

  static AppLocalizations of(BuildContext context) =>
      Localizations.of<AppLocalizations>(context, AppLocalizations)!;

  // ------------------------------------------------------------
  // Common Buttons & Labels
  // ------------------------------------------------------------
  String get continueButton =>
      Intl.message('Continue', name: 'continueButton');
  String get okButton =>
      Intl.message('OK', name: 'okButton');
  String get registrationTitle =>
      Intl.message('User Registration', name: 'registrationTitle');
  String get registrationSubtitle => Intl.message(
        'Let’s personalize your learning journey!',
        name: 'registrationSubtitle',
      );

  // ------------------------------------------------------------
  // Welcome Screen
  // ------------------------------------------------------------
  String get welcomeMessage => Intl.message(
        "Hi! I'm your AI English Mentor – let’s make learning English simple and fun!",
        name: 'welcomeMessage',
      );
  String get welcomeSubtitle => Intl.message(
        "Master English speaking with real-time AI guidance. Let's begin today!",
        name: 'welcomeSubtitle',
      );
  String get nameFieldLabel => Intl.message(
        'What can I call you?',
        name: 'nameFieldLabel',
      );
  String get languageSelectionLabel => Intl.message(
        'Choose Language:',
        name: 'languageSelectionLabel',
      );
  String get nameRequiredError => Intl.message(
        'Please enter your name!',
        name: 'nameRequiredError',
      );
  String get englishLanguageName =>
      Intl.message('English', name: 'englishLanguageName');
  String get hindiLanguageName =>
      Intl.message('हिंदी', name: 'hindiLanguageName');

  // ------------------------------------------------------------
  // Registration Form
  // ------------------------------------------------------------
  String get emailLabel =>
      Intl.message('Email', name: 'emailLabel');
  String get emailHint =>
      Intl.message('Enter your email', name: 'emailHint');
  String get emailRequiredError =>
      Intl.message('Please enter your email!', name: 'emailRequiredError');
  String get invalidEmailError =>
      Intl.message('Enter a valid email', name: 'invalidEmailError');

  String get ageLabel =>
      Intl.message('Age', name: 'ageLabel');
  String get ageHint =>
      Intl.message('Enter your age', name: 'ageHint');
  String get invalidAgeError =>
      Intl.message('Enter a valid age', name: 'invalidAgeError');

  String get genderLabel =>
      Intl.message('Gender', name: 'genderLabel');
  String get genderHint =>
      Intl.message('Enter your gender', name: 'genderHint');
  String get genderRequiredError =>
      Intl.message('Please enter your gender!', name: 'genderRequiredError');

  String get goalLabel =>
      Intl.message('Learning Goal', name: 'goalLabel');
  String get goalRequiredError => Intl.message(
        'Please select your learning goal!',
        name: 'goalRequiredError',
      );

  // ------------------------------------------------------------
  // Profiling Chat
  // ------------------------------------------------------------
  String chatTitle(String userName) => Intl.message(
        'Chat with $userName',
        name: 'chatTitle',
        args: [userName],
      );
  String get messageHint => Intl.message(
        'Type your message...',
        name: 'messageHint',
      );

  // ------------------------------------------------------------
  // Skill Check
  // ------------------------------------------------------------
  String get audioTestInstruction => Intl.message(
        'Listen and choose the correct answer.',
        name: 'audioTestInstruction',
      );
  String get tryAgain => Intl.message(
        'Almost! Give it another try.',
        name: 'tryAgain',
      );
  String get wellDone => Intl.message(
        'Well done! You got it right.',
        name: 'wellDone',
      );

  // ------------------------------------------------------------
  // Tips & Feedback
  // ------------------------------------------------------------
  String get tipMessage => Intl.message(
        'Not sure? Go with what feels closest to you.',
        name: 'tipMessage',
      );

  // ------------------------------------------------------------
  // Skill Check & Onboarding Navigation
  // ------------------------------------------------------------
  String get onboardingComplete => Intl.message(
        'You’re all set! Let’s start learning.',
        name: 'onboardingComplete',
      );

  // ------------------------------------------------------------
  // Course Recommendations
  // ------------------------------------------------------------
  String get yourRecommendations => Intl.message(
        'Your Personalized Courses',
        name: 'yourRecommendations',
      );
  String get noDataError => Intl.message(
        'No data provided.',
        name: 'noDataError',
      );

  // ------------------------------------------------------------
  // Utility for two-language responses (if needed)
  // ------------------------------------------------------------
  String getWelcomeResponse(String userName, String langPref) {
    if (langPref.toLowerCase().contains('hi')) {
      return 'नमस्ते $userName! अभ्यास के लिए तैयार?';
    } else {
      return 'Hi $userName! Ready to practice?';
    }
  }
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) =>
      AppLocalizations.supportedLocales
          .any((l) => l.languageCode == locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async {
    Intl.defaultLocale = locale.languageCode;
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
