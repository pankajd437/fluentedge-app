import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'ice_breaking_chat.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  String selectedLanguage = "English";
  final TextEditingController _nameController = TextEditingController();
  final FocusNode _nameFocusNode = FocusNode();

  // Localized strings
  final Map<String, Map<String, String>> _localizedStrings = {
    'English': {
      'title': "Your AI English Coach is Here! 🎙️",
      'subtitle': "Master English speaking with real-time AI guidance. Let's begin your journey today!",
      'nameHint': "What can I call you?",
      'languageLabel': "Choose Language:",
      'continueButton': "Continue",
      'nameError': "Please enter your name!",
    },
    'हिंदी': {
      'title': "आपका AI अंग्रेज़ी कोच आ गया है! 🎙️",
      'subtitle': "रीयल-टाइम AI मार्गदर्शन के साथ अंग्रेज़ी बोलना सीखें। आज से ही शुरू करें!",
      'nameHint': "मैं आपको क्या कहूँ?",
      'languageLabel': "भाषा चुनें:",
      'continueButton': "जारी रखें",
      'nameError': "कृपया अपना नाम दर्ज करें!",
    },
    'Hinglish': {
      'title': "Apka AI English Coach aa gaya hai! 🎙️",
      'subtitle': "Real-time AI guidance ke saath English bolna seekhein. Aaj se shuru karein!",
      'nameHint': "Main aapko kya bolun?",
      'languageLabel': "Bhasha chunein:",
      'continueButton': "Continue",
      'nameError': "Kripya apna naam daalein!",
    },
  };

  @override
  void dispose() {
    _nameController.dispose();
    _nameFocusNode.dispose();
    super.dispose();
  }

  String _getLocalizedString(String key) {
    return _localizedStrings[selectedLanguage]?[key] ?? _localizedStrings['English']![key]!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: SafeArea(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildHeaderSection(),
                    _buildInputSection(),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          const SizedBox(height: 40),
          Image.asset(
            'assets/images/FluentEdge Logo.png',
            width: 200,
            height: 200,
          ),
          const SizedBox(height: 20),
          Lottie.asset(
            'assets/animations/ai_mentor_welcome.json',
            width: 250,
            height: 250,
            fit: BoxFit.cover,
          ),
          const SizedBox(height: 20),
          Text(
            _getLocalizedString('title'),
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            _getLocalizedString('subtitle'),
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildInputSection() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 5,
            spreadRadius: 2,
          ),
        ],
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          TextField(
            controller: _nameController,
            focusNode: _nameFocusNode,
            decoration: InputDecoration(
              labelText: _getLocalizedString('nameHint'),
              border: const OutlineInputBorder(),
              prefixIcon: const Icon(Icons.person),
              contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
            ),
            textInputAction: TextInputAction.done,
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _getLocalizedString('languageLabel'),
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              const SizedBox(width: 10),
              DropdownButton<String>(
                value: selectedLanguage,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedLanguage = newValue!;
                  });
                },
                items: _localizedStrings.keys
                    .map<DropdownMenuItem<String>>(
                      (String value) => DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      ),
                    )
                    .toList(),
              ),
            ],
          ),
          const SizedBox(height: 15),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _handleContinue,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                backgroundColor: Colors.blueAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                _getLocalizedString('continueButton'),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handleContinue() {
    if (_nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_getLocalizedString('nameError'))),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => IceBreakingChat(
            userName: _nameController.text,
            selectedLanguage: selectedLanguage,
          ),
        ),
      );
    }
  }
}