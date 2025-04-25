import 'package:fluentedge_app/main.dart'; // ✅ needed for languagePrefProvider
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

import 'package:fluentedge_app/constants.dart';
import 'package:fluentedge_app/localization/app_localizations.dart';
import 'package:fluentedge_app/services/api_service.dart';

import 'dart:async';

class RegistrationPage extends ConsumerStatefulWidget {
  /// Accepts a prefilled name from outside, e.g. from the welcome flow
  final String? prefilledName;

  const RegistrationPage({
    Key? key,
    this.prefilledName,
  }) : super(key: key);

  @override
  ConsumerState<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends ConsumerState<RegistrationPage>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();

  String _userName = '';
  String _email = '';
  String _age = '';
  String? _gender;
  String? _learningGoal;
  bool _isLoading = false;

  // Mentor image is now "mentor_analytical_upper.png"
  String _mentorAsset = 'assets/images/mentor_expressions/mentor_analytical_upper.png';

  // For the thumbs-up overlay after submission
  OverlayEntry? _thumbsUpOverlay;

  // For a small fade+zoom animation on the container
  late AnimationController _containerController;
  late Animation<double> _fadeAnim;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _userName = widget.prefilledName ?? '';

    // Simple container animation
    _containerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnim = Tween<double>(begin: 0, end: 1).animate(_containerController);
    _scaleAnim = Tween<double>(begin: 0.95, end: 1).animate(
      CurvedAnimation(
        parent: _containerController,
        curve: Curves.easeOut,
      ),
    );

