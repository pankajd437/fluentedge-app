import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'ice_breaking_chat.dart';
import 'package:fluentedge_app/widgets/fluentedge_logo.dart';
import 'package:fluentedge_app/localization/app_localizations.dart';
import 'package:fluentedge_app/main.dart'; // For FluentEdgeApp.setLocale

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  final TextEditingController _nameController = TextEditingController();
  bool _isLoading = false;
  String _selectedLanguage = "English";

  @override
  void initState() {
    super.initState();
    _nameController.addListener(_validateForm);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _validateForm() {
    setState(() {});
  }

  Future<void> _saveUserBasicInfo() async {
    setState(() => _isLoading = true);
    try {
      final response = await http.post(
        Uri.parse('https://your-api.com/saveUserBasicInfo'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "name": _nameController.text.trim(),
          "language_preference": _selectedLanguage
        }),
      );

      if (response.statusCode == 200) {
        debugPrint("✅ User info saved successfully!");
      } else {
        debugPrint("❌ Failed to save user info.");
      }
    } catch (e) {
      debugPrint("Error saving user info: $e");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _handleLanguageChange(String? newValue) {
    if (newValue != null) {
      setState(() => _selectedLanguage = newValue);

      if (newValue == "हिंदी" || newValue == "Hinglish") {
        FluentEdgeApp.setLocale(context, const Locale('hi'));
      } else {
        FluentEdgeApp.setLocale(context, const Locale('en'));
      }
    }
  }

  void _navigateToChat() async {
    if (_nameController.text.trim().isEmpty) return;

    await _saveUserBasicInfo();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => IceBreakingChatPage(
          userName: _nameController.text.trim(),
          languagePreference: _selectedLanguage,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final isNameValid = _nameController.text.trim().isNotEmpty;

    return Scaffold(
      backgroundColor: const Color(0xFFF2F6FB),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    const SizedBox(height: 6),
                    const FluentEdgeLogo(),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _nameController,
                      autofocus: true,
                      decoration: InputDecoration(
                        labelText: localizations.nameFieldLabel,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        prefixIcon: const Icon(Icons.person, color: Color(0xFF0D47A1)),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Lottie.asset(
                      'assets/animations/mentor_welcome.json',
                      width: 250,
                      height: 250,
                      fit: BoxFit.cover,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      localizations.getLocalizedWelcomeMessage(),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      localizations.getLocalizedSubtitle(),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                  border: Border.all(color: Colors.blue.shade100),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.shade100.withOpacity(0.4),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          localizations.languageSelectionLabel,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(width: 10),
                        DropdownButton<String>(
                          value: _selectedLanguage,
                          underline: const SizedBox(),
                          onChanged: _handleLanguageChange,
                          items: [
                            DropdownMenuItem(
                              value: "English",
                              child: Text(localizations.englishLanguageName),
                            ),
                            DropdownMenuItem(
                              value: "हिंदी",
                              child: Text(localizations.hindiLanguageName),
                            ),
                            DropdownMenuItem(
                              value: "Hinglish",
                              child: Text(localizations.hinglishLanguageName),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: isNameValid ? _navigateToChat : null,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                          backgroundColor: isNameValid ? const Color(0xFF1565C0) : Colors.grey,
                          foregroundColor: Colors.white,
                          textStyle: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          minimumSize: const Size(0, 40),
                        ),
                        child: _isLoading
                            ? const CircularProgressIndicator(color: Colors.white)
                            : Text(localizations.continueButton),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
