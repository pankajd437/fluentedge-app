import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:math';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static const List<Locale> supportedLocales = [
    Locale('en'),
    Locale('hi'),
  ];

  // ========== Common ==========
  String get continueButton => Intl.message('Continue', name: 'continueButton');
  String get okButton => Intl.message('OK', name: 'okButton');

  // ========== Course List ==========
  String get coursesListTitle => locale.languageCode == 'hi'
      ? 'आपके पर्सनलाइज़्ड कोर्स'
      : 'Your Personalized Courses';

  String get resumeQuestionnaire => locale.languageCode == 'hi'
      ? 'शुरुआती प्रश्नावली फिर से शुरू करें →'
      : 'Resume Questionnaire →';

  String get startNow =>
      locale.languageCode == 'hi' ? 'अभी शुरू करें' : 'Start Now';

  // ========== Welcome Page ==========
  String get welcomeMessage =>
      "Hi! I'm your AI English Mentor – let’s make learning English simple and fun!";

  String get welcomeMessageHindi =>
      'नमस्ते! मैं हूँ आपका AI इंग्लिश मेंटर – चलिए आसान और मज़ेदार तरीक़े से इंग्लिश सीखते हैं!';

  String get welcomeSubtitle =>
      "Master English speaking with real-time AI guidance. Let's begin your journey today!";

  String get nameFieldLabel => locale.languageCode == 'hi'
      ? 'आपको क्या बुलाऊँ?'
      : 'What can I call you?';

  String get languageSelectionLabel =>
      locale.languageCode == 'hi' ? 'भाषा चुनें:' : 'Choose Language:';

  String get nameRequiredError =>
      locale.languageCode == 'hi' ? 'कृपया अपना नाम डालें!' : 'Please enter your name!';

  // ========== Chat Page ==========
  String chatTitle(String userName) => locale.languageCode == 'hi'
      ? '$userName के साथ चैट करें'
      : 'Chat with $userName';

  String get messageHint =>
      locale.languageCode == 'hi' ? 'अपना मैसेज टाइप करें...' : 'Type your message...';

  String get languageInfoTitle =>
      locale.languageCode == 'hi' ? 'भाषा का अभ्यास करें' : 'Practice Language';

  String get englishPracticeMessage => "We're practicing in English mode";
  String get hindiPracticeMessage => 'हम हिंदी मोड में अभ्यास कर रहे हैं';

  // ========== Two-Argument Method: getWelcomeResponse ==========
  /// Called from ice_breaking_chat to show initial welcome line
  String getWelcomeResponse(String userName, String langPref) {
    if (langPref.toLowerCase().contains('hi')) {
      return 'नमस्ते $userName! अंग्रेज़ी का अभ्यास करने के लिए तैयार हैं?';
    } else {
      return 'Hi $userName! Ready to practice?';
    }
  }

  // ========== 2-Argument AI Response Method for user input ==========
  String getAIResponse(String userName, String langPref) {
    final random = Random();
    if (langPref.toLowerCase().contains('hi')) {
      final hindiReplies = [
        'बहुत बढ़िया $userName! अब कुछ और अभ्यास करें।',
        'शानदार! अब एक और कोशिश करें।',
        'अच्छा किया! अब एक नया वाक्य बोलें।',
      ];
      return hindiReplies[random.nextInt(hindiReplies.length)];
    } else {
      final englishReplies = [
        "That's a great start! Let's practice some more.",
        'Well done! Can you try saying that differently?',
        'Nice! Now let’s add more vocabulary.',
      ];
      return englishReplies[random.nextInt(englishReplies.length)];
    }
  }

  /// For the initial AI greeting if needed
  String aiWelcomeResponse(String userName) => locale.languageCode == 'hi'
      ? 'नमस्ते $userName! अंग्रेज़ी का अभ्यास करने के लिए तैयार हैं?'
      : 'Hi $userName! Ready to practice?';

  String get aiDefaultResponse => locale.languageCode == 'hi'
      ? 'शानदार शुरुआत! अब कुछ और अभ्यास करें।'
      : "That's a great start! Let's practice some more.";

  // ========== Progress Messages ==========
  String getProgressStart() => locale.languageCode == 'hi'
      ? 'शुरुआत हो गई है! चलिए शुरू करते हैं...'
      : 'Just getting started! Let’s go...';

  String getProgressKeepGoing() => locale.languageCode == 'hi'
      ? 'बहुत अच्छे! ऐसे ही जारी रखें।'
      : 'Great going! Keep it up.';

  String getProgressAlmostDone() => locale.languageCode == 'hi'
      ? 'लगभग हो ही गया! अंतिम कदम...'
      : 'Almost done! Final step...';

  // ========== Step Questions (Localized) ==========
  List<String> stepQuestions() => [
        locale.languageCode == 'hi'
            ? 'अभी अपने इंग्लिश सुधारने का मुख्य कारण क्या है?'
            : 'What is your main reason for improving your English right now?',
        locale.languageCode == 'hi'
            ? 'आपकी वर्तमान इंग्लिश लेवल क्या है?'
            : 'Which best describes your current English level?',
        locale.languageCode == 'hi'
            ? 'इंग्लिश सीखने में आपकी सबसे बड़ी चुनौती क्या है?'
            : 'What’s your biggest challenge in learning English so far?',
        locale.languageCode == 'hi'
            ? 'आप इंग्लिश का अभ्यास किस तरह करना पसंद करते हैं?'
            : 'How do you prefer to study or practice your English?',
        locale.languageCode == 'hi'
            ? 'प्रति दिन आप कितना समय दे सकते हैं?'
            : 'How much time can you dedicate each day to practicing?',
        locale.languageCode == 'hi'
            ? 'आप कब तक सुधार देखना चाहते हैं?'
            : 'By when do you want to see noticeable improvement?',
        locale.languageCode == 'hi'
            ? 'आप किस आयु वर्ग में हैं?'
            : 'What’s your age range?',
        locale.languageCode == 'hi'
            ? 'आपका लिंग क्या है?'
            : 'What’s your gender?',
      ];

  String getLanguageDisplayName() =>
      locale.languageCode == 'hi' ? 'हिंदी' : 'English';

  // ========== Additional or Re-Added Methods/Getters ==========

  /// For Radio Buttons in welcome_page.dart
  String get englishLanguageName => 'English';
  String get hindiLanguageName => 'हिंदी';

  /// For methods used in welcome_page.dart
  String getLocalizedWelcomeMessage(String langPref) {
    if (langPref.toLowerCase().contains('hi')) {
      return welcomeMessageHindi;
    } else {
      return welcomeMessage;
    }
  }

  String getLocalizedSubtitle(String langPref) {
    if (langPref.toLowerCase().contains('hi')) {
      return 'Real-time AI guidance के साथ English बोलना सीखें। आज से शुरू करें!';
    } else {
      return welcomeSubtitle;
    }
  }

  String getLocalizedNameFieldLabel(String langPref) {
    if (langPref.toLowerCase().contains('hi')) {
      return 'आपको क्या बुलाऊँ?';
    } else {
      return 'What can I call you?';
    }
  }

  String getPracticeLanguageMessage(String langPref) {
    if (langPref.toLowerCase().contains('hi')) {
      return hindiPracticeMessage;
    } else {
      return englishPracticeMessage;
    }
  }
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) =>
      AppLocalizations.supportedLocales.contains(locale);

  @override
  Future<AppLocalizations> load(Locale locale) async {
    Intl.defaultLocale = locale.toString();
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
