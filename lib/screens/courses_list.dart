import 'package:flutter/material.dart';
import 'package:fluentedge_app/localization/app_localizations.dart';

class CoursesListPage extends StatelessWidget {
  CoursesListPage({Key? key}) : super(key: key);

  final List<Map<String, dynamic>> courses = [
    {"title": "Speak English Fluently", "icon": Icons.record_voice_over},
    {"title": "Master English Grammar", "icon": Icons.rule},
    {"title": "Confident Pronunciation Mastery", "icon": Icons.hearing},
    {"title": "Build Strong Vocabulary", "icon": Icons.book},
    {"title": "Public Speaking & Stage Talk", "icon": Icons.mic_external_on},
    {"title": "Everyday English for Homemakers", "icon": Icons.house},
    {"title": "English for School Projects", "icon": Icons.school},
    {"title": "Office English for Professionals", "icon": Icons.work},
    {"title": "Business English for Managers", "icon": Icons.business_center},
    {"title": "Travel English for Global Explorers", "icon": Icons.travel_explore},
    {"title": "AI Mock Practice for Fluency Boosters", "icon": Icons.chat},
    {"title": "English for Interviews & Job Success", "icon": Icons.how_to_reg},
    {"title": "Festival & Celebration English", "icon": Icons.celebration},
    {"title": "Polite English for Social Media", "icon": Icons.alternate_email},
    {"title": "English for Phone & Video Calls", "icon": Icons.phone_in_talk},
    {"title": "English for Govt Job Aspirants", "icon": Icons.gavel},
    {"title": "Shaadi English", "icon": Icons.favorite},
    {"title": "Temple & Tirth Yatra English", "icon": Icons.temple_buddhist},
    {"title": "Medical English for Healthcare Workers", "icon": Icons.health_and_safety},
    {"title": "Tutor’s English Kit", "icon": Icons.cast_for_education},
    {"title": "Smart Daily Conversations", "icon": Icons.chat_bubble_outline},
    {"title": "Advanced Fluency Challenge", "icon": Icons.flash_on},
    {"title": "AI-Powered Spoken English Coach", "icon": Icons.auto_fix_high},
    {"title": "Grammar Doctor: Fix My Mistakes!", "icon": Icons.medical_services},
  ];

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: const Color(0xFFF2F6FB),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56),
        child: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF1976D2), Color(0xFF42A5F5)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          title: Text(
            localizations.coursesListTitle,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            InkWell(
              onTap: () {
                Navigator.pushNamed(context, '/questionnaire');
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFFE3F2FD), Color(0xFFB3E5FC)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Text(
                  localizations.resumeQuestionnaire,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.blue.shade900,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: GridView.builder(
                  itemCount: courses.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: MediaQuery.of(context).size.width > 600 ? 3 : 2,
                    childAspectRatio: 3 / 2.1,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemBuilder: (context, index) {
                    final course = courses[index];
                    return GestureDetector(
                      onTap: () {
                        // TODO: Pass course details to course screen if needed
                        Navigator.pushNamed(context, '/courseDetail', arguments: course['title']);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.blue.shade100),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.blue.shade100.withOpacity(0.4),
                              blurRadius: 6,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Icon(course['icon'], color: const Color(0xFF0D47A1), size: 24),
                            Text(
                              course['title'],
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 12.5,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.pushNamed(context, '/courseDetail', arguments: course['title']);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF1565C0),
                                  minimumSize: const Size(0, 34),
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: Text(
                                  localizations.startNow,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
