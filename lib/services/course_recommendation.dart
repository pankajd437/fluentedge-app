import 'persona_identifier.dart';

class CourseRecommendationService {
  // List of all available courses with their properties
  final List<Map<String, dynamic>> allCourses = [
    {"title": "Speak English Fluently", "icon": "record_voice_over", "tags": ["fluency", "beginner"]},
    {"title": "Master English Grammar", "icon": "rule", "tags": ["grammar", "intermediate"]},
    {"title": "Confident Pronunciation Mastery", "icon": "hearing", "tags": ["pronunciation", "advanced"]},
    {"title": "Build Strong Vocabulary", "icon": "book", "tags": ["vocabulary", "beginner"]},
    {"title": "Public Speaking & Stage Talk", "icon": "mic_external_on", "tags": ["public speaking", "intermediate"]},
    {"title": "Everyday English for Homemakers", "icon": "house", "tags": ["everyday", "beginner"], "adultOnly": true},
    {"title": "English for School Projects", "icon": "school", "tags": ["academic", "beginner"]},
    {"title": "Office English for Professionals", "icon": "work", "tags": ["business", "intermediate"], "adultOnly": true},
    {"title": "Business English for Managers", "icon": "business_center", "tags": ["business", "advanced"], "adultOnly": true},
    {"title": "Travel English for Global Explorers", "icon": "travel_explore", "tags": ["travel", "beginner"], "adultOnly": true},
    {"title": "AI Mock Practice for Fluency Boosters", "icon": "chat", "tags": ["fluency", "advanced"]},
    {"title": "English for Interviews & Job Success", "icon": "how_to_reg", "tags": ["interviews", "intermediate"], "adultOnly": true},
    {"title": "Festival & Celebration English", "icon": "celebration", "tags": ["cultural", "beginner"], "adultOnly": true},
    {"title": "Polite English for Social Media", "icon": "alternate_email", "tags": ["social media", "beginner"], "adultOnly": true},
    {"title": "English for Phone & Video Calls", "icon": "phone_in_talk", "tags": ["communication", "intermediate"], "adultOnly": true},
    {"title": "English for Govt Job Aspirants", "icon": "gavel", "tags": ["government", "advanced"], "adultOnly": true},
    {"title": "Shaadi English", "icon": "favorite", "tags": ["personal", "beginner"], "adultOnly": true},
    {"title": "Temple & Tirth Yatra English", "icon": "temple_buddhist", "tags": ["spiritual", "beginner"], "adultOnly": true},
    {"title": "Medical English for Healthcare Workers", "icon": "health_and_safety", "tags": ["medical", "advanced"], "adultOnly": true},
    {"title": "Tutor’s English Kit", "icon": "cast_for_education", "tags": ["teaching", "intermediate"], "adultOnly": true},
    {"title": "Smart Daily Conversations", "icon": "chat_bubble_outline", "tags": ["conversation", "beginner"]},
    {"title": "Advanced Fluency Challenge", "icon": "flash_on", "tags": ["fluency", "advanced"]},
    {"title": "AI-Powered Spoken English Coach", "icon": "auto_fix_high", "tags": ["fluency", "advanced"]},
    {"title": "Grammar Doctor: Fix My Mistakes!", "icon": "medical_services", "tags": ["grammar", "advanced"]},
  ];

  // Mapping: Persona → Course titles
  final Map<String, List<String>> personaCourseMap = {
    "Young Beginner Explorer": [
      "Speak English Fluently",
      "Smart Daily Conversations",
      "English for School Projects",
      "Build Strong Vocabulary"
    ],
    "Adult Fluency Seeker": [
      "Speak English Fluently",
      "Confident Pronunciation Mastery",
      "Smart Daily Conversations",
      "Advanced Fluency Challenge"
    ],
    "Career-Oriented Professional": [
      "Office English for Professionals",
      "English for Interviews & Job Success",
      "Business English for Managers",
      "AI Mock Practice for Fluency Boosters"
    ],
    "Home Learner (Homemaker)": [
      "Everyday English for Homemakers",
      "Speak English Fluently",
      "Polite English for Social Media"
    ],
    "Grammar-Focused Learner": [
      "Master English Grammar",
      "Grammar Doctor: Fix My Mistakes!",
      "Build Strong Vocabulary"
    ],
    "Spiritual Explorer": [
      "Temple & Tirth Yatra English",
      "Festival & Celebration English"
    ],
    "Medical or Teaching Professional": [
      "Medical English for Healthcare Workers",
      "Tutor’s English Kit",
      "Public Speaking & Stage Talk"
    ],
    "Advanced Fluency Achiever": [
      "Advanced Fluency Challenge",
      "AI-Powered Spoken English Coach"
    ],
  };

  /// Returns list of recommended course titles based on user's questionnaire responses
  List<String> recommendCourses({
    required String motivation,
    required String englishLevel,
    required String learningStyle,
    required String difficultyArea,
    required int age,
    required String gender,
  }) {
    final persona = PersonaIdentifier.getPersona(
      motivation: motivation,
      englishLevel: englishLevel,
      learningStyle: learningStyle,
      difficultyArea: difficultyArea,
      age: age,
      gender: gender,
    );

    final recommendedTitles = personaCourseMap[persona] ?? ["Smart Daily Conversations"];

    // Filter courses based on age
    final allowedCourses = allCourses.where((course) {
      final isAdultOnly = course["adultOnly"] == true;
      return !isAdultOnly || age >= 18;
    }).toList();

    // Return only allowed course titles from recommendations
    return recommendedTitles.where((title) =>
      allowedCourses.any((course) => course["title"] == title)
    ).toList();
  }
}
