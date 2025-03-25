import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  // Supported locales
  static const List<Locale> supportedLocales = [
    Locale('en'), // English
    Locale('hi'), // Hindi
  ];

  // ========== Common Strings ==========
  String get continueButton => Intl.message(
    'Continue',
    name: 'continueButton',
    desc: 'Continue button text',
  );

  String get okButton => Intl.message(
    'OK',
    name: 'okButton',
    desc: 'OK button text',
  );

  // ========== Welcome Page Strings ==========
  String get welcomeMessage => Intl.message(
    'Hi! I\'m your AI English Mentor – let\'s make learning English simple and fun!',
    name: 'welcomeMessage',
    desc: 'Primary welcome message in English',
  );

  String get welcomeMessageHindi => Intl.message(
    'नमस्ते! मैं हूँ आपका AI इंग्लिश मेंटर – चलिए आसान और मज़ेदार तरीक़े से इंग्लिश सीखते हैं!',
    name: 'welcomeMessageHindi',
    desc: 'Welcome message in formal Hindi',
  );

  String get welcomeMessageHinglish => Intl.message(
    'Hi! Main hoon aapka AI English Mentor – chalo simple aur fun way mein English seekhte hain!',
    name: 'welcomeMessageHinglish',
    desc: 'Welcome message in Hinglish (Hindi-English mix)',
  );

  String get welcomeSubtitle => Intl.message(
    'Master English speaking with real-time AI guidance. Let\'s begin your journey today!',
    name: 'welcomeSubtitle',
    desc: 'Welcome page subtitle text',
  );

  String get nameFieldLabel => Intl.message(
    'What can I call you?',
    name: 'nameFieldLabel',
    desc: 'Label for name input field',
  );

  String get languageSelectionLabel => Intl.message(
    'Choose Language:',
    name: 'languageSelectionLabel',
    desc: 'Label for language dropdown',
  );

  String get nameRequiredError => Intl.message(
    'Please enter your name!',
    name: 'nameRequiredError',
    desc: 'Error when name field is empty',
  );

  // ========== Chat Page Strings ==========
  String get chatTitle => Intl.message(
    'Chat with {userName}',
    name: 'chatTitle',
    args: ['userName'],
    desc: 'Title for chat screen',
  );

  String get messageHint => Intl.message(
    'Type your message...',
    name: 'messageHint',
    desc: 'Hint text for message input',
  );

  String get languageInfoTitle => Intl.message(
    'Practice Language',
    name: 'languageInfoTitle',
    desc: 'Title for language info dialog',
  );

  String get englishPracticeMessage => Intl.message(
    'We\'re practicing in English mode',
    name: 'englishPracticeMessage',
    desc: 'English practice mode message',
  );

  String get hindiPracticeMessage => Intl.message(
    'हम हिंदी मोड में अभ्यास कर रहे हैं',
    name: 'hindiPracticeMessage',
    desc: 'Hindi practice mode message',
  );

  String get hinglishPracticeMessage => Intl.message(
    'Hum Hinglish mode mein practice kar rahe hain',
    name: 'hinglishPracticeMessage',
    desc: 'Hinglish practice mode message',
  );

  String get aiWelcomeResponse => Intl.message(
    'Hi {userName}! Ready to practice?',
    name: 'aiWelcomeResponse',
    args: ['userName'],
    desc: 'AI welcome response in chat',
  );

  String get aiDefaultResponse => Intl.message(
    'That\'s a great start! Let\'s practice some more.',
    name: 'aiDefaultResponse',
    desc: 'Default AI response in chat',
  );

  // ========== Language Names ==========
  String get englishLanguageName => Intl.message(
    'English',
    name: 'englishLanguageName',
    desc: 'Display name for English language',
  );

  String get hindiLanguageName => Intl.message(
    'हिंदी',
    name: 'hindiLanguageName',
    desc: 'Display name for Hindi language',
  );

  String get hinglishLanguageName => Intl.message(
    'Hinglish',
    name: 'hinglishLanguageName',
    desc: 'Display name for Hinglish language',
  );

  // ========== Helper Methods ==========
  String getLocalizedWelcomeMessage() {
    return locale.languageCode == 'hi' ? welcomeMessageHinglish : welcomeMessage;
  }

  String getLocalizedSubtitle() {
    return locale.languageCode == 'hi' 
      ? 'Real-time AI guidance ke saath English bolna seekhein. Aaj se shuru karein!'
      : welcomeSubtitle;
  }

  String getPracticeLanguageMessage(String languagePreference) {
    switch (languagePreference) {
      case 'हिंदी':
        return hindiPracticeMessage;
      case 'Hinglish':
        return hinglishPracticeMessage;
      default:
        return englishPracticeMessage;
    }
  }

  String getWelcomeResponse(String userName, String languagePreference) {
    switch (languagePreference) {
      case 'हिंदी':
        return 'नमस्ते $userName! अंग्रेज़ी का अभ्यास करने के लिए तैयार हैं?';
      case 'Hinglish':
        return 'Hi $userName! English practice ke liye taiyaar ho?';
      default:
        return aiWelcomeResponse.replaceFirst('{userName}', userName);
    }
  }

  String getAIResponse(String userName, String languagePreference) {
    switch (languagePreference) {
      case 'हिंदी':
        return 'बहुत अच्छा प्रारंभ, $userName! आइए कुछ और अभ्यास करें।';
      case 'Hinglish':
        return 'Bahut accha shuruat, $userName! Chalo kuch aur practice karein.';
      default:
        return aiDefaultResponse;
    }
  }

  // New method for getting language name from preference
  String getLanguageDisplayName(String languagePreference) {
    switch (languagePreference) {
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