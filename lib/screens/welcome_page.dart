import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:fluentedge_app/localization/app_localizations.dart';
import '../main.dart';

class WelcomePage extends StatefulWidget {
  final Function(String, String) onUserInfoSubmitted;

  const WelcomePage({
    super.key,
    required this.onUserInfoSubmitted,
  });

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  String selectedLanguage = "English";
  final TextEditingController _nameController = TextEditingController();
  final FocusNode _nameFocusNode = FocusNode();

  @override
  void dispose() {
    _nameController.dispose();
    _nameFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: SafeArea(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildHeaderSection(localizations),
                    _buildInputSection(localizations),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeaderSection(AppLocalizations localizations) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          const SizedBox(height: 20),
          Image.asset(
            'assets/images/FluentEdge Logo.png',
            width: 200,
            height: 200,
          ),
          const SizedBox(height: 5),
          Lottie.asset(
            'assets/animations/ai_mentor_welcome.json',
            width: 250,
            height: 250,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return const Icon(Icons.animation, size: 100, color: Colors.grey);
            },
          ),
          const SizedBox(height: 15),
          Text(
            localizations.getLocalizedWelcomeMessage(selectedLanguage),
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            localizations.getLocalizedSubtitle(selectedLanguage),
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildInputSection(AppLocalizations localizations) {
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
            autofocus: true,
            decoration: InputDecoration(
              labelText: localizations.getLocalizedNameFieldLabel(selectedLanguage),
              border: const OutlineInputBorder(),
              prefixIcon: const Icon(Icons.person),
              contentPadding: const EdgeInsets.symmetric(
                vertical: 15,
                horizontal: 15,
              ),
            ),
            textInputAction: TextInputAction.done,
          ),
          const SizedBox(height: 15),
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
              DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: selectedLanguage,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedLanguage = newValue!;
                      if (newValue == "हिंदी") {
                        FluentEdgeApp.setLocale(context, const Locale('hi'));
                      } else {
                        FluentEdgeApp.setLocale(context, const Locale('en'));
                      }
                    });
                  },
                  items: [
                    DropdownMenuItem(
                      value: "English",
                      child: Text(localizations.englishLanguageName),
                    ),
                    DropdownMenuItem(
                      value: "हिंदी",
                      child: Text(localizations.hindiLanguageName),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => _handleContinue(context),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                localizations.continueButton,
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

  void _handleContinue(BuildContext context) {
    final trimmedName = _nameController.text.trim();
    if (trimmedName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.nameRequiredError),
        ),
      );
    } else {
      widget.onUserInfoSubmitted(trimmedName, selectedLanguage);
    }
  }
}
