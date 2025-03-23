import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'ice_breaking_chat.dart';
import 'package:fluentedge_frontend/widgets/fluentedge_logo.dart'; // ✅ Import Logo

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  String selectedLanguage = "English"; // Default language
  TextEditingController nameController = TextEditingController();
  bool isButtonEnabled = false;
  String mentorGreeting = "Your AI English Coach is Here! 🎙️"; // Default greeting
  bool isLoading = false; // Loading indicator

  @override
  void initState() {
    super.initState();
    updateGreeting(selectedLanguage); // Ensure greeting updates on page load
    validateForm(); // Ensure button is disabled initially
  }

  // 🔹 Update mentor greeting based on selected language
  void updateGreeting(String language) {
    setState(() {
      if (language == "हिंदी") {
        mentorGreeting = "आपका एआई इंग्लिश कोच यहाँ है! 🎙️";
      } else if (language == "Hinglish") {
        mentorGreeting = "Aapka AI English Coach yahaan hai! 🎙️";
      } else {
        mentorGreeting = "Your AI English Coach is Here! 🎙️";
      }
    });
  }

  // 🔹 Enable/Disable Continue Button
  void validateForm() {
    setState(() {
      isButtonEnabled = nameController.text.trim().isNotEmpty;
    });
  }

  // 🔹 Save User Basic Info API
  Future<void> saveUserBasicInfo() async {
    setState(() {
      isLoading = true;
    });

    final response = await http.post(
      Uri.parse('https://your-api.com/saveUserBasicInfo'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "name": nameController.text.trim(),
        "language_preference": selectedLanguage
      }),
    );

    setState(() {
      isLoading = false;
    });

    if (response.statusCode == 200) {
      debugPrint("✅ User info saved successfully!");
    } else {
      debugPrint("❌ Failed to save user info.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView( // Fixes Input Field Not Visible Issue
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // 🔹 Logo, Name Input, Animation Section
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 10),

                    // ✅ Updated: Logo Integration
                    const FluentEdgeLogo(), 
                    debugPrint("FluentEdge Logo Rendered"), // Debugging

                    const SizedBox(height: 20),

                    // 🔹 Name Input Field
                    TextField(
                      controller: nameController,
                      onChanged: (value) {
                        validateForm();
                        debugPrint("User entered name: $value"); // Debugging
                      },
                      decoration: InputDecoration(
                        labelText: "What can I call you?",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        prefixIcon: const Icon(Icons.person, color: Colors.blueAccent),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // 🔹 AI Mentor Animation
                    Lottie.asset(
                      'assets/animations/mentor_welcome.json',
                      width: 250,
                      height: 250,
                      fit: BoxFit.cover,
                    ),

                    const SizedBox(height: 20),

                    // 🔹 Dynamic Mentor Greeting
                    Text(
                      mentorGreeting,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),

                    const SizedBox(height: 10),

                    // 🔹 Subtitle
                    const Text(
                      "Master English speaking with real-time AI guidance. Let's begin your journey today!",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),

              // 🔹 Language Selection & Continue Button Section
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
                    // 🔹 Language Selection
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Choose Language:",
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(width: 10),
                        DropdownButton<String>(
                          value: selectedLanguage,
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedLanguage = newValue!;
                              updateGreeting(selectedLanguage);
                            });
                          },
                          items: <String>["English", "हिंदी", "Hinglish"]
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

                    // 🔹 Continue Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: isButtonEnabled
                            ? () async {
                                await saveUserBasicInfo();
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const IceBreakingChatPage()),
                                );
                              }
                            : null,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          backgroundColor: isButtonEnabled ? Colors.blueAccent : Colors.grey,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: isLoading
                            ? const CircularProgressIndicator(color: Colors.white)
                            : const Text("Continue"),
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
