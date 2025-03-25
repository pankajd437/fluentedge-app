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

  // Supported locales
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

  String get englishPracticeMessage => Intl.message(
    "We're practicing in English mode",
    name: 'englishPracticeMessage',
  );

  String get hindiPracticeMessage => Intl.message(
    'हम हिंदी मोड में अभ्यास कर रहे हैं',
    name: 'hindiPracticeMessage',
  );

  String get hinglishPracticeMessage => Intl.message(
    'Hum Hinglish mode mein practice kar rahe hain',
    name: 'hinglishPracticeMessage',
  );

  String aiWelcomeResponse(String userName) => Intl.message(
    'Hi $userName! Ready to practice?',
    name: 'aiWelcomeResponse',
    args: [userName],
  );

  String get aiDefaultResponse => Intl.message(
    "That's a great start! Let's practice some more.",
    name: 'aiDefaultResponse',
  );

  // ========== Language Names ==========
  String get englishLanguageName => Intl.message('English', name: 'englishLanguageName');
  String get hindiLanguageName => Intl.message('हिंदी', name: 'hindiLanguageName');
  String get hinglishLanguageName => Intl.message('Hinglish', name: 'hinglishLanguageName');

  // ========== Dynamic Welcome ==========
  String getLocalizedWelcomeMessage() {
    switch (locale.languageCode) {
      case 'hi':
        return welcomeMessageHindi;
      default:
        return welcomeMessage;
    }
  }

  String getLocalizedSubtitle() {
    switch (locale.languageCode) {
      case 'hi':
        return 'Real-time AI guidance ke saath English bolna seekhein. Aaj se shuru karein!';
      default:
        return welcomeSubtitle;
    }
  }

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
