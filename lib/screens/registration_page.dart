import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

import 'package:fluentedge_app/constants.dart';
import 'package:fluentedge_app/localization/app_localizations.dart';
import 'package:fluentedge_app/services/api_service.dart';

class RegistrationPage extends ConsumerStatefulWidget {
  const RegistrationPage({Key? key}) : super(key: key);

  @override
  ConsumerState<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends ConsumerState<RegistrationPage> {
  final _formKey = GlobalKey<FormState>();

  String _userName = '';
  String _email = '';
  String _age = '';
  String _gender = '';
  String? _learningGoal;
  bool _isLoading = false;

  final List<String> _learningGoals = [
    'Improve Speaking Fluency',
    'Prepare for Interviews',
    'Build Confidence',
    'Learn from Zero',
    'Travel Communication',
    'Professional English',
  ];

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: kBackgroundSoftBlue,
      appBar: AppBar(
        backgroundColor: kPrimaryBlue,
        foregroundColor: Colors.white,
        centerTitle: true,
        title: Text(localizations.registrationTitle),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Image.asset(
                'assets/images/mentor_expressions/mentor_thumbs_up_full.png',
                width: 140,
                height: 140,
              ),
              const SizedBox(height: 12),
              Text(
                localizations.registrationSubtitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.blueGrey.shade700,
                ),
              ),
              const SizedBox(height: 24),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    _buildInputField(
                      label: localizations.nameLabel,
                      hint: localizations.nameHint,
                      onSaved: (value) => _userName = value!,
                      validator: (value) =>
                          value == null || value.trim().isEmpty
                              ? localizations.nameRequiredError
                              : null,
                    ),
                    const SizedBox(height: 16),
                    _buildInputField(
                      label: localizations.emailLabel,
                      hint: localizations.emailHint,
                      keyboardType: TextInputType.emailAddress,
                      onSaved: (value) => _email = value!,
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
                    const SizedBox(height: 16),
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
                    const SizedBox(height: 16),
                    _buildInputField(
                      label: localizations.genderLabel,
                      hint: localizations.genderHint,
                      onSaved: (value) => _gender = value!,
                      validator: (value) =>
                          value == null || value.trim().isEmpty
                              ? localizations.genderRequiredError
                              : null,
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelText: localizations.goalLabel,
                        border: const OutlineInputBorder(),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 14,
                        ),
                      ),
                      items: _learningGoals
                          .map((goal) => DropdownMenuItem<String>(
                                value: goal,
                                child: Text(goal),
                              ))
                          .toList(),
                      value: _learningGoal,
                      onChanged: (value) => setState(() {
                        _learningGoal = value;
                      }),
                      validator: (value) => value == null || value.isEmpty
                          ? localizations.goalRequiredError
                          : null,
                      onSaved: (value) => _learningGoal = value,
                    ),
                    const SizedBox(height: 32),
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
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
    required FormFieldSetter<String> onSaved,
    required FormFieldValidator<String> validator,
  }) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: const OutlineInputBorder(),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      ),
      keyboardType: keyboardType,
      validator: validator,
      onSaved: onSaved,
    );
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState?.validate() == true) {
      _formKey.currentState?.save();
      setState(() => _isLoading = true);

      try {
        await ref.read(apiServiceProvider).registerUser(
          name: _userName,
          email: _email,
          ageGroup: _age,
          gender: _gender,
          goal: _learningGoal ?? '',
        );

        final box = await Hive.openBox('user');
        await box.put('name', _userName);
        await box.put('email', _email);
        await box.put('age', _age);
        await box.put('gender', _gender);
        await box.put('goal', _learningGoal);

        GoRouter.of(context).go('/profiling_chat_page');
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Something went wrong. Please try again.')),
        );
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }
}
