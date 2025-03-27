import 'package:flutter/material.dart';

class CoursesListPage extends StatelessWidget {
  CoursesListPage({Key? key}) : super(key: key);

  final List<String> courses = [
    "Speak English Fluently",
    "Master English Grammar",
    "Confident Pronunciation Mastery",
    "Build Strong Vocabulary",
    "Public Speaking & Stage Talk",
    "Everyday English for Homemakers",
    "English for School Projects",
    "Office English for Professionals",
    "Business English for Managers",
    "Travel English for Global Explorers",
    "AI Mock Practice for Fluency Boosters",
    "English for Interviews & Job Success",
    "Festival & Celebration English",
    "Polite English for Social Media",
    "English for Phone & Video Calls",
    "English for Govt Job Aspirants",
    "Shaadi English",
    "Temple & Tirth Yatra English",
    "Medical English for Healthcare Workers",
    "Tutor’s English Kit",
    "Smart Daily Conversations",
    "Advanced Fluency Challenge",
    "AI-Powered Spoken English Coach",
    "Grammar Doctor: Fix My Mistakes!"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Choose Your English Journey"),
        backgroundColor: Colors.blue.shade800,
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            color: Colors.blue.shade50,
            padding: const EdgeInsets.all(12),
            child: Text(
              "Not sure where to start? Resume questionnaire →",
              style: TextStyle(fontSize: 16, color: Colors.blue.shade900),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(12),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 3 / 2.2,
              ),
              itemCount: courses.length,
              itemBuilder: (context, index) {
                final courseTitle = courses[index];
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Colors.blue.shade700,
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      )
                    ],
                  ),
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Icon(
                        Icons.school_rounded,
                        color: Colors.blue,
                        size: 32,
                      ),
                      Text(
                        courseTitle,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // TODO: Navigate to course screen
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue.shade700,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text("Start Now"),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
