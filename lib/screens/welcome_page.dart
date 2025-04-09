import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:fluentedge_app/localization/app_localizations.dart';
import 'package:fluentedge_app/main.dart';

class WelcomePage extends ConsumerStatefulWidget {
  final Function(String, String) onUserInfoSubmitted;

  const WelcomePage({
    super.key,
    required this.onUserInfoSubmitted,
  });

  @override
  ConsumerState<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends ConsumerState<WelcomePage> {
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
      backgroundColor: const Color(0xFFF2F6FB),
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
          const SizedBox(height: 10), // reduced
          Image.asset(
            'assets/images/FluentEdge Logo.png',
            width: 160, // reduced
            height: 160,
          ),
          const SizedBox(height: 2), // reduced
          Lottie.asset(
            'assets/animations/ai_mentor_welcome.json',
            width: 230, // slightly smaller
            height: 220, // reduced
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return const Icon(Icons.animation, size: 100, color: Colors.grey);
            },
          ),
          const SizedBox(height: 12), // reduced
          Text(
            localizations.getLocalizedWelcomeMessage(selectedLanguage),
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              fontFamily: 'Poppins',
              color: Color(0xFF0D47A1),
            ),
          ),
          const SizedBox(height: 8), // reduced
          Text(
            localizations.getLocalizedSubtitle(selectedLanguage),
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              fontFamily: 'Poppins',
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 20), // reduced
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
            color: Colors.blueAccent,
            blurRadius: 6,
            spreadRadius: 1,
            offset: Offset(0, -1),
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
              labelStyle: const TextStyle(
                fontWeight: FontWeight.w500,
                fontFamily: 'Poppins',
              ),
              border: const OutlineInputBorder(),
              prefixIcon: const Icon(Icons.person, color: Color(0xFF0D47A1)),
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
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Poppins',
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
                        FluentEdgeApp.updateLocale(ref, const Locale('hi'));
                      } else {
                        FluentEdgeApp.updateLocale(ref, const Locale('en'));
                      }
                    });
                  },
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Poppins',
                    color: Colors.black,
                  ),
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
                backgroundColor: const Color(0xFF1565C0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                localizations.continueButton,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Poppins',
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