    // Start the container animation
    _containerController.forward();
  }

  @override
  void dispose() {
    _containerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final currentLang = ref.watch(languagePrefProvider);

    // Dynamically choose Hindi vs English for the dropdown items:
    final bool isHindi = currentLang == 'हिंदी';

    // Localized "Learning Goal" options:
    final List<String> learningGoals = isHindi
        ? [
            'बोलने की प्रवाह में सुधार करें',
            'साक्षात्कार की तैयारी करें',
            'आत्मविश्वास बढ़ाएं',
            'शून्य से सीखें',
            'यात्रा के दौरान संचार',
            'पेशेवर अंग्रेजी',
          ]
        : [
            'Improve Speaking Fluency',
            'Prepare for Interviews',
            'Build Confidence',
            'Learn from Zero',
            'Travel Communication',
            'Professional English',
          ];

    // Localized "Gender" options:
    final List<String> genderOptions = isHindi
        ? [
            'पुरुष',
            'महिला',
            'अन्य',
          ]
        : [
            'Male',
            'Female',
            'Other',
          ];

    return Scaffold(
      body: Container(
        // Stronger gradient for a more colorful look
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFE1F5FE), Color(0xFFBBDEFB)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(kPagePadding),
            child: Column(
              children: [
                // Title row
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      localizations.registrationTitle,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: kSpacingMedium),

                // Mentor image, bigger
                Image.asset(
                  _mentorAsset,
                  width: 180,
                  height: 180,
                ),
                const SizedBox(height: kSpacingMedium),

                Text(
                  localizations.registrationSubtitle,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.blueGrey.shade700,
                  ),
                ),
                const SizedBox(height: kSpacingLarge),

                // Animated container form
                FadeTransition(
                  opacity: _fadeAnim,
                  child: ScaleTransition(
                    scale: _scaleAnim,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 24,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            // Name field
                            _buildInputField(
                              label: localizations.nameLabel,
                              hint: localizations.nameHint,
                              initialValue: _userName,
                              onSaved: (value) => _userName = value!.trim(),
                              validator: (value) =>
                                  (value == null || value.trim().isEmpty)
                                      ? localizations.nameRequiredError
                                      : null,
                            ),
                            const SizedBox(height: kSpacingMedium),

                            // Email field
                            _buildInputField(
                              label: localizations.emailLabel,
                              hint: localizations.emailHint,
                              keyboardType: TextInputType.emailAddress,
                              onSaved: (value) => _email = value!.trim(),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return localizations.emailRequiredError;
                                }
                                if (!value.contains('@')) {
                                  return localizations.invalidEmailError;
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: kSpacingMedium),

                            // Age field
                            _buildInputField(
                              label: localizations.ageLabel,
                              hint: localizations.ageHint,
                              keyboardType: TextInputType.number,
                              onSaved: (value) => _age = value!,
                              validator: (value) {
                                final age = int.tryParse(value ?? '');
                                if (age == null || age <= 0) {
                                  return localizations.invalidAgeError;
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: kSpacingMedium),

                            // Gender dropdown
                            DropdownButtonFormField<String>(
                              decoration: InputDecoration(
                                labelText: localizations.genderLabel,
                                border: const OutlineInputBorder(),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 14,
                                ),
                              ),
                              items: genderOptions
                                  .map((g) => DropdownMenuItem<String>(
                                        value: g,
                                        child: Text(g),
                                      ))
                                  .toList(),
                              value: _gender,
                              onChanged: (value) => setState(() {
                                _gender = value;
                              }),
                              validator: (value) => (value == null || value.trim().isEmpty)
                                  ? localizations.genderRequiredError
                                  : null,
                              onSaved: (value) => _gender = value,
                            ),
                            const SizedBox(height: kSpacingMedium),

                            // Learning goal dropdown
                            DropdownButtonFormField<String>(
                              decoration: InputDecoration(
                                labelText: localizations.goalLabel,
                                border: const OutlineInputBorder(),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 14,
                                ),
                              ),
                              items: learningGoals
                                  .map((goal) => DropdownMenuItem<String>(
                                        value: goal,
                                        child: Text(goal),
                                      ))
                                  .toList(),
                              value: _learningGoal,
                              onChanged: (value) => setState(() {
                                _learningGoal = value;
                              }),
                              validator: (value) => (value == null || value.isEmpty)
                                  ? localizations.goalRequiredError
                                  : null,
                              onSaved: (value) => _learningGoal = value,
                            ),
                            const SizedBox(height: kSpacingLarge),

                            // Submit button or spinner
                            _isLoading
                                ? const CircularProgressIndicator()
                                : ElevatedButton.icon(
                                    onPressed: _submitForm,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: kPrimaryBlue,
                                      foregroundColor: Colors.white,
                                      minimumSize: const Size.fromHeight(48),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                      elevation: 4,
                                    ),
                                    icon: const Icon(Icons.arrow_forward_ios),
                                    label: Text(localizations.registerButton),
                                  ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Builds a text input field with optional initialValue
  Widget _buildInputField({
    required String label,
    required String hint,
    String? initialValue,
    TextInputType keyboardType = TextInputType.text,
    required FormFieldSetter<String> onSaved,
    required FormFieldValidator<String> validator,
  }) {
    return TextFormField(
      initialValue: initialValue,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: const OutlineInputBorder(),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 14,
        ),
      ),
      keyboardType: keyboardType,
      validator: validator,
      onSaved: onSaved,
    );
  }

  /// ✅ Use the updated _submitForm to fix user_id missing in profiling
  Future<void> _submitForm() async {
    if (_formKey.currentState?.validate() != true) return;
    _formKey.currentState?.save();
    setState(() => _isLoading = true);

    try {
      // Get language from Riverpod state
      final language = ref.read(languagePrefProvider);

      // 1️⃣ Register the user via API
      final userId = await ApiService.registerUser(
        name: _userName,
        email: _email,
        age: int.tryParse(_age) ?? 0,
        gender: _gender ?? '',
        learning_goal: _learningGoal ?? '',
        language: language,
      );

      debugPrint("✅ Registered User ID: $userId");

      // 2️⃣ Show mentor thumbs up overlay
      await _showThumbsUpOverlay();

      // 3️⃣ Save user info to Hive: both `user` and `settings` boxes
      final userBox = await Hive.openBox('user');
      final settingsBox = await Hive.openBox(kHiveBoxSettings);

      await userBox.put('user_id', userId);
      await userBox.put('name', _userName);
      await userBox.put('email', _email);
      await userBox.put('age', _age);
      await userBox.put('gender', _gender);
      await userBox.put('learning_goal', _learningGoal);
      await userBox.put('language', language);

      await settingsBox.put('user_id', userId); // 🔑 needed for profiling
      await settingsBox.put(kHiveKeyUserName, _userName);
      await settingsBox.put(kHiveKeyEmail, _email);
      await settingsBox.put(kHiveKeyAgeGroup, _age);
      await settingsBox.put(kHiveKeyGender, _gender);
      await settingsBox.put(kHiveKeyLearningGoal, _learningGoal);
      await settingsBox.put(kHiveKeyLanguagePreference, language);

      debugPrint("✅ User profile saved to Hive");

      // 4️⃣ Navigate to Profiling Chat Page
      GoRouter.of(context).go(routeProfilingChat);
    } catch (e) {
      debugPrint('❌ Registration failed: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Something went wrong. Please try again.')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  /// Displays a full-screen fade+zoom of "mentor_thumbs_up_full.png" for ~2s
  Future<void> _showThumbsUpOverlay() async {
    // Remove if there's any existing overlay
    _thumbsUpOverlay?.remove();

    // Create the overlay with fade+scale
    final overlay = OverlayEntry(
      builder: (ctx) => const ThumbsUpOverlay(),
    );

    Overlay.of(context)?.insert(overlay);
    await Future.delayed(const Duration(seconds: 2));
    overlay.remove();
  }
}

/// A separate widget for the fade+scale thumbs up overlay
class ThumbsUpOverlay extends StatefulWidget {
  const ThumbsUpOverlay({Key? key}) : super(key: key);

  @override
  State<ThumbsUpOverlay> createState() => _ThumbsUpOverlayState();
}

class _ThumbsUpOverlayState extends State<ThumbsUpOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnim;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    // 2-second fade+scale
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..forward();

    _fadeAnim = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
    _scaleAnim = Tween<double>(begin: 0.85, end: 1.15).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOut,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnim,
      child: ScaleTransition(
        scale: _scaleAnim,
        child: Container(
          color: Colors.black54,
          child: Center(
            child: Image.asset(
              'assets/images/mentor_expressions/mentor_thumbs_up_full.png',
              width: 220,
              height: 220,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}
