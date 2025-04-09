import 'package:flutter/material.dart';

/// ✅ Centralized course list shared across all screens
final List<Map<String, dynamic>> courses = [
  // Part 1
  {
    "courseId": "course_001",
    "title": "Speak English Fluently",
    "icon": Icons.record_voice_over,
    "color": Colors.orange,
    "tag": "free",
    "description":
        "Still hesitating while speaking? Start fluently handling daily conversations now.",
    "lessons": [
      {"lessonId": "course_001_lesson_001", "title": "Course Introduction & Goals"},
      {
        "lessonId": "course_001_lesson_002",
        "title": "Basic Vocabulary & Key Phrases (Speak English Fluently)"
      },
      {
        "lessonId": "course_001_lesson_003",
        "title": "Practical Dialogue Introduction - Meet Your Character"
      },
      {
        "lessonId": "course_001_lesson_004",
        "title": "Everyday Scenarios & Mini Role-Play - Interactive Practice"
      },
      {
        "lessonId": "course_001_lesson_005",
        "title": "Common Mistakes & Quick Fixes - Don't Make These Mistakes!"
      },
      {
        "lessonId": "course_001_lesson_006",
        "title": "Building Confidence - Speak Without Hesitation"
      },
      {"lessonId": "course_001_lesson_007", "title": "Mini-Project: Real-Life Test"},
      {
        "lessonId": "course_001_lesson_008",
        "title": "Vocabulary & Grammar Games - Fun with Language"
      },
      {"lessonId": "course_001_lesson_009", "title": "Advanced Dialogues & Conversations"},
      {
        "lessonId": "course_001_lesson_010",
        "title": "Role-play & Recording Practice - Your Turn to Talk"
      },
      {
        "lessonId": "course_001_lesson_011",
        "title": "Overcoming Psychological Barriers - Breaking Barriers"
      },
      {
        "lessonId": "course_001_lesson_012",
        "title": "Interactive Speaking Challenge - Can You Handle This?"
      },
      {
        "lessonId": "course_001_lesson_013",
        "title": "Review & Reflect Session - What Did You Learn?"
      },
      {"lessonId": "course_001_lesson_014", "title": "Project Preparation - Ready for the Final Step"},
      {"lessonId": "course_001_lesson_015", "title": "Final Project Showcase"},
      {
        "lessonId": "course_001_lesson_016",
        "title": "Badge & Course Completion - Speak English Fluently Mastery Badge"
      },
    ],
  },
  {
    "courseId": "course_002",
    "title": "Build Strong Vocabulary",
    "icon": Icons.book,
    "color": Colors.deepPurple,
    "tag": "free",
    "description":
        "Learn 1000+ power words that transform your speaking and writing fast.",
    "lessons": [
      {"lessonId": "course_002_lesson_001", "title": "Course Introduction & Goals"},
      {
        "lessonId": "course_002_lesson_002",
        "title": "Basic Vocabulary & Key Phrases (Build Strong Vocabulary)"
      },
      {
        "lessonId": "course_002_lesson_003",
        "title": "Practical Dialogue Introduction - Meet Your Character"
      },
      {
        "lessonId": "course_002_lesson_004",
        "title": "Everyday Scenarios & Mini Role-Play - Interactive Practice"
      },
      {
        "lessonId": "course_002_lesson_005",
        "title": "Common Mistakes & Quick Fixes - Don't Make These Mistakes!"
      },
      {
        "lessonId": "course_002_lesson_006",
        "title": "Building Confidence - Speak Without Hesitation"
      },
      {"lessonId": "course_002_lesson_007", "title": "Mini-Project: Real-Life Test"},
      {
        "lessonId": "course_002_lesson_008",
        "title": "Vocabulary & Grammar Games - Fun with Language"
      },
      {"lessonId": "course_002_lesson_009", "title": "Advanced Dialogues & Conversations"},
      {
        "lessonId": "course_002_lesson_010",
        "title": "Role-play & Recording Practice - Your Turn to Talk"
      },
      {
        "lessonId": "course_002_lesson_011",
        "title": "Overcoming Psychological Barriers - Breaking Barriers"
      },
      {
        "lessonId": "course_002_lesson_012",
        "title": "Interactive Speaking Challenge - Can You Handle This?"
      },
      {
        "lessonId": "course_002_lesson_013",
        "title": "Review & Reflect Session - What Did You Learn?"
      },
      {"lessonId": "course_002_lesson_014", "title": "Project Preparation - Ready for the Final Step"},
      {"lessonId": "course_002_lesson_015", "title": "Final Project Showcase"},
      {
        "lessonId": "course_002_lesson_016",
        "title": "Badge & Course Completion - Build Strong Vocabulary Mastery Badge"
      },
    ],
  },
  {
    "courseId": "course_003",
    "title": "Everyday English for Homemakers",
    "icon": Icons.house,
    "color": Colors.teal,
    "tag": "free",
    "description":
        "Talk to kids, relatives, and vendors fluently without pausing or switching to Hindi.",
    "lessons": [
      {"lessonId": "course_003_lesson_001", "title": "Course Introduction & Goals"},
      {
        "lessonId": "course_003_lesson_002",
        "title":
            "Basic Vocabulary & Key Phrases (Everyday English for Homemakers)"
      },
      {
        "lessonId": "course_003_lesson_003",
        "title": "Practical Dialogue Introduction - Meet Your Character"
      },
      {
        "lessonId": "course_003_lesson_004",
        "title": "Everyday Scenarios & Mini Role-Play - Interactive Practice"
      },
      {
        "lessonId": "course_003_lesson_005",
        "title": "Common Mistakes & Quick Fixes - Don't Make These Mistakes!"
      },
      {
        "lessonId": "course_003_lesson_006",
        "title": "Building Confidence - Speak Without Hesitation"
      },
      {"lessonId": "course_003_lesson_007", "title": "Mini-Project: Real-Life Test"},
      {
        "lessonId": "course_003_lesson_008",
        "title": "Vocabulary & Grammar Games - Fun with Language"
      },
      {"lessonId": "course_003_lesson_009", "title": "Advanced Dialogues & Conversations"},
      {
        "lessonId": "course_003_lesson_010",
        "title": "Role-play & Recording Practice - Your Turn to Talk"
      },
      {
        "lessonId": "course_003_lesson_011",
        "title": "Overcoming Psychological Barriers - Breaking Barriers"
      },
      {
        "lessonId": "course_003_lesson_012",
        "title": "Interactive Speaking Challenge - Can You Handle This?"
      },
      {
        "lessonId": "course_003_lesson_013",
        "title": "Review & Reflect Session - What Did You Learn?"
      },
      {"lessonId": "course_003_lesson_014", "title": "Project Preparation - Ready for the Final Step"},
      {"lessonId": "course_003_lesson_015", "title": "Final Project Showcase"},
      {
        "lessonId": "course_003_lesson_016",
        "title":
            "Badge & Course Completion - Everyday English for Homemakers Mastery Badge"
      },
    ],
  },

  // Part 2
  {
    "courseId": "course_004",
    "title": "English for School Projects",
    "icon": Icons.school,
    "color": Colors.blueAccent,
    "tag": "free",
    "description":
        "Impress your teachers and classmates with confident English in every project.",
    "lessons": [
      {"lessonId": "course_004_lesson_001", "title": "Course Introduction & Goals"},
      {
        "lessonId": "course_004_lesson_002",
        "title": "Basic Vocabulary & Key Phrases (English for School Projects)"
      },
      {
        "lessonId": "course_004_lesson_003",
        "title": "Practical Dialogue Introduction - Meet Your Character"
      },
      {
        "lessonId": "course_004_lesson_004",
        "title": "Everyday Scenarios & Mini Role-Play - Interactive Practice"
      },
      {
        "lessonId": "course_004_lesson_005",
        "title": "Common Mistakes & Quick Fixes - Don't Make These Mistakes!"
      },
      {
        "lessonId": "course_004_lesson_006",
        "title": "Building Confidence - Speak Without Hesitation"
      },
      {"lessonId": "course_004_lesson_007", "title": "Mini-Project: Real-Life Test"},
      {
        "lessonId": "course_004_lesson_008",
        "title": "Vocabulary & Grammar Games - Fun with Language"
      },
      {"lessonId": "course_004_lesson_009", "title": "Advanced Dialogues & Conversations"},
      {
        "lessonId": "course_004_lesson_010",
        "title": "Role-play & Recording Practice - Your Turn to Talk"
      },
      {
        "lessonId": "course_004_lesson_011",
        "title": "Overcoming Psychological Barriers - Breaking Barriers"
      },
      {
        "lessonId": "course_004_lesson_012",
        "title": "Interactive Speaking Challenge - Can You Handle This?"
      },
      {
        "lessonId": "course_004_lesson_013",
        "title": "Review & Reflect Session - What Did You Learn?"
      },
      {"lessonId": "course_004_lesson_014", "title": "Project Preparation - Ready for the Final Step"},
      {"lessonId": "course_004_lesson_015", "title": "Final Project Showcase"},
      {
        "lessonId": "course_004_lesson_016",
        "title":
            "Badge & Course Completion - English for School Projects Mastery Badge"
      },
    ],
  },
  {
    "courseId": "course_005",
    "title": "Festival & Celebration English",
    "icon": Icons.celebration,
    "color": Colors.pink,
    "tag": "free",
    "description":
        "Celebrate traditions, invite guests, and share rituals using perfect English.",
    "lessons": [
      {"lessonId": "course_005_lesson_001", "title": "Course Introduction & Goals"},
      {
        "lessonId": "course_005_lesson_002",
        "title":
            "Basic Vocabulary & Key Phrases (Festival & Celebration English)"
      },
      {
        "lessonId": "course_005_lesson_003",
        "title": "Practical Dialogue Introduction - Meet Your Character"
      },
      {
        "lessonId": "course_005_lesson_004",
        "title": "Everyday Scenarios & Mini Role-Play - Interactive Practice"
      },
      {
        "lessonId": "course_005_lesson_005",
        "title": "Common Mistakes & Quick Fixes - Don't Make These Mistakes!"
      },
      {
        "lessonId": "course_005_lesson_006",
        "title": "Building Confidence - Speak Without Hesitation"
      },
      {"lessonId": "course_005_lesson_007", "title": "Mini-Project: Real-Life Test"},
      {
        "lessonId": "course_005_lesson_008",
        "title": "Vocabulary & Grammar Games - Fun with Language"
      },
      {"lessonId": "course_005_lesson_009", "title": "Advanced Dialogues & Conversations"},
      {
        "lessonId": "course_005_lesson_010",
        "title": "Role-play & Recording Practice - Your Turn to Talk"
      },
      {
        "lessonId": "course_005_lesson_011",
        "title": "Overcoming Psychological Barriers - Breaking Barriers"
      },
      {
        "lessonId": "course_005_lesson_012",
        "title": "Interactive Speaking Challenge - Can You Handle This?"
      },
      {
        "lessonId": "course_005_lesson_013",
        "title": "Review & Reflect Session - What Did You Learn?"
      },
      {"lessonId": "course_005_lesson_014", "title": "Project Preparation - Ready for the Final Step"},
      {"lessonId": "course_005_lesson_015", "title": "Final Project Showcase"},
      {
        "lessonId": "course_005_lesson_016",
        "title":
            "Badge & Course Completion - Festival & Celebration English Mastery Badge"
      },
    ],
  },
  {
    "courseId": "course_006",
    "title": "Emergency English: Handling Urgent Situations",
    "icon": Icons.emergency,
    "color": Colors.redAccent,
    "tag": "free",
    "description":
        "Learn how to ask for help, explain emergencies, and react fast in English.",
    "lessons": [
      {"lessonId": "course_006_lesson_001", "title": "Course Introduction & Goals"},
      {
        "lessonId": "course_006_lesson_002",
        "title": "Basic Vocabulary & Key Phrases (Emergency English)"
      },
      {
        "lessonId": "course_006_lesson_003",
        "title": "Practical Dialogue Introduction - Meet Your Character"
      },
      {
        "lessonId": "course_006_lesson_004",
        "title": "Everyday Scenarios & Mini Role-Play - Interactive Practice"
      },
      {
        "lessonId": "course_006_lesson_005",
        "title": "Common Mistakes & Quick Fixes - Don't Make These Mistakes!"
      },
      {
        "lessonId": "course_006_lesson_006",
        "title": "Building Confidence - Speak Without Hesitation"
      },
      {"lessonId": "course_006_lesson_007", "title": "Mini-Project: Real-Life Test"},
      {
        "lessonId": "course_006_lesson_008",
        "title": "Vocabulary & Grammar Games - Fun with Language"
      },
      {"lessonId": "course_006_lesson_009", "title": "Advanced Dialogues & Conversations"},
      {
        "lessonId": "course_006_lesson_010",
        "title": "Role-play & Recording Practice - Your Turn to Talk"
      },
      {
        "lessonId": "course_006_lesson_011",
        "title": "Overcoming Psychological Barriers - Breaking Barriers"
      },
      {
        "lessonId": "course_006_lesson_012",
        "title": "Interactive Speaking Challenge - Can You Handle This?"
      },
      {
        "lessonId": "course_006_lesson_013",
        "title": "Review & Reflect Session - What Did You Learn?"
      },
      {"lessonId": "course_006_lesson_014", "title": "Project Preparation - Ready for the Final Step"},
      {"lessonId": "course_006_lesson_015", "title": "Final Project Showcase"},
      {
        "lessonId": "course_006_lesson_016",
        "title": "Badge & Course Completion - Emergency English Mastery Badge"
      },
    ],
  },

  // Part 3
  {
    "courseId": "course_007",
    "title": "Grammar in Action: A Usage-Based Approach",
    "icon": Icons.rule,
    "color": Colors.indigo,
    "tag": "paid",
    "description":
        "Tired of boring grammar rules? Master grammar naturally through real-world usage.",
    "lessons": [
      {"lessonId": "course_007_lesson_001", "title": "Course Introduction & Grammar Essentials"},
      {
        "lessonId": "course_007_lesson_002",
        "title": "Everyday Grammar Usage - Meet Your Grammar Guru"
      },
      {"lessonId": "course_007_lesson_003", "title": "Interactive Dialogue & Usage Practice"},
      {"lessonId": "course_007_lesson_004", "title": "Common Grammar Mistakes & Solutions"},
      {"lessonId": "course_007_lesson_005", "title": "Fun Grammar Games & Quizzes"},
      {"lessonId": "course_007_lesson_006", "title": "Role-play: Grammar in Conversations"},
      {"lessonId": "course_007_lesson_007", "title": "Advanced Grammar Challenges"},
      {"lessonId": "course_007_lesson_008", "title": "Sentence Building and Corrections"},
      {
        "lessonId": "course_007_lesson_009",
        "title": "Speaking with Perfect Grammar - Practice Session"
      },
      {"lessonId": "course_007_lesson_010", "title": "Grammar Confidence Booster"},
      {"lessonId": "course_007_lesson_011", "title": "Grammar-Based Storytelling"},
      {"lessonId": "course_007_lesson_012", "title": "Review & Reflect Session"},
      {"lessonId": "course_007_lesson_013", "title": "Interactive Grammar Challenge"},
      {"lessonId": "course_007_lesson_014", "title": "Project Preparation: Grammar Showcase"},
      {"lessonId": "course_007_lesson_015", "title": "Final Project Presentation"},
      {
        "lessonId": "course_007_lesson_016",
        "title": "Badge & Course Completion - Grammar Mastery Badge"
      },
    ],
  },
  {
    "courseId": "course_008",
    "title": "Confident Pronunciation Mastery",
    "icon": Icons.hearing,
    "color": Colors.cyan,
    "tag": "paid",
    "description":
        "Fix your accent, speak clearly, and sound globally confident within weeks.",
    "lessons": [
      {"lessonId": "course_008_lesson_001", "title": "Course Intro & Pronunciation Basics"},
      {"lessonId": "course_008_lesson_002", "title": "Sounds & Accent Training"},
      {
        "lessonId": "course_008_lesson_003",
        "title": "Interactive Dialogue: Meet Your Pronunciation Coach"
      },
      {"lessonId": "course_008_lesson_004", "title": "Common Pronunciation Mistakes & Fixes"},
      {"lessonId": "course_008_lesson_005", "title": "Tongue Twisters & Practice Games"},
      {
        "lessonId": "course_008_lesson_006",
        "title": "Role-play: Clear Pronunciation Challenges"
      },
      {"lessonId": "course_008_lesson_007", "title": "Recording & Feedback Sessions"},
      {"lessonId": "course_008_lesson_008", "title": "Advanced Pronunciation Drills"},
      {"lessonId": "course_008_lesson_009", "title": "Rhythm & Intonation Practice"},
      {"lessonId": "course_008_lesson_010", "title": "Pronunciation Confidence Booster"},
      {"lessonId": "course_008_lesson_011", "title": "Mini-Project: Pronounce Like a Pro"},
      {"lessonId": "course_008_lesson_012", "title": "Review & Reflect Session"},
      {"lessonId": "course_008_lesson_013", "title": "Pronunciation Challenge"},
      {"lessonId": "course_008_lesson_014", "title": "Preparation for Final Showcase"},
      {"lessonId": "course_008_lesson_015", "title": "Final Pronunciation Project"},
      {
        "lessonId": "course_008_lesson_016",
        "title": "Badge & Course Completion - Pronunciation Mastery Badge"
      },
    ],
  },
  {
    "courseId": "course_009",
    "title": "Public Speaking & Stage Talk (Beginner)",
    "icon": Icons.mic,
    "color": Colors.amber,
    "tag": "free",
    "description":
        "Overcome stage fear and start speaking confidently in public or school functions.",
    "lessons": [
      {"lessonId": "course_009_lesson_001", "title": "Course Introduction & Stage Basics"},
      {"lessonId": "course_009_lesson_002", "title": "Overcoming Stage Fear"},
      {
        "lessonId": "course_009_lesson_003",
        "title": "Interactive Dialogue: Meet Your Stage Friend"
      },
      {"lessonId": "course_009_lesson_004", "title": "Common Public Speaking Mistakes"},
      {"lessonId": "course_009_lesson_005", "title": "Mini Role-play: Your First Speech"},
      {"lessonId": "course_009_lesson_006", "title": "Storytelling Techniques"},
      {"lessonId": "course_009_lesson_007", "title": "Audience Engagement Tips"},
      {"lessonId": "course_009_lesson_008", "title": "Interactive Speaking Games"},
      {"lessonId": "course_009_lesson_009", "title": "Practice Speeches & Feedback"},
      {"lessonId": "course_009_lesson_010", "title": "Confidence Building Activities"},
      {"lessonId": "course_009_lesson_011", "title": "Stage Talk Challenges"},
      {"lessonId": "course_009_lesson_012", "title": "Review & Reflect Session"},
      {"lessonId": "course_009_lesson_013", "title": "Speaking Challenge Game"},
      {"lessonId": "course_009_lesson_014", "title": "Preparation for Stage Showcase"},
      {"lessonId": "course_009_lesson_015", "title": "Final Speech Project"},
      {
        "lessonId": "course_009_lesson_016",
        "title": "Badge & Course Completion - Public Speaking Beginner Badge"
      },
    ],
  },

  // Part 4
  {
    "courseId": "course_010",
    "title": "Office English for Professionals",
    "icon": Icons.work,
    "color": Colors.brown,
    "tag": "paid",
    "description":
        "Master workplace emails, meetings, and communication. Be promotion-ready!",
    "lessons": [
      {"lessonId": "course_010_lesson_001", "title": "Course Intro & Office English Basics"},
      {"lessonId": "course_010_lesson_002", "title": "Email & Written Communication"},
      {
        "lessonId": "course_010_lesson_003",
        "title": "Meet Your Professional Guide - Interactive Dialogue"
      },
      {"lessonId": "course_010_lesson_004", "title": "Common Workplace Mistakes & Fixes"},
      {"lessonId": "course_010_lesson_005", "title": "Role-play: Workplace Scenarios"},
      {
        "lessonId": "course_010_lesson_006",
        "title": "Interactive Meetings & Discussions"
      },
      {"lessonId": "course_010_lesson_007", "title": "Business Presentation Skills"},
      {"lessonId": "course_010_lesson_008", "title": "Negotiations & Polite English"},
      {"lessonId": "course_010_lesson_009", "title": "Advanced Professional Vocabulary"},
      {"lessonId": "course_010_lesson_010", "title": "Confidence in Meetings"},
      {"lessonId": "course_010_lesson_011", "title": "Practice: Writing & Speaking Drills"},
      {"lessonId": "course_010_lesson_012", "title": "Review & Reflect Session"},
      {"lessonId": "course_010_lesson_013", "title": "Interactive Office Challenge"},
      {"lessonId": "course_010_lesson_014", "title": "Preparation for Final Showcase"},
      {"lessonId": "course_010_lesson_015", "title": "Final Office Project"},
      {
        "lessonId": "course_010_lesson_016",
        "title": "Badge & Course Completion - Office English Mastery Badge"
      },
    ],
  },
  {
    "courseId": "course_011",
    "title": "Travel English for Global Explorers",
    "icon": Icons.travel_explore,
    "color": Colors.green,
    "tag": "free",
    "description":
        "Speak fluently at airports, hotels, restaurants, and make global connections.",
    "lessons": [
      {"lessonId": "course_011_lesson_001", "title": "Course Intro & Essential Travel Phrases"},
      {
        "lessonId": "course_011_lesson_002",
        "title": "Interactive Travel Dialogue - Meet Your Travel Buddy"
      },
      {
        "lessonId": "course_011_lesson_003",
        "title": "Common Travel Mistakes & Quick Fixes"
      },
      {
        "lessonId": "course_011_lesson_004",
        "title": "Role-play: Airport & Flight Conversations"
      },
      {"lessonId": "course_011_lesson_005", "title": "Hotel & Accommodation Scenarios"},
      {"lessonId": "course_011_lesson_006", "title": "Dining & Restaurant Conversations"},
      {"lessonId": "course_011_lesson_007", "title": "Sightseeing & Tour Discussions"},
      {"lessonId": "course_011_lesson_008", "title": "Practical Travel Vocabulary"},
      {"lessonId": "course_011_lesson_009", "title": "Handling Emergencies Abroad"},
      {"lessonId": "course_011_lesson_010", "title": "Interactive Travel Challenges"},
      {"lessonId": "course_011_lesson_011", "title": "Confidence in Global Conversations"},
      {"lessonId": "course_011_lesson_012", "title": "Review & Reflect Session"},
      {"lessonId": "course_011_lesson_013", "title": "Travel Dialogue Challenge"},
      {"lessonId": "course_011_lesson_014", "title": "Preparation for Travel Showcase"},
      {"lessonId": "course_011_lesson_015", "title": "Final Travel Project"},
      {
        "lessonId": "course_011_lesson_016",
        "title": "Badge & Course Completion - Global Explorer Badge"
      },
    ],
  },
  {
    "courseId": "course_012",
    "title": "Polite English for Social Media",
    "icon": Icons.alternate_email,
    "color": Colors.deepOrange,
    "tag": "free",
    "description":
        "Avoid awkward or rude posts. Learn modern and respectful online English.",
    "lessons": [
      {"lessonId": "course_012_lesson_001", "title": "Course Intro & Online Etiquette Basics"},
      {
        "lessonId": "course_012_lesson_002",
        "title": "Interactive Dialogue: Meet Your Social Media Mentor"
      },
      {"lessonId": "course_012_lesson_003", "title": "Common Social Media Mistakes"},
      {
        "lessonId": "course_012_lesson_004",
        "title": "Role-play: Commenting & Posting Politely"
      },
      {"lessonId": "course_012_lesson_005", "title": "Writing Engaging Posts"},
      {"lessonId": "course_012_lesson_006", "title": "Emoji & Tone - Getting It Right"},
      {
        "lessonId": "course_012_lesson_007",
        "title": "Handling Criticism & Negative Comments"
      },
      {"lessonId": "course_012_lesson_008", "title": "Social Media Language Games"},
      {"lessonId": "course_012_lesson_009", "title": "Advanced Social Media Expressions"},
      {"lessonId": "course_012_lesson_010", "title": "Confidence in Online Interactions"},
      {
        "lessonId": "course_012_lesson_011",
        "title": "Interactive Social Media Challenge"
      },
      {"lessonId": "course_012_lesson_012", "title": "Review & Reflect Session"},
      {"lessonId": "course_012_lesson_013", "title": "Practical Posting Challenge"},
      {"lessonId": "course_012_lesson_014", "title": "Preparation for Final Showcase"},
      {"lessonId": "course_012_lesson_015", "title": "Final Social Media Project"},
      {
        "lessonId": "course_012_lesson_016",
        "title": "Badge & Course Completion - Social Media Mastery Badge"
      },
    ],
  },

  // Part 5
  {
    "courseId": "course_013",
    "title": "English for Phone & Video Calls",
    "icon": Icons.phone,
    "color": Colors.purpleAccent,
    "tag": "free",
    "description":
        "Never panic on calls again. Speak confidently in personal and professional calls.",
    "lessons": [
      {"lessonId": "course_013_lesson_001", "title": "Course Intro & Call Basics"},
      {
        "lessonId": "course_013_lesson_002",
        "title": "Interactive Dialogue: Meet Your Call Coach"
      },
      {"lessonId": "course_013_lesson_003", "title": "Common Phone Call Mistakes"},
      {"lessonId": "course_013_lesson_004", "title": "Mini Role-play: Basic Calls"},
      {"lessonId": "course_013_lesson_005", "title": "Professional Call Scenarios"},
      {
        "lessonId": "course_013_lesson_006",
        "title": "Casual Conversations & Video Calls"
      },
      {
        "lessonId": "course_013_lesson_007",
        "title": "Confidence-Building Phone Activities"
      },
      {"lessonId": "course_013_lesson_008", "title": "Advanced Call Practice"},
      {"lessonId": "course_013_lesson_009", "title": "Handling Difficult Calls"},
      {"lessonId": "course_013_lesson_010", "title": "Interactive Call Challenges"},
      {"lessonId": "course_013_lesson_011", "title": "Recording & Feedback"},
      {"lessonId": "course_013_lesson_012", "title": "Review & Reflect Session"},
      {"lessonId": "course_013_lesson_013", "title": "Call Confidence Challenge"},
      {"lessonId": "course_013_lesson_014", "title": "Preparation for Call Showcase"},
      {"lessonId": "course_013_lesson_015", "title": "Final Call Project"},
      {
        "lessonId": "course_013_lesson_016",
        "title": "Badge & Course Completion - Phone & Video Call Mastery Badge"
      },
    ],
  },
  {
    "courseId": "course_014",
    "title": "English for Govt Job Aspirants",
    "icon": Icons.gavel,
    "color": Colors.deepPurpleAccent,
    "tag": "paid",
    "description":
        "Crack SSC, UPSC, or Banking interviews with impactful English and confidence.",
    "lessons": [
      {"lessonId": "course_014_lesson_001", "title": "Course Introduction & Interview Basics"},
      {"lessonId": "course_014_lesson_002", "title": "Common Govt Job Interview Mistakes"},
      {"lessonId": "course_014_lesson_003", "title": "Interactive Interview Dialogues"},
      {"lessonId": "course_014_lesson_004", "title": "Role-play: Typical Interview Questions"},
      {"lessonId": "course_014_lesson_005", "title": "Vocabulary for Govt Exams"},
      {"lessonId": "course_014_lesson_006", "title": "Building Interview Confidence"},
      {"lessonId": "course_014_lesson_007", "title": "Writing Effective Answers"},
      {"lessonId": "course_014_lesson_008", "title": "Mock Interviews & Feedback"},
      {"lessonId": "course_014_lesson_009", "title": "Interactive Vocabulary Challenges"},
      {"lessonId": "course_014_lesson_010", "title": "Professional Speaking Drills"},
      {"lessonId": "course_014_lesson_011", "title": "Confidence & Fear Reduction"},
      {"lessonId": "course_014_lesson_012", "title": "Review & Reflect Session"},
      {"lessonId": "course_014_lesson_013", "title": "Practical Interview Challenge"},
      {
        "lessonId": "course_014_lesson_014",
        "title": "Preparation for Final Interview Showcase"
      },
      {"lessonId": "course_014_lesson_015", "title": "Final Govt Job Project"},
      {
        "lessonId": "course_014_lesson_016",
        "title": "Badge & Course Completion - Govt Job Aspirants Badge"
      },
    ],
  },
  {
    "courseId": "course_015",
    "title": "Grammar Doctor: Fix My Mistakes!",
    "icon": Icons.medical_services,
    "color": Colors.redAccent,
    "tag": "free",
    "description":
        "Stop making common Indian-English errors. Fix them with fun, real exercises.",
    "lessons": [
      {"lessonId": "course_015_lesson_001", "title": "Course Intro & Common Grammar Errors"},
      {
        "lessonId": "course_015_lesson_002",
        "title": "Meet Your Grammar Doctor - Interactive Session"
      },
      {
        "lessonId": "course_015_lesson_003",
        "title": "Typical Mistakes: Indian English vs. Global English"
      },
      {
        "lessonId": "course_015_lesson_004",
        "title": "Role-play: Grammar Correction Exercises"
      },
      {"lessonId": "course_015_lesson_005", "title": "Spot & Fix the Error Games"},
      {"lessonId": "course_015_lesson_006", "title": "Grammar Doctor Challenges"},
      {"lessonId": "course_015_lesson_007", "title": "Interactive Grammar Clinic"},
      {"lessonId": "course_015_lesson_008", "title": "Confidence in Grammar"},
      {"lessonId": "course_015_lesson_009", "title": "Practical Usage Drills"},
      {"lessonId": "course_015_lesson_010", "title": "Grammar Review & Reflect"},
      {"lessonId": "course_015_lesson_011", "title": "Final Grammar Correction Project"},
      {
        "lessonId": "course_015_lesson_012",
        "title": "Badge & Course Completion - Grammar Doctor Badge"
      },
    ],
  },

  // Part 6
  {
    "courseId": "course_016",
    "title": "Public Speaking & Stage Talk (Advanced)",
    "icon": Icons.record_voice_over_outlined,
    "color": Colors.orangeAccent,
    "tag": "paid",
    "description":
        "Already confident? Learn powerful hooks, persuasive tone, and wow your audience.",
    "lessons": [
      {
        "lessonId": "course_016_lesson_001",
        "title": "Course Intro & Advanced Speaking Techniques"
      },
      {"lessonId": "course_016_lesson_002", "title": "Powerful Introductions & Hooks"},
      {
        "lessonId": "course_016_lesson_003",
        "title": "Meet Your Advanced Public Speaking Coach"
      },
      {"lessonId": "course_016_lesson_004", "title": "Persuasive Speaking Skills"},
      {"lessonId": "course_016_lesson_005", "title": "Interactive Stage Challenges"},
      {"lessonId": "course_016_lesson_006", "title": "Mastering Body Language"},
      {"lessonId": "course_016_lesson_007", "title": "Advanced Speech Writing"},
      {"lessonId": "course_016_lesson_008", "title": "Audience Analysis & Interaction"},
      {"lessonId": "course_016_lesson_009", "title": "Real-time Feedback & Improvements"},
      {
        "lessonId": "course_016_lesson_010",
        "title": "Overcoming Advanced Stage Barriers"
      },
      {"lessonId": "course_016_lesson_011", "title": "Advanced Storytelling Techniques"},
      {"lessonId": "course_016_lesson_012", "title": "Review & Reflect Session"},
      {"lessonId": "course_016_lesson_013", "title": "Stage Mastery Challenge"},
      {"lessonId": "course_016_lesson_014", "title": "Preparation for Final Showcase"},
      {"lessonId": "course_016_lesson_015", "title": "Final Advanced Speech Project"},
      {
        "lessonId": "course_016_lesson_016",
        "title": "Badge & Course Completion - Stage Talk Advanced Badge"
      },
    ],
  },
  {
    "courseId": "course_017",
    "title": "Business English for Managers (Advanced)",
    "icon": Icons.business_center,
    "color": Colors.greenAccent,
    "tag": "paid",
    "description":
        "Command boardrooms, lead teams, and impress clients with flawless English.",
    "lessons": [
      {
        "lessonId": "course_017_lesson_001",
        "title": "Course Introduction & Leadership Language"
      },
      {"lessonId": "course_017_lesson_002", "title": "Advanced Business Communication"},
      {
        "lessonId": "course_017_lesson_003",
        "title": "Interactive Dialogue: Meet Your Business Mentor"
      },
      {
        "lessonId": "course_017_lesson_004",
        "title": "Common Management Communication Errors"
      },
      {
        "lessonId": "course_017_lesson_005",
        "title": "Role-play: Handling Difficult Conversations"
      },
      {
        "lessonId": "course_017_lesson_006",
        "title": "Effective Presentation & Pitch Skills"
      },
      {"lessonId": "course_017_lesson_007", "title": "Negotiations & Persuasion Techniques"},
      {"lessonId": "course_017_lesson_008", "title": "Managing Meetings & Discussions"},
      {"lessonId": "course_017_lesson_009", "title": "Team Leadership & Motivation"},
      {"lessonId": "course_017_lesson_010", "title": "Business Writing Mastery"},
      {"lessonId": "course_017_lesson_011", "title": "Interactive Business Challenges"},
      {"lessonId": "course_017_lesson_012", "title": "Review & Reflect Session"},
      {"lessonId": "course_017_lesson_013", "title": "Management Language Challenge"},
      {"lessonId": "course_017_lesson_014", "title": "Preparation for Final Business Showcase"},
      {"lessonId": "course_017_lesson_015", "title": "Final Management Project"},
      {
        "lessonId": "course_017_lesson_016",
        "title": "Badge & Course Completion - Business English Mastery Badge"
      },
    ],
  },
  {
    "courseId": "course_018",
    "title": "English for Interviews & Job Success (Advanced)",
    "icon": Icons.how_to_reg,
    "color": Colors.tealAccent,
    "tag": "paid",
    "description":
        "Practice expert-level answers and build your confidence for top jobs.",
    "lessons": [
      {
        "lessonId": "course_018_lesson_001",
        "title": "Course Intro & Advanced Interview Skills"
      },
      {
        "lessonId": "course_018_lesson_002",
        "title": "Interactive Dialogue: Meet Your Interview Coach"
      },
      {"lessonId": "course_018_lesson_003", "title": "Advanced Question Handling"},
      {
        "lessonId": "course_018_lesson_004",
        "title": "Common Interview Mistakes (Advanced)"
      },
      {"lessonId": "course_018_lesson_005", "title": "Role-play: Executive Level Interviews"},
      {
        "lessonId": "course_018_lesson_006",
        "title": "Personal Branding & Self-Introduction"
      },
      {"lessonId": "course_018_lesson_007", "title": "Interactive Mock Interviews"},
      {"lessonId": "course_018_lesson_008", "title": "Professional English Drills"},
      {"lessonId": "course_018_lesson_009", "title": "Answer Structuring & Delivery"},
      {
        "lessonId": "course_018_lesson_010",
        "title": "Confidence in High-Pressure Interviews"
      },
      {
        "lessonId": "course_018_lesson_011",
        "title": "Interactive Interview Challenges"
      },
      {"lessonId": "course_018_lesson_012", "title": "Review & Reflect Session"},
      {"lessonId": "course_018_lesson_013", "title": "Advanced Interview Challenge"},
      {"lessonId": "course_018_lesson_014", "title": "Preparation for Final Interview Showcase"},
      {"lessonId": "course_018_lesson_015", "title": "Final Interview Project"},
      {
        "lessonId": "course_018_lesson_016",
        "title": "Badge & Course Completion - Interview Mastery Badge"
      },
    ],
  },

  // Part 7
  {
    "courseId": "course_019",
    "title": "Medical English for Healthcare Workers (Advanced)",
    "icon": Icons.health_and_safety,
    "color": Colors.red,
    "tag": "paid",
    "description":
        "Talk to patients and peers with clarity, compassion, and medical accuracy.",
    "lessons": [
      {
        "lessonId": "course_019_lesson_001",
        "title": "Course Intro & Essential Medical Phrases"
      },
      {
        "lessonId": "course_019_lesson_002",
        "title": "Interactive Dialogue: Meet Your Medical Mentor"
      },
      {"lessonId": "course_019_lesson_003", "title": "Common Medical Communication Errors"},
      {"lessonId": "course_019_lesson_004", "title": "Role-play: Patient Conversations"},
      {"lessonId": "course_019_lesson_005", "title": "Advanced Medical Vocabulary"},
      {
        "lessonId": "course_019_lesson_006",
        "title": "Handling Emergencies & Critical Situations"
      },
      {"lessonId": "course_019_lesson_007", "title": "Medical Documentation Skills"},
      {"lessonId": "course_019_lesson_008", "title": "Interactive Medical Scenarios"},
      {"lessonId": "course_019_lesson_009", "title": "Empathy & Clear Communication"},
      {
        "lessonId": "course_019_lesson_010",
        "title": "Confidence Building for Medical Professionals"
      },
      {
        "lessonId": "course_019_lesson_011",
        "title": "Interactive Medical Challenges"
      },
      {"lessonId": "course_019_lesson_012", "title": "Review & Reflect Session"},
      {"lessonId": "course_019_lesson_013", "title": "Medical Scenario Challenge"},
      {"lessonId": "course_019_lesson_014", "title": "Preparation for Medical English Showcase"},
      {"lessonId": "course_019_lesson_015", "title": "Final Medical Project"},
      {
        "lessonId": "course_019_lesson_016",
        "title": "Badge & Course Completion - Medical English Mastery Badge"
      },
    ],
  },
  {
    "courseId": "course_020",
    "title": "Tutor’s English Kit (Advanced)",
    "icon": Icons.cast_for_education,
    "color": Colors.blueGrey,
    "tag": "paid",
    "description":
        "Stand out as a modern tutor. Handle parents, students, and training sessions fluently.",
    "lessons": [
      {
        "lessonId": "course_020_lesson_001",
        "title": "Course Intro & Teaching English Basics"
      },
      {
        "lessonId": "course_020_lesson_002",
        "title": "Interactive Dialogue: Meet Your Tutor Mentor"
      },
      {
        "lessonId": "course_020_lesson_003",
        "title": "Common Tutor Communication Mistakes"
      },
      {
        "lessonId": "course_020_lesson_004",
        "title": "Role-play: Parent-Teacher Communication"
      },
      {"lessonId": "course_020_lesson_005", "title": "Engaging Classroom Language"},
      {"lessonId": "course_020_lesson_006", "title": "Advanced Tutoring Vocabulary"},
      {"lessonId": "course_020_lesson_007", "title": "Interactive Classroom Scenarios"},
      {"lessonId": "course_020_lesson_008", "title": "Confidence & Classroom Management"},
      {"lessonId": "course_020_lesson_009", "title": "Creating Engaging Lessons"},
      {"lessonId": "course_020_lesson_010", "title": "Interactive Tutoring Challenges"},
      {"lessonId": "course_020_lesson_011", "title": "Review & Reflect Session"},
      {"lessonId": "course_020_lesson_012", "title": "Tutoring Scenario Challenge"},
      {
        "lessonId": "course_020_lesson_013",
        "title": "Preparation for Tutor English Showcase"
      },
      {"lessonId": "course_020_lesson_014", "title": "Final Tutoring Project"},
      {
        "lessonId": "course_020_lesson_015",
        "title": "Badge & Course Completion - Tutor’s English Kit Badge"
      },
    ],
  },
  {
    "courseId": "course_021",
    "title": "Advanced Fluency Challenge",
    "icon": Icons.flash_on,
    "color": Colors.yellowAccent,
    "tag": "paid",
    "description":
        "Hit a plateau? Challenge yourself to reach the next level of spoken fluency.",
    "lessons": [
      {"lessonId": "course_021_lesson_001", "title": "Course Intro & Fluency Techniques"},
      {
        "lessonId": "course_021_lesson_002",
        "title": "Interactive Dialogue: Meet Your Fluency Coach"
      },
      {"lessonId": "course_021_lesson_003", "title": "Advanced Conversation Drills"},
      {"lessonId": "course_021_lesson_004", "title": "Role-play: Real-world Challenges"},
      {"lessonId": "course_021_lesson_005", "title": "Fluency & Vocabulary Expansion"},
      {"lessonId": "course_021_lesson_006", "title": "Idioms & Expressions Mastery"},
      {"lessonId": "course_021_lesson_007", "title": "Interactive Fluency Games"},
      {"lessonId": "course_021_lesson_008", "title": "Rapid Speaking Challenges"},
      {"lessonId": "course_021_lesson_009", "title": "Confidence in Advanced Speaking"},
      {"lessonId": "course_021_lesson_010", "title": "Storytelling & Fluency Practice"},
      {"lessonId": "course_021_lesson_011", "title": "Review & Reflect Session"},
      {"lessonId": "course_021_lesson_012", "title": "Fluency Mastery Challenge"},
      {"lessonId": "course_021_lesson_013", "title": "Preparation for Fluency Showcase"},
      {"lessonId": "course_021_lesson_014", "title": "Final Fluency Project"},
      {
        "lessonId": "course_021_lesson_015",
        "title": "Badge & Course Completion - Advanced Fluency Badge"
      },
    ],
  },

  // Part 8
  {
    "courseId": "course_022",
    "title": "Creative Writing & Literary Analysis",
    "icon": Icons.edit,
    "color": Colors.indigoAccent,
    "tag": "paid",
    "description":
        "Write essays, stories, and poetry creatively. Learn to analyze like a literature pro.",
    "lessons": [
      {"lessonId": "course_022_lesson_001", "title": "Course Intro & Writing Mindset"},
      {"lessonId": "course_022_lesson_002", "title": "Genres: Narrative, Descriptive, Reflective"},
      {"lessonId": "course_022_lesson_003", "title": "Creative Story Structure"},
      {"lessonId": "course_022_lesson_004", "title": "Poetry Writing Basics"},
      {"lessonId": "course_022_lesson_005", "title": "Literary Devices & Expression"},
      {"lessonId": "course_022_lesson_006", "title": "Peer Review & Constructive Feedback"},
      {"lessonId": "course_022_lesson_007", "title": "Reading Literary Passages"},
      {"lessonId": "course_022_lesson_008", "title": "Literary Analysis: Characters & Theme"},
      {"lessonId": "course_022_lesson_009", "title": "Interactive Writing Prompts"},
      {"lessonId": "course_022_lesson_010", "title": "Grammar for Writers"},
      {"lessonId": "course_022_lesson_011", "title": "Editing & Drafting Process"},
      {"lessonId": "course_022_lesson_012", "title": "Mini Portfolio Project"},
      {"lessonId": "course_022_lesson_013", "title": "Final Creative Submission"},
      {"lessonId": "course_022_lesson_014", "title": "Badge Earned: Creative Writing Pro"},
    ],
  },
  {
    "courseId": "course_023",
    "title": "English for Diplomats & Government Officials",
    "icon": Icons.account_balance,
    "color": Colors.pinkAccent,
    "tag": "paid",
    "description":
        "Speak in meetings, deliver statements, and write emails in flawless diplomatic English.",
    "lessons": [
      {"lessonId": "course_023_lesson_001", "title": "Diplomatic English Overview"},
      {"lessonId": "course_023_lesson_002", "title": "Public Announcements & Statements"},
      {"lessonId": "course_023_lesson_003", "title": "Email Writing for Diplomats"},
      {"lessonId": "course_023_lesson_004", "title": "Tone: Formal vs. Courteous"},
      {"lessonId": "course_023_lesson_005", "title": "Cultural Nuances in Communication"},
      {"lessonId": "course_023_lesson_006", "title": "Presenting Facts & Opinions"},
      {
        "lessonId": "course_023_lesson_007",
        "title": "Handling Disagreements Diplomatically"
      },
      {"lessonId": "course_023_lesson_008", "title": "English for UN/Embassy Events"},
      {"lessonId": "course_023_lesson_009", "title": "Writing Reports & Memos"},
      {"lessonId": "course_023_lesson_010", "title": "Confidence in Cross-cultural Settings"},
      {"lessonId": "course_023_lesson_011", "title": "Review & Reflect"},
      {
        "lessonId": "course_023_lesson_012",
        "title": "Final Task: Draft a Diplomatic Report"
      },
      {
        "lessonId": "course_023_lesson_013",
        "title": "Badge Earned: Diplomatic English Mastery"
      },
    ],
  },
  {
    "courseId": "course_024",
    "title": "Smart Daily Conversations",
    "icon": Icons.chat_bubble_outline,
    "color": Colors.deepOrange,
    "tag": "free",
    "description":
        "Master smart, short, everyday dialogues used at home, in markets, and on the go.",
    "lessons": [
      {"lessonId": "course_024_lesson_001", "title": "Intro: Why Daily English Matters"},
      {
        "lessonId": "course_024_lesson_002",
        "title": "Home Scenarios: Cooking, Cleaning, Kids"
      },
      {
        "lessonId": "course_024_lesson_003",
        "title": "Market Role-play & Bargaining Talk"
      },
      {
        "lessonId": "course_024_lesson_004",
        "title": "Asking for Directions & Transport English"
      },
      {
        "lessonId": "course_024_lesson_005",
        "title": "Doctor, Salon, Repair: Practical Chat"
      },
      {"lessonId": "course_024_lesson_006", "title": "Phone, Video Call Dialogues"},
      {
        "lessonId": "course_024_lesson_007",
        "title": "Handling Emergencies with Calm English"
      },
      {
        "lessonId": "course_024_lesson_008",
        "title": "Restaurant & Shopping Dialogues"
      },
      {"lessonId": "course_024_lesson_009", "title": "Cultural Small Talk"},
      {"lessonId": "course_024_lesson_010", "title": "Weekend, Weather, Hobby Chat"},
      {"lessonId": "course_024_lesson_011", "title": "Final Practice Round"},
      {"lessonId": "course_024_lesson_012", "title": "Badge Earned: Daily English Pro"},
    ],
  },
];
