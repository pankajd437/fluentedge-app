import 'package:flutter/material.dart';
import 'package:fluentedge_app/localization/app_localizations.dart';

class SmartCourseRecommendationPage extends StatelessWidget {
  final String userName;
  final String languagePreference;
  final String recommendedCourse;

  const SmartCourseRecommendationPage({
    super.key,
    required this.userName,
    required this.languagePreference,
    required this.recommendedCourse,
  });

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final safeUserName = userName.trim().isEmpty ? "there" : userName;

    // Cleaned course name
    final cleanedCourse = recommendedCourse.replaceAll(RegExp(r'[^\x00-\x7F]+'), '').trim();

    return Scaffold(
      appBar: AppBar(
        title: FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: Text(
            "📘 $cleanedCourse",
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 18,
            ),
            maxLines: 2,
            overflow: TextOverflow.visible,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
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
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
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
                      style: const TextStyle(fontSize: 16, color: Colors.black87),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  const Icon(Icons.check_circle, color: Colors.green, size: 24),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _getLocalizedCourseTitle(cleanedCourse, languagePreference),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
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
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 3,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextButton.icon(
                    onPressed: () {
                      Navigator.popUntil(context, (route) => route.isFirst);
                    },
                    icon: const Icon(Icons.home_outlined),
                    label: Text(
                      _getGoHomeLabel(languagePreference),
                      style: const TextStyle(fontWeight: FontWeight.w500),
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
}
