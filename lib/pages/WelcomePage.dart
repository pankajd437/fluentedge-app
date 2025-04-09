import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fluentedge_app/screens/ice_breaking_chat.dart';
import 'package:fluentedge_app/widgets/fluentedge_logo.dart';
import 'package:fluentedge_app/localization/app_localizations.dart';
import 'package:fluentedge_app/main.dart';
import 'package:fluentedge_app/services/api_service.dart';

class WelcomePage extends ConsumerStatefulWidget {
  const WelcomePage({super.key});

  @override
  ConsumerState<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends ConsumerState<WelcomePage> {
  final TextEditingController _nameController = TextEditingController();
  bool _isLoading = false;
  String _selectedLanguage = "English";

  void _handleLanguageChange(String? newValue) {
    if (newValue != null) {
      setState(() => _selectedLanguage = newValue);
      FluentEdgeApp.updateLocale(ref, Locale(newValue == "English" ? 'en' : 'hi'));
    }
  }

  void _navigateToChat() async {
    if (_nameController.text.trim().isEmpty) return;

    setState(() => _isLoading = true);
    await http.post(
      Uri.parse('${ApiService.baseUrl}/save-user-basic-info'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "name": _nameController.text.trim(),
        "language_preference": _selectedLanguage
      }),
    );

    setState(() => _isLoading = false);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => IceBreakingChatPage(
          userName: _nameController.text.trim(),
          languagePreference: _selectedLanguage,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(children: [
          const FluentEdgeLogo(),
          TextField(controller: _nameController, decoration: InputDecoration(labelText: localizations.nameFieldLabel)),
          Lottie.asset('assets/animations/mentor_welcome.json', width: 250, height: 250),
          Text(localizations.getLocalizedWelcomeMessage(''), style: const TextStyle(fontSize: 24)),
          DropdownButton<String>(
            value: _selectedLanguage,
            items: ["English", "हिंदी"].map((lang) => DropdownMenuItem(value: lang, child: Text(lang))).toList(),
            onChanged: _handleLanguageChange,
          ),
          ElevatedButton(
            onPressed: _isLoading ? null : _navigateToChat,
            child: _isLoading ? const CircularProgressIndicator() : Text(localizations.continueButton),
          ),
        ]),
      ),
    );
  }
}
