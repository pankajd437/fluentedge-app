import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:fluentedge_app/localization/app_localizations.dart';
import 'package:fluentedge_app/main.dart';
import 'package:go_router/go_router.dart';

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
    final isHindi = selectedLanguage == "हिंदी";

    return Scaffold(
      backgroundColor: const Color(0xFFF2F6FB),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildHeader(localizations, isHindi),
                    _buildForm(localizations),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader(AppLocalizations localizations, bool isHindi) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      child: Column(
        children: [
          Hero(
            tag: "fluentedge-logo",
            child: Image.asset(
              'assets/images/FluentEdge Logo.png',
              width: 160,
              height: 160,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(height: 2),
          Lottie.asset(
            'assets/animations/ai_mentor_welcome.json',
            width: 230,
            height: 210,
            errorBuilder: (_, __, ___) =>
                const Icon(Icons.animation, size: 100, color: Colors.grey),
          ),
          const SizedBox(height: 8),
          Text(
            isHindi ? localizations.welcomeMessageHindi : localizations.welcomeMessage,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Color(0xFF0D47A1),
              fontFamily: 'Poppins',
              height: 1.4,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            isHindi
                ? "Real-time AI guidance के साथ English बोलना सीखें। आज से शुरू करें!"
                : localizations.welcomeSubtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.black54,
              fontFamily: 'Poppins',
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildForm(AppLocalizations localizations) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.blueAccent,
            blurRadius: 6,
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
            decoration: InputDecoration(
              labelText:
                  localizations.getLocalizedNameFieldLabel(selectedLanguage),
              prefixIcon: const Icon(Icons.person),
              border: const OutlineInputBorder(),
              contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
            ),
            textInputAction: TextInputAction.done,
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                localizations.languageSelectionLabel,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 10),
              DropdownButton<String>(
                value: selectedLanguage,
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      selectedLanguage = value;
                      FluentEdgeApp.updateLocale(
                        ref,
                        value == "हिंदी" ? const Locale('hi') : const Locale('en'),
                      );
                    });
                  }
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
            ],
          ),
          const SizedBox(height: 24),

          // 🔵 Continue with Registration
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.person_add),
              onPressed: () => _continueWithRegistration(),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1565C0),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              label: Text(
                localizations.continueButton,
                style: const TextStyle(color: Colors.white, fontSize: 14),
              ),
            ),
          ),

          const SizedBox(height: 12),

          // ⚪ Explore as Guest
          TextButton(
            onPressed: () => _continueAsGuest(context),
            child: const Text(
              "Explore as Guest",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _continueWithRegistration() {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.nameRequiredError),
        ),
      );
      return;
    }
    widget.onUserInfoSubmitted(name, selectedLanguage);
  }

  void _continueAsGuest(BuildContext context) {
    final guestName = _nameController.text.trim().isNotEmpty
        ? _nameController.text.trim()
        : "Guest";

    ref.read
