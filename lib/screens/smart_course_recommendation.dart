import 'package:flutter/material.dart';
import 'package:fluentedge_app/localization/app_localizations.dart';

class SmartCourseRecommendationPage extends StatelessWidget {
  final String userName;
  final String languagePreference;
  final String recommendedCourse; // The recommended course passed from the questionnaire or service
  final String gender; // Added gender field
  final int age; // Added age field

  const SmartCourseRecommendationPage({
    super.key,
    required this.userName,
    required this.languagePreference, // Include this parameter
    required this.recommendedCourse,  // Recommended course based on user responses
    required this.gender,  // Include gender as a parameter
    required this.age, // Include age as a parameter
  });

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final safeUserName = userName.trim().isEmpty ? "there" : userName;
    final cleanedCourse = recommendedCourse.replaceAll(RegExp(r'[^\x00-\x7F]+'), '').trim();

    // Additional logic for filtering course recommendations based on age and gender
    String finalCourse = _applyAgeGenderFilter(recommendedCourse);

    return Scaffold(
      backgroundColor: const Color(0xFFF2F6FB), // Background color
      appBar: AppBar(
        title: FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: Text(
            "📘 $finalCourse", // Display the filtered final course
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 16,
            ),
            maxLines: 2,
            overflow: TextOverflow.visible,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF1976D2), Color(0xFF42A5F5)], // Gradient AppBar
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                localizations.getWelcomeResponse(safeUserName, languagePreference),
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                  color: Color(0xFF0D47A1), // Dark Navy Blue for headings
                ),
              ),
              const SizedBox(height: 20),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.star, color: Colors.orangeAccent),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _getLocalizedCourseIntro(localizations, languagePreference),
                      style: const TextStyle(
                        fontSize: 13, // Banner Text font
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  const Icon(Icons.check_circle, color: Color(0xFF0D47A1), size: 24), // Icon Color
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _getLocalizedCourseTitle(finalCourse, languagePreference), // Use the filtered course here
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              const Divider(thickness: 1.2),
              const SizedBox(height: 30),
              Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // Simulate course starting, show a snackbar or navigate to a course screen
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(_getComingSoonText(languagePreference)),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                      icon: const Icon(Icons.rocket_launch, color: Colors.white),
                      label: Text(
                        _getStartCourseLabel(languagePreference),
                        style: const TextStyle(
                          fontSize: 12, // Button Text
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1565C0), // Primary CTA Color
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8), // Button Shape
                        ),
                        elevation: 2,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextButton.icon(
                    onPressed: () {
                      Navigator.popUntil(context, (route) => route.isFirst);
                    },
                    icon: const Icon(Icons.home_outlined, color: Color(0xFF0D47A1)), // Icon Color
                    label: Text(
                      _getGoHomeLabel(languagePreference),
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF0D47A1), // Text Link Color
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getLocalizedCourseIntro(AppLocalizations loc, String lang) {
    switch (lang) {
      case 'हिंदी':
        return "आपके उद्देश्यों और अनुभव के आधार पर, हमने आपके लिए एक विशेष कोर्स चुना है।";
      default:
        return "Based on your goals and experience, we've selected a course just for you.";
    }
  }

  String _getLocalizedCourseTitle(String course, String lang) {
    switch (lang) {
      case 'हिंदी':
        return "कोर्स: $course";
      default:
        return "Course: $course";
    }
  }

  String _getStartCourseLabel(String lang) {
    switch (lang) {
      case 'हिंदी':
        return "कोर्स शुरू करें";
      default:
        return "Start Course";
    }
  }

  String _getGoHomeLabel(String lang) {
    switch (lang) {
      case 'हिंदी':
        return "होम पर जाएं";
      default:
        return "Go to Home";
    }
  }

  String _getComingSoonText(String lang) {
    switch (lang) {
      case 'हिंदी':
        return "🚀 कोर्स जल्द आ रहा है...";
      default:
        return "🚀 Course access coming soon...";
    }
  }

  // New method to filter courses based on age and gender
  String _applyAgeGenderFilter(String course) {
    if (age < 18) {
      // Exclude adult courses for minors
      if (course.contains("Adult")) {
        return "Smart Daily Conversations"; // Default course for minors
      }
    }
    if (gender == 'Male') {
      // Example: specific course recommendations for males
      if (course == "Business English for Managers") {
        return "English for Interviews & Job Success"; // Male-friendly course recommendation
      }
    }
    return course; // Default course if no filter applies
  }
}
