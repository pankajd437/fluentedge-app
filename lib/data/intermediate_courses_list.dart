import 'package:flutter/material.dart';

final List<Map<String, dynamic>> intermediateCourses = [
  {
    "courseId": "intermediate_001",
    "title": "Social English Mastery: Conversations with Confidence",
    "icon": Icons.groups,
    "color": Colors.blue,
    "tag": "free",
    "description":
        "Build social confidence and master real-life conversations, from small talk to friendships.",
    "lessons": [
      {"lessonId": "intermediate_001_lesson_001", "title": "Course Intro & Social Anxiety"},
      {"lessonId": "intermediate_001_lesson_002", "title": "Mastering Small Talk"},
      {"lessonId": "intermediate_001_lesson_003", "title": "Engaging in Group Conversations"},
      {"lessonId": "intermediate_001_lesson_004", "title": "Expressing Opinions Politely"},
      {"lessonId": "intermediate_001_lesson_005", "title": "Listening Actively in Social Situations"},
      {"lessonId": "intermediate_001_lesson_006", "title": "Building Friendships Naturally"},
      {"lessonId": "intermediate_001_lesson_007", "title": "Handling Social Misunderstandings"},
      {"lessonId": "intermediate_001_lesson_008", "title": "Empathy Checkpoint: Overcoming Awkwardness"},
      {"lessonId": "intermediate_001_lesson_009", "title": "Role-play: Party Conversations"},
      {"lessonId": "intermediate_001_lesson_010", "title": "Mini-Project: Record a Social Interaction"},
      {"lessonId": "intermediate_001_lesson_011", "title": "Reflection: Social Confidence Check"},
      {"lessonId": "intermediate_001_lesson_012", "title": "Final Showcase: Confident Social Speaker"},
      {"lessonId": "intermediate_001_lesson_013", "title": "Badge Earned: Social English Master"},
    ],
  },
  {
    "courseId": "intermediate_002",
    "title": "Workplace English Essentials: Communicate Clearly at Work",
    "icon": Icons.work_outline,
    "color": Colors.deepPurple,
    "tag": "free",
    "description":
        "Gain confidence for daily workplace tasks, meetings, and professional interactions.",
    "lessons": [
      {"lessonId": "intermediate_002_lesson_001", "title": "Course Intro: Workplace Communication"},
      {"lessonId": "intermediate_002_lesson_002", "title": "Clear Communication in Meetings"},
      {"lessonId": "intermediate_002_lesson_003", "title": "Writing Professional Emails"},
      {"lessonId": "intermediate_002_lesson_004", "title": "Giving and Receiving Feedback"},
      {"lessonId": "intermediate_002_lesson_005", "title": "Expressing Ideas Clearly"},
      {"lessonId": "intermediate_002_lesson_006", "title": "Handling Workplace Conflicts"},
      {"lessonId": "intermediate_002_lesson_007", "title": "Interactive Role-play: Team Discussions"},
      {"lessonId": "intermediate_002_lesson_008", "title": "Empathy Checkpoint: Handling Mistakes at Work"},
      {"lessonId": "intermediate_002_lesson_009", "title": "Workplace Vocabulary Games"},
      {"lessonId": "intermediate_002_lesson_010", "title": "Mini-Project: Professional Email Writing"},
      {"lessonId": "intermediate_002_lesson_011", "title": "Reflection: Workplace Confidence"},
      {"lessonId": "intermediate_002_lesson_012", "title": "Final Showcase: Workplace Communication Expert"},
      {"lessonId": "intermediate_002_lesson_013", "title": "Badge Earned: Workplace Confident"},
    ],
  },
  {
    "courseId": "intermediate_003",
    "title": "Travel Conversations: Fluent English for Travelers",
    "icon": Icons.flight,
    "color": Colors.teal,
    "tag": "free",
    "description":
        "Handle every travel scenario smoothly, from airports to sightseeing, with confident English.",
    "lessons": [
      {"lessonId": "intermediate_003_lesson_001", "title": "Course Intro: Smooth Travels"},
      {"lessonId": "intermediate_003_lesson_002", "title": "Airport Check-in & Security"},
      {"lessonId": "intermediate_003_lesson_003", "title": "Immigration & Customs Conversations"},
      {"lessonId": "intermediate_003_lesson_004", "title": "Public Transport & Directions"},
      {"lessonId": "intermediate_003_lesson_005", "title": "Hotel Check-ins & Requests"},
      {"lessonId": "intermediate_003_lesson_006", "title": "Dining Out Clearly & Confidently"},
      {"lessonId": "intermediate_003_lesson_007", "title": "Interactive Role-play: Travel Scenarios"},
      {"lessonId": "intermediate_003_lesson_008", "title": "Handling Travel Issues & Emergencies"},
      {"lessonId": "intermediate_003_lesson_009", "title": "Empathy Checkpoint: Travel Stress"},
      {"lessonId": "intermediate_003_lesson_010", "title": "Mini-Project: Record a Travel Dialogue"},
      {"lessonId": "intermediate_003_lesson_011", "title": "Reflection: Travel Conversations"},
      {"lessonId": "intermediate_003_lesson_012", "title": "Final Showcase: Fluent Traveler"},
      {"lessonId": "intermediate_003_lesson_013", "title": "Badge Earned: Travel Fluent"},
    ],
  },
  {
    "courseId": "intermediate_004",
    "title": "Grammar in Action: Master Grammar through Speaking",
    "icon": Icons.menu_book,
    "color": Colors.deepOrange,
    "tag": "free",
    "description":
        "Learn grammar practically and naturally through engaging real-world conversations.",
    "lessons": [
      {"lessonId": "intermediate_004_lesson_001", "title": "Intro: Practical Grammar"},
      {"lessonId": "intermediate_004_lesson_002", "title": "Using Tenses Naturally"},
      {"lessonId": "intermediate_004_lesson_003", "title": "Correcting Common Grammar Errors"},
      {"lessonId": "intermediate_004_lesson_004", "title": "Grammar for Clear Communication"},
      {"lessonId": "intermediate_004_lesson_005", "title": "Interactive Grammar Conversations"},
      {"lessonId": "intermediate_004_lesson_006", "title": "Real-world Grammar Scenarios"},
      {"lessonId": "intermediate_004_lesson_007", "title": "Grammar Games & Challenges"},
      {"lessonId": "intermediate_004_lesson_008", "title": "Empathy Checkpoint: Grammar Confidence"},
      {"lessonId": "intermediate_004_lesson_009", "title": "Role-play: Everyday Grammar Usage"},
      {"lessonId": "intermediate_004_lesson_010", "title": "Mini-Project: Grammar Recording"},
      {"lessonId": "intermediate_004_lesson_011", "title": "Reflection: Grammar Mastery"},
      {"lessonId": "intermediate_004_lesson_012", "title": "Final Showcase: Grammar in Action"},
      {"lessonId": "intermediate_004_lesson_013", "title": "Badge Earned: Grammar Expert"},
    ],
  },
  {
    "courseId": "intermediate_005",
    "title": "Pronunciation Boost: Speak Clearly & Confidently",
    "icon": Icons.record_voice_over,
    "color": Colors.deepOrangeAccent,
    "tag": "premium",
    "description":
        "Enhance your pronunciation skills and become clearly understood in real-life situations.",
    "lessons": [
      {
        "lessonId": "intermediate_005_lesson_001",
        "title": "Course Intro: Importance of Pronunciation"
      },
      {
        "lessonId": "intermediate_005_lesson_002",
        "title": "Mastering Difficult Sounds"
      },
      {
        "lessonId": "intermediate_005_lesson_003",
        "title": "Stress and Intonation Basics"
      },
      {
        "lessonId": "intermediate_005_lesson_004",
        "title": "Pronunciation in Conversations"
      },
      {
        "lessonId": "intermediate_005_lesson_005",
        "title": "Common Mispronunciations & Fixes"
      },
      {
        "lessonId": "intermediate_005_lesson_006",
        "title": "Interactive Speaking Exercises"
      },
      {
        "lessonId": "intermediate_005_lesson_007",
        "title": "Empathy Checkpoint: Pronunciation Anxiety"
      },
      {
        "lessonId": "intermediate_005_lesson_008",
        "title": "Fun Tongue Twister Challenges"
      },
      {
        "lessonId": "intermediate_005_lesson_009",
        "title": "Listening & Mimicking Exercises"
      },
      {
        "lessonId": "intermediate_005_lesson_010",
        "title": "Personal Pronunciation Audit"
      },
      {
        "lessonId": "intermediate_005_lesson_011",
        "title": "Mini-Project: Record Your Improvement"
      },
      {
        "lessonId": "intermediate_005_lesson_012",
        "title": "Final Showcase: Pronunciation Mastery"
      },
      {
        "lessonId": "intermediate_005_lesson_013",
        "title": "Badge Earned: Clear Communicator"
      },
    ],
  },
  {
    "courseId": "intermediate_006",
    "title": "Public Speaking Essentials: Overcome Fear & Speak Clearly",
    "icon": Icons.mic,
    "color": Colors.indigo,
    "tag": "premium",
    "description":
        "Build your public speaking skills and overcome anxiety in front of groups.",
    "lessons": [
      {
        "lessonId": "intermediate_006_lesson_001",
        "title": "Intro: Overcoming Public Speaking Anxiety"
      },
      {
        "lessonId": "intermediate_006_lesson_002",
        "title": "Structuring Your Speech"
      },
      {
        "lessonId": "intermediate_006_lesson_003",
        "title": "Voice Control & Clarity"
      },
      {
        "lessonId": "intermediate_006_lesson_004",
        "title": "Engaging Your Audience"
      },
      {
        "lessonId": "intermediate_006_lesson_005",
        "title": "Handling Questions Confidently"
      },
      {
        "lessonId": "intermediate_006_lesson_006",
        "title": "Interactive Role-play: Giving Presentations"
      },
      {
        "lessonId": "intermediate_006_lesson_007",
        "title": "Empathy Checkpoint: Managing Stage Fright"
      },
      {
        "lessonId": "intermediate_006_lesson_008",
        "title": "Public Speaking Practice Games"
      },
      {
        "lessonId": "intermediate_006_lesson_009",
        "title": "Video Feedback: Watch & Improve"
      },
      {
        "lessonId": "intermediate_006_lesson_010",
        "title": "Reflection: Public Speaking Confidence"
      },
      {
        "lessonId": "intermediate_006_lesson_011",
        "title": "Mini-Project: Record Your Speech"
      },
      {
        "lessonId": "intermediate_006_lesson_012",
        "title": "Final Showcase: Confident Speaker"
      },
      {
        "lessonId": "intermediate_006_lesson_013",
        "title": "Badge Earned: Public Speaker"
      },
    ],
  },
  {
    "courseId": "intermediate_007",
    "title": "Phone & Video Calls: Clear Communication Without Stress",
    "icon": Icons.phone,
    "color": Colors.purpleAccent,
    "tag": "premium",
    "description":
        "Improve your clarity on calls and video chats, removing stress and hesitation.",
    "lessons": [
      {
        "lessonId": "intermediate_007_lesson_001",
        "title": "Intro: Confident Call Skills"
      },
      {
        "lessonId": "intermediate_007_lesson_002",
        "title": "Common Phrases for Calls"
      },
      {
        "lessonId": "intermediate_007_lesson_003",
        "title": "Answering & Making Calls Clearly"
      },
      {
        "lessonId": "intermediate_007_lesson_004",
        "title": "Managing Misunderstandings"
      },
      {
        "lessonId": "intermediate_007_lesson_005",
        "title": "Interactive Role-play: Phone Scenarios"
      },
      {
        "lessonId": "intermediate_007_lesson_006",
        "title": "Empathy Checkpoint: Overcoming Anxiety"
      },
      {
        "lessonId": "intermediate_007_lesson_007",
        "title": "Practical Call Exercises"
      },
      {
        "lessonId": "intermediate_007_lesson_008",
        "title": "Listening and Clarifying on Calls"
      },
      {
        "lessonId": "intermediate_007_lesson_009",
        "title": "Call Etiquette and Politeness"
      },
      {
        "lessonId": "intermediate_007_lesson_010",
        "title": "Reflection: Improved Call Confidence"
      },
      {
        "lessonId": "intermediate_007_lesson_011",
        "title": "Mini-Project: Record a Simulated Call"
      },
      {
        "lessonId": "intermediate_007_lesson_012",
        "title": "Final Showcase: Call Mastery"
      },
      {
        "lessonId": "intermediate_007_lesson_013",
        "title": "Badge Earned: Confident Caller"
      },
    ],
  },
  {
    "courseId": "intermediate_008",
    "title": "English for Digital Life: Writing & Speaking Online",
    "icon": Icons.laptop_mac,
    "color": Colors.lightGreen,
    "tag": "premium",
    "description":
        "Confidently communicate online, mastering emails, messaging, and digital interactions.",
    "lessons": [
      {
        "lessonId": "intermediate_008_lesson_001",
        "title": "Intro: Clear Digital Communication"
      },
      {
        "lessonId": "intermediate_008_lesson_002",
        "title": "Writing Clear Emails"
      },
      {
        "lessonId": "intermediate_008_lesson_003",
        "title": "Social Media Conversations"
      },
      {
        "lessonId": "intermediate_008_lesson_004",
        "title": "Messaging & Chatting Clearly"
      },
      {
        "lessonId": "intermediate_008_lesson_005",
        "title": "Interactive Role-play: Online Communication"
      },
      {
        "lessonId": "intermediate_008_lesson_006",
        "title": "Empathy Checkpoint: Digital Anxiety"
      },
      {
        "lessonId": "intermediate_008_lesson_007",
        "title": "Practical Online Communication Exercises"
      },
      {
        "lessonId": "intermediate_008_lesson_008",
        "title": "Understanding & Using Emojis"
      },
      {
        "lessonId": "intermediate_008_lesson_009",
        "title": "Online Conversation Etiquette"
      },
      {
        "lessonId": "intermediate_008_lesson_010",
        "title": "Reflection: Improved Online Presence"
      },
      {
        "lessonId": "intermediate_008_lesson_011",
        "title": "Mini-Project: Digital Interaction Recording"
      },
      {
        "lessonId": "intermediate_008_lesson_012",
        "title": "Final Showcase: Digital Communicator"
      },
      {
        "lessonId": "intermediate_008_lesson_013",
        "title": "Badge Earned: Digital Expert"
      },
    ],
  },
  {
    "courseId": "intermediate_009",
    "title": "Storytelling & Conversations: Express Yourself Clearly",
    "icon": Icons.menu_book,
    "color": Colors.tealAccent,
    "tag": "premium",
    "description":
        "Enhance your speaking skills naturally through storytelling and engaging conversations.",
    "lessons": [
      {"lessonId": "intermediate_009_lesson_001", "title": "Intro: Power of Storytelling"},
      {"lessonId": "intermediate_009_lesson_002", "title": "Building Vocabulary with Stories"},
      {"lessonId": "intermediate_009_lesson_003", "title": "Expressing Emotions Clearly"},
      {"lessonId": "intermediate_009_lesson_004", "title": "Connecting Ideas Naturally"},
      {"lessonId": "intermediate_009_lesson_005", "title": "Role-play: Sharing Personal Stories"},
      {"lessonId": "intermediate_009_lesson_006", "title": "Interactive Story Challenges"},
      {"lessonId": "intermediate_009_lesson_007", "title": "Empathy Checkpoint: Storytelling Anxiety"},
      {"lessonId": "intermediate_009_lesson_008", "title": "Improvisation & Spontaneous Speech"},
      {"lessonId": "intermediate_009_lesson_009", "title": "Listening & Responding with Stories"},
      {"lessonId": "intermediate_009_lesson_010", "title": "Reflection: My Storytelling Journey"},
      {"lessonId": "intermediate_009_lesson_011", "title": "Mini-Project: Record Your Story"},
      {"lessonId": "intermediate_009_lesson_012", "title": "Final Showcase: Storytelling Mastery"},
      {"lessonId": "intermediate_009_lesson_013", "title": "Badge Earned: Master Storyteller"},
    ],
  },
  {
    "courseId": "intermediate_010",
    "title": "Listening & Responding: Practical Conversation Skills",
    "icon": Icons.hearing,
    "color": Colors.amber,
    "tag": "premium",
    "description":
        "Strengthen listening skills to respond confidently in everyday conversations.",
    "lessons": [
      {"lessonId": "intermediate_010_lesson_001", "title": "Intro: The Art of Listening"},
      {"lessonId": "intermediate_010_lesson_002", "title": "Active Listening Techniques"},
      {"lessonId": "intermediate_010_lesson_003", "title": "Responding Naturally & Appropriately"},
      {"lessonId": "intermediate_010_lesson_004", "title": "Interactive Role-play: Everyday Dialogues"},
      {"lessonId": "intermediate_010_lesson_005", "title": "Handling Misunderstandings"},
      {"lessonId": "intermediate_010_lesson_006", "title": "Empathy Checkpoint: Listening Anxiety"},
      {"lessonId": "intermediate_010_lesson_007", "title": "Listening & Conversation Games"},
      {"lessonId": "intermediate_010_lesson_008", "title": "Effective Questioning Techniques"},
      {"lessonId": "intermediate_010_lesson_009", "title": "Listening Exercises & Quizzes"},
      {"lessonId": "intermediate_010_lesson_010", "title": "Reflection: Listening Confidence"},
      {"lessonId": "intermediate_010_lesson_011", "title": "Mini-Project: Recorded Conversations"},
      {"lessonId": "intermediate_010_lesson_012", "title": "Final Showcase: Skilled Conversationalist"},
      {"lessonId": "intermediate_010_lesson_013", "title": "Badge Earned: Active Listener"},
    ],
  },
  {
    "courseId": "intermediate_011",
    "title": "English at Restaurants & Cafés: Order & Chat Confidently",
    "icon": Icons.restaurant,
    "color": Colors.redAccent,
    "tag": "premium",
    "description":
        "Handle restaurant scenarios confidently and engage comfortably in casual chats.",
    "lessons": [
      {"lessonId": "intermediate_011_lesson_001", "title": "Intro: Dining Out with Confidence"},
      {"lessonId": "intermediate_011_lesson_002", "title": "Vocabulary for Restaurants & Cafés"},
      {"lessonId": "intermediate_011_lesson_003", "title": "Ordering Food & Drinks Clearly"},
      {"lessonId": "intermediate_011_lesson_004", "title": "Handling Special Requests"},
      {"lessonId": "intermediate_011_lesson_005", "title": "Interactive Role-play: Dining Scenarios"},
      {"lessonId": "intermediate_011_lesson_006", "title": "Casual Conversation at Cafés"},
      {"lessonId": "intermediate_011_lesson_007", "title": "Empathy Checkpoint: Ordering Anxiety"},
      {"lessonId": "intermediate_011_lesson_008", "title": "Managing Complaints & Feedback"},
      {"lessonId": "intermediate_011_lesson_009", "title": "Restaurant & Café Speaking Games"},
      {"lessonId": "intermediate_011_lesson_010", "title": "Reflection: Dining Confidence"},
      {"lessonId": "intermediate_011_lesson_011", "title": "Mini-Project: Record Your Order"},
      {"lessonId": "intermediate_011_lesson_012", "title": "Final Showcase: Dining Conversations"},
      {"lessonId": "intermediate_011_lesson_013", "title": "Badge Earned: Restaurant Ready"},
    ],
  },
  {
    "courseId": "intermediate_012",
    "title": "Shopping & Errands English: Confident Daily Conversations",
    "icon": Icons.shopping_cart,
    "color": Colors.blueGrey,
    "tag": "premium",
    "description":
        "Master clear communication for shopping and daily errands, improving your routine speaking skills.",
    "lessons": [
      {"lessonId": "intermediate_012_lesson_001", "title": "Intro: Shopping Confidence"},
      {"lessonId": "intermediate_012_lesson_002", "title": "Essential Vocabulary for Shopping"},
      {"lessonId": "intermediate_012_lesson_003", "title": "Asking Questions & Getting Assistance"},
      {"lessonId": "intermediate_012_lesson_004", "title": "Interactive Role-play: Daily Errands"},
      {"lessonId": "intermediate_012_lesson_005", "title": "Negotiating & Making Payments"},
      {"lessonId": "intermediate_012_lesson_006", "title": "Handling Returns & Exchanges"},
      {"lessonId": "intermediate_012_lesson_007", "title": "Empathy Checkpoint: Shopping Anxiety"},
      {"lessonId": "intermediate_012_lesson_008", "title": "Speaking Clearly with Store Staff"},
      {"lessonId": "intermediate_012_lesson_009", "title": "Shopping Conversation Games"},
      {"lessonId": "intermediate_012_lesson_010", "title": "Reflection: Shopping Interactions"},
      {"lessonId": "intermediate_012_lesson_011", "title": "Mini-Project: Record a Shopping Trip"},
      {"lessonId": "intermediate_012_lesson_012", "title": "Final Showcase: Shopping & Errands"},
      {"lessonId": "intermediate_012_lesson_013", "title": "Badge Earned: Shopping Pro"},
    ],
  },
  {
    "courseId": "intermediate_013",
    "title": "English for Health & Fitness: Clear Communication & Confidence",
    "icon": Icons.fitness_center,
    "color": Colors.greenAccent,
    "tag": "premium",
    "description":
        "Communicate confidently at gyms, doctor's offices, and in health situations.",
    "lessons": [
      {"lessonId": "intermediate_013_lesson_001", "title": "Intro: Health & Fitness Communication"},
      {"lessonId": "intermediate_013_lesson_002", "title": "Vocabulary for Health & Wellness"},
      {"lessonId": "intermediate_013_lesson_003", "title": "Talking to Doctors & Health Professionals"},
      {"lessonId": "intermediate_013_lesson_004", "title": "Gym & Fitness Conversations"},
      {"lessonId": "intermediate_013_lesson_005", "title": "Interactive Role-play: Medical Scenarios"},
      {"lessonId": "intermediate_013_lesson_006", "title": "Describing Symptoms & Feelings Clearly"},
      {"lessonId": "intermediate_013_lesson_007", "title": "Empathy Checkpoint: Health Anxiety"},
      {"lessonId": "intermediate_013_lesson_008", "title": "Health-Related Speaking Challenges"},
      {"lessonId": "intermediate_013_lesson_009", "title": "Responding to Health Questions"},
      {"lessonId": "intermediate_013_lesson_010", "title": "Reflection: Health Conversations"},
      {"lessonId": "intermediate_013_lesson_011", "title": "Mini-Project: Record Health Interaction"},
      {"lessonId": "intermediate_013_lesson_012", "title": "Final Showcase: Health & Fitness English"},
      {"lessonId": "intermediate_013_lesson_013", "title": "Badge Earned: Health Confident"},
    ],
  },
];
