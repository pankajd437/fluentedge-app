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

  // ========== Welcome Page ==========
  String get welcomeMessage => Intl.message(
        "Hi! I'm your AI English Mentor – let’s make learning English simple and fun!",
        name: 'welcomeMessage',
      );

  String get welcomeMessageHindi => Intl.message(
        'नमस्ते! मैं हूँ आपका AI इंग्लिश मेंटर – चलिए आसान और मज़ेदार तरीक़े से इंग्लिश सीखते हैं!',
        name: 'welcomeMessageHindi',
      );

  String get welcomeMessageHinglish => Intl.message(
        'Hi! Main hoon aapka AI English Mentor – chalo simple aur fun way mein English seekhte hain!',
        name: 'welcomeMessageHinglish',
      );

  String get welcomeSubtitle => Intl.message(
        "Master English speaking with real-time AI guidance. Let's begin your journey today!",
        name: 'welcomeSubtitle',
      );

  String get nameFieldLabel => Intl.message('What can I call you?', name: 'nameFieldLabel');
  String get languageSelectionLabel => Intl.message('Choose Language:', name: 'languageSelectionLabel');
  String get nameRequiredError => Intl.message('Please enter your name!', name: 'nameRequiredError');

  // ========== Chat Page ==========
  String chatTitle(String userName) => Intl.message(
        'Chat with $userName',
        name: 'chatTitle',
        args: [userName],
      );

  String get messageHint => Intl.message('Type your message...', name: 'messageHint');
  String get languageInfoTitle => Intl.message('Practice Language', name: 'languageInfoTitle');

  String get englishPracticeMessage => Intl.message("We're practicing in English mode", name: 'englishPracticeMessage');
  String get hindiPracticeMessage => Intl.message('हम हिंदी मोड में अभ्यास कर रहे हैं', name: 'hindiPracticeMessage');
  String get hinglishPracticeMessage => Intl.message('Hum Hinglish mode mein practice kar rahe hain', name: 'hinglishPracticeMessage');

  String aiWelcomeResponse(String userName) => Intl.message(
        'Hi $userName! Ready to practice?',
        name: 'aiWelcomeResponse',
        args: [userName],
      );

  String get aiDefaultResponse => Intl.message("That's a great start! Let's practice some more.", name: 'aiDefaultResponse');

  // ========== Language Names ==========
  String get englishLanguageName => Intl.message('English', name: 'englishLanguageName');
  String get hindiLanguageName => Intl.message('हिंदी', name: 'hindiLanguageName');
  String get hinglishLanguageName => Intl.message('Hinglish', name: 'hinglishLanguageName');

  // ========== Questionnaire Step Labels ==========
  String get step1Question => Intl.message("Why do you want to learn English?", name: 'step1Question');
  String get step2Question => Intl.message("What's your current English level?", name: 'step2Question');
  String get step3Question => Intl.message("How do you prefer to learn?", name: 'step3Question');
  String get step4Question => Intl.message("What's your biggest challenge in English?", name: 'step4Question');
  String get step5Question => Intl.message("How much time can you give daily?", name: 'step5Question');
  String get step6Question => Intl.message("When do you want to become fluent?", name: 'step6Question');

  // ========== Helper to decide preferred language ==========
  String _getLangPref(String? langPref) {
    if (langPref == 'हिंदी') return 'hi';
    if (langPref == 'Hinglish') return 'hinglish';
    return 'en';
  }

  // ========== Localized Questions ==========
  String getStep1Question(String langPref) {
    switch (_getLangPref(langPref)) {
      case 'hi':
        return 'आप अंग्रेज़ी क्यों सीखना चाहते हैं?';
      case 'hinglish':
        return 'Aap English kyu seekhna chahte ho?';
      default:
        return step1Question;
    }
  }

  String getStep2Question(String langPref) {
    switch (_getLangPref(langPref)) {
      case 'hi':
        return 'आपकी वर्तमान अंग्रेज़ी स्तर क्या है?';
      case 'hinglish':
        return 'Aapka current English level kya hai?';
      default:
        return step2Question;
    }
  }

  String getStep3Question(String langPref) {
    switch (_getLangPref(langPref)) {
      case 'hi':
        return 'आप किस तरीके से सीखना पसंद करते हैं?';
      case 'hinglish':
        return 'Aap kaise seekhna pasand karte ho?';
      default:
        return step3Question;
    }
  }

  String getStep4Question(String langPref) {
    switch (_getLangPref(langPref)) {
      case 'hi':
        return 'अंग्रेज़ी में आपकी सबसे बड़ी चुनौती क्या है?';
      case 'hinglish':
        return 'English mein aapki biggest challenge kya hai?';
      default:
        return step4Question;
    }
  }

  String getStep5Question(String langPref) {
    switch (_getLangPref(langPref)) {
      case 'hi':
        return 'आप प्रतिदिन कितना समय दे सकते हैं?';
      case 'hinglish':
        return 'Daily kitna time de sakte ho?';
      default:
        return step5Question;
    }
  }

  String getStep6Question(String langPref) {
    switch (_getLangPref(langPref)) {
      case 'hi':
        return 'आप कब तक fluent बनना चाहते हैं?';
      case 'hinglish':
        return 'Aap kab tak fluent banna chahte ho?';
      default:
        return step6Question;
    }
  }

  // ========== Localized Welcome ==========
  String getLocalizedWelcomeMessage(String langPref) {
    switch (_getLangPref(langPref)) {
      case 'hi':
        return welcomeMessageHindi;
      case 'hinglish':
        return welcomeMessageHinglish;
      default:
        return welcomeMessage;
    }
  }

  String getLocalizedSubtitle(String langPref) {
    switch (_getLangPref(langPref)) {
      case 'hi':
        return 'Real-time AI guidance के साथ English बोलना सीखें। आज से शुरू करें!';
      case 'hinglish':
        return 'Real-time AI ke saath English bolna seekho. Aaj se shuru karo!';
      default:
        return welcomeSubtitle;
    }
  }

  // ========== Dynamic Practice Message ==========
  String getPracticeLanguageMessage(String langPref) {
    switch (langPref) {
      case 'हिंदी':
        return hindiPracticeMessage;
      case 'Hinglish':
        return hinglishPracticeMessage;
      default:
        return englishPracticeMessage;
    }
  }

  String getWelcomeResponse(String userName, String langPref) {
    switch (langPref) {
      case 'हिंदी':
        return 'नमस्ते $userName! अंग्रेज़ी का अभ्यास करने के लिए तैयार हैं?';
      case 'Hinglish':
        return 'Hi $userName! English practice ke liye taiyaar ho?';
      default:
        return aiWelcomeResponse(userName);
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

    final hinglishReplies = [
      'Great job $userName! Ab ek aur sentence try karo.',
      'Wah! Chalo next level ki practice karte hain.',
      'Nice effort! Thoda aur bolke dekho.',
    ];

    switch (langPref) {
      case 'हिंदी':
        return hindiReplies[random.nextInt(hindiReplies.length)];
      case 'Hinglish':
        return hinglishReplies[random.nextInt(hinglishReplies.length)];
      default:
        return englishReplies[random.nextInt(englishReplies.length)];
    }
  }

  String getLanguageDisplayName(String langPref) {
    switch (langPref) {
      case 'हिंदी':
        return hindiLanguageName;
      case 'Hinglish':
        return hinglishLanguageName;
      default:
        return englishLanguageName;
    }
  }

  // ========== Localized Options ==========
  List<String> getMotivationOptions(String lang) {
    switch (lang) {
      case 'हिंदी':
        return ['नौकरी इंटरव्यू', 'कैरियर ग्रोथ', 'विदेश में पढ़ाई', 'यात्रा', 'आत्मविश्वास बढ़ाना', 'पब्लिक स्पीकिंग', 'प्रतियोगी परीक्षा', 'दैनिक बातचीत', 'अन्य'];
      case 'Hinglish':
        return ['Job interview ke liye', 'Career grow karne ke liye', 'Abroad study ke liye', 'Travel ke liye', 'Confidence build karne ke liye', 'Public speaking improve karne ke liye', 'Competitive exams ke liye', 'Daily baatcheet improve karne ke liye', 'Kuch aur reason'];
      default:
        return ['Job Interviews', 'Career Growth', 'Study Abroad', 'Travel', 'Confidence Building', 'Public Speaking', 'Competitive Exams', 'Daily Conversations', 'Others'];
    }
  }

  List<String> getEnglishLevelOptions(String lang) {
    switch (lang) {
      case 'हिंदी':
        return ['शुरुआती', 'मध्यम', 'उन्नत'];
      case 'Hinglish':
        return ['Beginner', 'Intermediate', 'Advanced'];
      default:
        return ['Beginner', 'Intermediate', 'Advanced'];
    }
  }

  List<String> getLearningStyleOptions(String lang) {
    switch (lang) {
      case 'हिंदी':
        return ['वीडियो क्लास', 'चैट से सीखना', 'प्रैक्टिस टेस्ट', 'डेली टिप्स'];
      case 'Hinglish':
        return ['Video lessons', 'Chat se seekhna', 'Practice tests', 'Daily tips & tricks'];
      default:
        return ['Video Lessons', 'Chat-based Learning', 'Practice Tests', 'Daily Tips & Tricks'];
    }
  }

  List<String> getDifficultyOptions(String lang) {
    switch (lang) {
      case 'हिंदी':
        return ['स्पीकिंग में कठिनाई', 'ग्रामर समझना', 'शब्द याद रखना', 'लिखना सुधारना'];
      case 'Hinglish':
        return ['Speaking fluently', 'Grammar samajhna', 'Vocabulary yaad rakhna', 'Writing improve karna'];
      default:
        return ['Speaking Fluently', 'Understanding Grammar', 'Remembering Vocabulary', 'Writing Clearly'];
    }
  }

  List<String> getTimeOptions(String lang) {
    switch (lang) {
      case 'हिंदी':
        return ['15 मिनट से कम', '15–30 मिनट', '30–60 मिनट', '1 घंटा से ज़्यादा'];
      case 'Hinglish':
        return ['< 15 mins', '15–30 mins', '30–60 mins', 'More than 1 hour'];
      default:
        return ['< 15 mins', '15–30 mins', '30–60 mins', 'More than 1 hour'];
    }
  }

  List<String> getTimelineOptions(String lang) {
    switch (lang) {
      case 'हिंदी':
        return ['1 महीने में', '1–3 महीने', '3–6 महीने', '6 महीने से अधिक'];
      case 'Hinglish':
        return ['1 month', '1–3 months', '3–6 months', '6+ months'];
      default:
        return ['Within 1 month', '1–3 months', '3–6 months', 'More than 6 months'];
    }
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
