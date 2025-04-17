import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:fluentedge_app/constants.dart';
import 'package:fluentedge_app/localization/app_localizations.dart';
import 'package:fluentedge_app/data/courses_list.dart';
import 'package:fluentedge_app/widgets/animated_mentor_widget.dart';

class SmartCourseRecommendationPage extends StatelessWidget {
  final String userName;
  final String languagePreference;
  final String gender;
  final String age;
  final String userLevel;
  final List<String> recommendedCourses;

  const SmartCourseRecommendationPage({
    Key? key,
    required this.userName,
    required this.languagePreference,
    required this.gender,
    required this.age,
    required this.userLevel,
    required this.recommendedCourses,
  }) : super(key: key);

  IconData _getIconForCourse(String title) {
    final match = courses.firstWhere(
      (c) => (c['title'] as String).toLowerCase() == title.toLowerCase(),
      orElse: () => {'icon': Icons.lightbulb_outline},
    );
    return match['icon'] as IconData;
  }

  String _whyThisCourse(String title) {
    if (title.contains('Beginner')) {
      return 'Great for starting your English journey from scratch.';
    }
    if (title.contains('Intermediate')) {
      return 'Perfect to boost confidence and handle real conversations.';
    }
    if (title.contains('Advanced')) {
      return 'Designed for fluent users aiming for professional mastery.';
    }
    if (title.contains('Interview') || title.contains('Job')) {
      return 'Helps you prepare for interviews and professional roles.';
    }
    if (title.contains('Travel')) {
      return 'Ideal for traveling abroad or hosting global guests.';
    }
    return 'Tailored to your learning needs and goals.';
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final isHindi = languagePreference == 'हिंदी';
    final safeName = userName.trim().isEmpty ? 'there' : userName;

    return Scaffold(
      backgroundColor: kBannerBlue,
      appBar: AppBar(
        title: Text(
          localizations.yourRecommendations,
          style: const TextStyle(color: Colors.white, fontWeight: kWeightMedium),
        ),
        backgroundColor: kPrimaryBlue,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.go('/welcome'),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 16),
            AnimatedMentorWidget(
              expressionName: 'mentor_pointing_full.png',
              size: kMentorWidgetSize,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Text(
                isHindi
                    ? 'नमस्ते $safeName! आपके लिए ये कोर्स सबसे अच्छे हैं:'
                    : 'Hi $safeName! These courses are perfect for your journey:',
                style: const TextStyle(
                  fontSize: kFontLarge,
                  fontWeight: kWeightBold,
                  color: kPrimaryIconBlue,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: recommendedCourses.length,
                itemBuilder: (context, index) {
                  final title = recommendedCourses[index];
                  final data = courses.firstWhere(
                    (c) => (c['title'] as String).toLowerCase() == title.toLowerCase(),
                    orElse: () => {
                      'title': title,
                      'icon': _getIconForCourse(title),
                      'color': kPrimaryBlue,
                      'tag': 'FREE',
                      'lessons': [],
                    },
                  );
                  final color = data['color'] as Color;
                  final isFree = (data['tag'] as String).toUpperCase() == kFreeCourseTag;

                  return Container(
                    margin: const EdgeInsets.only(bottom: 14),
                    decoration: BoxDecoration(
                      color: kCardBackground,
                      borderRadius: BorderRadius.circular(kCardRadius),
                      boxShadow: kCardBoxShadow,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(kCardPadding),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Hero(
                                tag: data['title'] as String,
                                child: CircleAvatar(
                                  backgroundColor: color.withOpacity(0.15),
                                  child: Icon(
                                    data['icon'] as IconData,
                                    color: color,
                                    size: kIconSize,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  data['title'] as String,
                                  style: const TextStyle(
                                    fontSize: kFontMedium,
                                    fontWeight: kWeightMedium,
                                  ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: isFree
                                      ? kAccentGreen.withOpacity(0.1)
                                      : Colors.orange.shade100,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  isFree ? kFreeCourseTag : kPaidCourseTag,
                                  style: TextStyle(
                                    fontSize: kFontSmall,
                                    fontWeight: kWeightBold,
                                    color: isFree
                                        ? kAccentGreen
                                        : Colors.orange.shade700,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              ElevatedButton(
                                onPressed: () => context.push(
                                  '/courseDetail',
                                  extra: data,
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: kAccentGreen,
                                  foregroundColor: kCardBackground,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 10,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: Text(
                                  localizations.startNow,
                                  style: const TextStyle(fontSize: kFontSmall),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            data['description'] as String? ?? _whyThisCourse(title),
                            style: const TextStyle(
                              fontSize: kFontSmall,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () => context.go('/coursesDashboard'),
              child: Text(
                isHindi
                    ? '🔍 सभी कोर्स देखें'
                    : '🔍 Explore All Courses',
                style: const TextStyle(
                  fontSize: kFontMedium,
                  fontWeight: kWeightMedium,
                  color: kPrimaryIconBlue,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
