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

  // Function to recommend course based on the user persona
  String recommendCourse(String motivation, String englishLevel, String learningStyle, String difficultyArea, int age, String gender) {
    // Create a list of courses based on user age
    List<Map<String, dynamic>> availableCourses = [];
    
    // If the user is an adult, include all courses
    if (age >= 18) {
      availableCourses = allCourses;
    } else {
      // For minors, exclude adult-only courses
      availableCourses = allCourses.where((course) => course["adultOnly"] == null).toList();
    }

    // Match courses based on motivation, learning style, and difficulty
    List<Map<String, dynamic>> matchedCourses = [];

    // Loop through all courses and find courses matching user inputs
    for (var course in availableCourses) {
      bool matches = false;

      // Match motivation (career-related, personal growth, etc.)
      if (motivation == "Career growth" && course["tags"].contains("business") && englishLevel == "Intermediate") {
        matches = true;
      } else if (motivation == "Personal growth" && course["tags"].contains("fluency") && englishLevel == "Beginner") {
        matches = true;
      }

      // Match learning style and difficulty area
      if (learningStyle == "Visual" && course["tags"].contains("grammar")) {
        matches = true;
      } else if (difficultyArea == "Pronunciation" && course["tags"].contains("pronunciation")) {
        matches = true;
      }

      // Add matched courses to the list
      if (matches) {
        matchedCourses.add(course);
      }
    }

    // If we found matched courses, return the best one, else return a default course
    if (matchedCourses.isNotEmpty) {
      return matchedCourses[0]['title'];
    } else {
      return "Smart Daily Conversations"; // Default course
    }
  }
}
