import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'ice_breaking_chat.dart';
import 'package:fluentedge_frontend/widgets/fluentedge_logo.dart';
import 'package:fluentedge_frontend/localization/app_localizations.dart';

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
        AppLocalizations.of(context)!.locale = const Locale('hi');
      } else {
        AppLocalizations.of(context)!.locale = const Locale('en');
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
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Header Section
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    const FluentEdgeLogo(),
                    const SizedBox(height: 20),
                    
                    // Name Input Field
                    TextField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: localizations.nameFieldLabel,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        prefixIcon: const Icon(Icons.person, color: Colors.blueAccent),
                      ),
                    ),
                    const SizedBox(height: 20),
                    
                    // Animation
                    Lottie.asset(
                      'assets/animations/mentor_welcome.json',
                      width: 250,
                      height: 250,
                      fit: BoxFit.cover,
                    ),
                    const SizedBox(height: 20),
                    
                    // Greeting
                    Text(
                      localizations.getLocalizedWelcomeMessage(),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 10),
                    
                    // Subtitle
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
              
              // Footer Section
              Container(
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
                    // Language Selection
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
                    
                    // Continue Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: isNameValid ? _navigateToChat : null,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          backgroundColor: isNameValid 
                              ? Colors.blueAccent 
                              : Colors.grey,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
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