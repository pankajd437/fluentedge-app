import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:fluentedge_app/constants.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({Key? key}) : super(key: key);

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _formKey = GlobalKey<FormState>();

  String _userName = '';
  String _email = '';
  String _age = '';
  String _gender = '';
  String? _learningGoal;

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
    return Scaffold(
      backgroundColor: kBackgroundSoftBlue,
      appBar: AppBar(
        backgroundColor: kPrimaryBlue,
        foregroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          "User Registration",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  "👋 Let’s personalize your learning journey!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.blueGrey.shade700,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    _buildInputField(
                      label: "Name",
                      hint: "Enter your full name",
                      onSaved: (value) => _userName = value!,
                      validator: (value) =>
                          value == null || value.trim().isEmpty
                              ? "Please enter your name"
                              : null,
                    ),
                    const SizedBox(height: 16),
                    _buildInputField(
                      label: "Email",
                      hint: "Enter your email",
                      keyboardType: TextInputType.emailAddress,
                      onSaved: (value) => _email = value!,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Please enter your email";
                        }
                        if (!value.contains('@')) {
                          return "Enter a valid email";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    _buildInputField(
                      label: "Age",
                      hint: "Enter your age",
                      keyboardType: TextInputType.number,
                      onSaved: (value) => _age = value!,
                      validator: (value) {
                        final age = int.tryParse(value ?? '');
                        if (age == null || age <= 0) {
                          return "Enter a valid age";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    _buildInputField(
                      label: "Gender",
                      hint: "Enter your gender",
                      onSaved: (value) => _gender = value!,
                      validator: (value) =>
                          value == null || value.trim().isEmpty
                              ? "Please enter your gender"
                              : null,
                    ),
                    const SizedBox(height: 16),

                    // 🎯 Dropdown for Learning Goal
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        labelText: "Learning Goal",
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(
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
                      validator: (value) =>
                          value == null || value.isEmpty
                              ? "Please select your learning goal"
                              : null,
                      onSaved: (value) => _learningGoal = value,
                    ),

                    const SizedBox(height: 32),

                    // 🎉 Submit Button
                    ElevatedButton.icon(
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
                      label: const Text(
                        "Register",
                        style: TextStyle(fontSize: 16),
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

  void _submitForm() {
    if (_formKey.currentState?.validate() == true) {
      _formKey.currentState?.save();

      debugPrint("✅ Registration Data:");
      debugPrint("Name: $_userName");
      debugPrint("Email: $_email");
      debugPrint("Age: $_age");
      debugPrint("Gender: $_gender");
      debugPrint("Goal: $_learningGoal");

      // 🔁 Navigate to next step
      GoRouter.of(context).go('/questionnaire');
    }
  }
}
