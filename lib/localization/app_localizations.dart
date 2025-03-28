import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:math';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  static const List<Locale> supportedLocales = [
    Locale('en'),
    Locale('hi'),
  ];

  // ========== Common ==========
  String get continueButton => Intl.message('Continue', name: 'continueButton');
  String get okButton => Intl.message('OK', name: 'okButton');

  // ========== Added for CourseListPage Fix ==========
  String get coursesListTitle => locale.languageCode == 'hi'
      ? 'आपके पर्सनलाइज़्ड कोर्स'
      : 'Your Personalized Courses';

  String get resumeQuestionnaire => locale.languageCode == 'hi'
      ? 'शुरुआती प्रश्नावली फिर से शुरू करें →'
      : 'Resume Questionnaire →';

  String get startNow => locale.languageCode == 'hi'
      ? 'अभी शुरू करें'
      : 'Start Now';

  // ========== Welcome Page ==========
  String get welcomeMessage => "Hi! I'm your AI English Mentor – let’s make learning English simple and fun!";
  String get welcomeMessageHindi => 'नमस्ते! मैं हूँ आपका AI इंग्लिश मेंटर – चलिए आसान और मज़ेदार तरीक़े से इंग्लिश सीखते हैं!';

  String get welcomeSubtitle => "Master English speaking with real-time AI guidance. Let's begin your journey today!";
  String get nameFieldLabel => 'What can I call you?';
  String get languageSelectionLabel => 'Choose Language:';
  String get nameRequiredError => 'Please enter your name!';

  String getLocalizedNameFieldLabel(String langPref) {
    switch (_getLangPref(langPref)) {
      case 'hi': return 'आपको क्या बुलाऊँ?';
      default: return nameFieldLabel;
    }
  }

  // ========== Chat Page ==========
  String chatTitle(String userName) => 'Chat with $userName';

  String get messageHint => 'Type your message...';
  String get languageInfoTitle => 'Practice Language';

  String get englishPracticeMessage => "We're practicing in English mode";
  String get hindiPracticeMessage => 'हम हिंदी मोड में अभ्यास कर रहे हैं';

  String aiWelcomeResponse(String userName) => 'Hi $userName! Ready to practice?';
  String get aiDefaultResponse => "That's a great start! Let's practice some more.";

  // ========== Language Names ==========
  String get englishLanguageName => 'English';
  String get hindiLanguageName => 'हिंदी';

  // ========== Questionnaire Questions ==========
  String get step1Question => "Why do you want to learn English?";
  String get step2Question => "What's your current English level?";
  String get step3Question => "How do you prefer to learn?";
  String get step4Question => "What's your biggest challenge in English?";
  String get step5Question => "How much time can you give daily?";
  String get step6Question => "When do you want to become fluent?";
  String get step7Question => "What's your age group?";
  String get step8Question => "What's your gender?";

  // ========== Progress Messages ==========
  String getProgressStart() {
    switch (locale.languageCode) {
      case 'hi': return 'शुरुआत हो गई है! चलिए शुरू करते हैं...';
      default: return 'Just getting started! Let’s go...';
    }
  }

  String getProgressKeepGoing() {
    switch (locale.languageCode) {
      case 'hi': return 'बहुत अच्छे! ऐसे ही जारी रखें।';
      default: return 'Great going! Keep it up.';
    }
  }

  String getProgressAlmostDone() {
    switch (locale.languageCode) {
      case 'hi': return 'लगभग हो ही गया! अंतिम कदम...';
      default: return 'Almost done! Final step...';
    }
  }

  // ========== Localized Welcome Message ==========
  String getLocalizedWelcomeMessage(String langPref) {
    switch (_getLangPref(langPref)) {
      case 'hi': return welcomeMessageHindi;
      default: return welcomeMessage;
    }
  }

  String getLocalizedSubtitle(String langPref) {
    switch (_getLangPref(langPref)) {
      case 'hi': return 'Real-time AI guidance के साथ English बोलना सीखें। आज से शुरू करें!';
      default: return welcomeSubtitle;
    }
  }

  // ========== Public Question Accessors ==========
  String getStep1Question(String langPref) => getStep1QuestionLocalized(langPref);
  String getStep2Question(String langPref) => getStep2QuestionLocalized(langPref);
  String getStep3Question(String langPref) => getStep3QuestionLocalized(langPref);
  String getStep4Question(String langPref) => getStep4QuestionLocalized(langPref);
  String getStep5Question(String langPref) => getStep5QuestionLocalized(langPref);
  String getStep6Question(String langPref) => getStep6QuestionLocalized(langPref);
  String getStep7Question(String langPref) => getStep7QuestionLocalized(langPref);
  String getStep8Question(String langPref) => getStep8QuestionLocalized(langPref);

  // ========== Localized Question Handlers ==========
  String getStep1QuestionLocalized(String langPref) {
    switch (_getLangPref(langPref)) {
      case 'hi': return 'आप अंग्रेज़ी क्यों सीखना चाहते हैं?';
      default: return step1Question;
    }
  }

  String getStep2QuestionLocalized(String langPref) {
    switch (_getLangPref(langPref)) {
      case 'hi': return 'आपकी वर्तमान अंग्रेज़ी स्तर क्या है?';
      default: return step2Question;
    }
  }

  String getStep3QuestionLocalized(String langPref) {
    switch (_getLangPref(langPref)) {
      case 'hi': return 'आप किस तरीके से सीखना पसंद करते हैं?';
      default: return step3Question;
    }
  }

  String getStep4QuestionLocalized(String langPref) {
    switch (_getLangPref(langPref)) {
      case 'hi': return 'अंग्रेज़ी में आपकी सबसे बड़ी चुनौती क्या है?';
      default: return step4Question;
    }
  }

  String getStep5QuestionLocalized(String langPref) {
    switch (_getLangPref(langPref)) {
      case 'hi': return 'आप प्रतिदिन कितना समय दे सकते हैं?';
      default: return step5Question;
    }
  }

  String getStep6QuestionLocalized(String langPref) {
    switch (_getLangPref(langPref)) {
      case 'hi': return 'आप कब तक fluent बनना चाहते हैं?';
      default: return step6Question;
    }
  }

  String getStep7QuestionLocalized(String langPref) {
    switch (_getLangPref(langPref)) {
      case 'hi': return 'आपकी उम्र क्या है?';
      default: return step7Question;
    }
  }

  String getStep8QuestionLocalized(String langPref) {
    switch (_getLangPref(langPref)) {
      case 'hi': return 'आपका लिंग क्या है?';
      default: return step8Question;
    }
  }

  // ========== Option Accessors ==========
  List<String> getMotivationOptions(String lang) {
    switch (_getLangPref(lang)) {
      case 'hi':
        return ['नौकरी इंटरव्यू', 'कैरियर ग्रोथ', 'विदेश में पढ़ाई', 'यात्रा', 'आत्मविश्वास बढ़ाना', 'पब्लिक स्पीकिंग', 'प्रतियोगी परीक्षा', 'दैनिक बातचीत', 'अन्य'];
      default:
        return ['Job Interviews', 'Career Growth', 'Study Abroad', 'Travel', 'Confidence Building', 'Public Speaking', 'Competitive Exams', 'Daily Conversations', 'Others'];
    }
  }

  List<String> getEnglishLevelOptions(String lang) {
    switch (_getLangPref(lang)) {
      case 'hi': return ['शुरुआती', 'मध्यम', 'उन्नत'];
      default: return ['Beginner', 'Intermediate', 'Advanced'];
    }
  }

  List<String> getLearningStyleOptions(String lang) {
    switch (_getLangPref(lang)) {
      case 'hi': return ['वीडियो क्लास', 'चैट से सीखना', 'प्रैक्टिस टेस्ट', 'डेली टिप्स'];
      default: return ['Video Lessons', 'Chat-based Learning', 'Practice Tests', 'Daily Tips & Tricks'];
    }
  }

  List<String> getDifficultyOptions(String lang) {
    switch (_getLangPref(lang)) {
      case 'hi': return ['स्पीकिंग में कठिनाई', 'ग्रामर समझना', 'शब्द याद रखना', 'लिखना सुधारना'];
      default: return ['Speaking Fluently', 'Understanding Grammar', 'Remembering Vocabulary', 'Writing Clearly'];
    }
  }

  List<String> getTimeOptions(String lang) {
    switch (_getLangPref(lang)) {
      case 'hi': return ['15 मिनट से कम', '15–30 मिनट', '30–60 मिनट', '1 घंटा से ज़्यादा'];
      default: return ['< 15 mins', '15–30 mins', '30–60 mins', 'More than 1 hour'];
    }
  }

  List<String> getTimelineOptions(String lang) {
    switch (_getLangPref(lang)) {
      case 'hi': return ['1 महीने में', '1–3 महीने', '3–6 महीने', '6 महीने से अधिक'];
      default: return ['Within 1 month', '1–3 months', '3–6 months', 'More than 6 months'];
    }
  }

  // ========== Dynamic & AI Messages ==========
  String getPracticeLanguageMessage(String langPref) {
    switch (_getLangPref(langPref)) {
      case 'hi': return hindiPracticeMessage;
      default: return englishPracticeMessage;
    }
  }

  String getWelcomeResponse(String userName, String langPref) {
    switch (_getLangPref(langPref)) {
      case 'hi': return 'नमस्ते $userName! अंग्रेज़ी का अभ्यास करने के लिए तैयार हैं?';
      default: return aiWelcomeResponse(userName);
    }
  }

  String getAIResponse(String userName, String langPref) {
    final random = Random();
    final englishReplies = [
      "That's a great start! Let's practice some more.",
      "Well done! Can you try saying that differently?",
      "Nice! Now let’s add more vocabulary.",
    ];
    final hindiReplies = [
      'बहुत बढ़िया $userName! अब कुछ और अभ्यास करें।',
      'शानदार! अब एक और कोशिश करें।',
      'अच्छा किया! अब एक नया वाक्य बोलें।',
    ];

    switch (_getLangPref(langPref)) {
      case 'hi': return hindiReplies[random.nextInt(hindiReplies.length)];
      default: return englishReplies[random.nextInt(englishReplies.length)];
    }
  }

  String getLanguageDisplayName(String langPref) {
    switch (_getLangPref(langPref)) {
      case 'hi': return hindiLanguageName;
      default: return englishLanguageName;
    }
  }

  String _getLangPref(String? langPref) {
    if (langPref == 'हिंदी') return 'hi';
    return 'en';
  }
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => AppLocalizations.supportedLocales.contains(locale);

  @override
  Future<AppLocalizations> load(Locale locale) async {
    Intl.defaultLocale = locale.toString();
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
