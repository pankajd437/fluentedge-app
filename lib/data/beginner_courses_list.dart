// lib/data/beginner_courses_list.dart

import 'package:flutter/material.dart';
import 'package:fluentedge_app/constants.dart';

/// Full list of beginner-level courses, refactored to use shared constants
const List<Map<String, dynamic>> beginnerCourses = [
  {
    'courseId': 'beginner_001',
    'title': 'Everyday Conversations: Start Talking from Day One',
    'icon': Icons.chat_bubble_outline,
    'color': kPrimaryBlue,
    'tag': kFreeCourseTag,
    'description':
        'Start speaking immediately with simple, everyday dialogues. No grammar, just practical conversations.',
    'lessons': <Map<String, dynamic>>[
      {
        'lessonId': 'beginner_001_lesson_001',
        'title': 'Welcome & Course Introduction',
        'activities': [
          {
            'type': 'dialogue_reconstruction',
            'messages': [
              {'text': "Hey there! Any tips on starting English?", 'isSender': false},
              {'text': "Sure! Start with short daily dialogues!", 'isSender': true},
              {'text': "Thanks, I'm excited!", 'isSender': false},
            ],
          },
          {
            'type': 'fill_in_the_blanks',
            'sentence': "Hello, could you ______ me find the bus stop?",
            'correctWord': "help",
            'imagePath': "assets/images/help_request_scene_16x9.png",
            'hints': ["Think about a polite request word!"],
            'correctSound': "assets/sounds/correct.mp3",
            'wrongSound': "assets/sounds/incorrect.mp3",
          },
          {
            'type': 'today_vocabulary',
            'vocabItems': [
              {
                'word': "Hello",
                'meaning': "A common greeting",
                'image': "assets/images/greetings_hello.png"
              },
              {
                'word': "Excuse me",
                'meaning': "Polite phrase to get attention",
                'image': "assets/images/excuse_me.png"
              },
            ],
          },
        ],
      },
      {
        'lessonId': 'beginner_001_lesson_002',
        'title': 'Getting Immediate Help in Public',
      },
      {
        'lessonId': 'beginner_001_lesson_003',
        'title': 'Introducing Yourself Confidently',
      },
      {
        'lessonId': 'beginner_001_lesson_004',
        'title': 'Asking Simple Questions',
      },
      {
        'lessonId': 'beginner_001_lesson_005',
        'title': 'Responding Clearly & Politely',
      },
      {
        'lessonId': 'beginner_001_lesson_006',
        'title': 'Making Small Talk That Feels Natural',
      },
      // Removed lesson 7 as requested
      {
        'lessonId': 'beginner_001_lesson_007',
        'title': 'Ordering Food Confidently',
      },
      {
        'lessonId': 'beginner_001_lesson_008',
        'title': 'Asking & Giving Directions Clearly',
      },
      {
        'lessonId': 'beginner_001_lesson_009',
        'title': 'Talking About Family & Where You’re From',
      },
      {
        'lessonId': 'beginner_001_lesson_010',
        'title': 'Describing Your Daily Life',
      },
      {
        'lessonId': 'beginner_001_lesson_011',
        'title': 'Phone & Video Call Basics',
      },
      {
        'lessonId': 'beginner_001_lesson_012',
        'title': 'Speak in Real Life Today! — Confidence Practice Lab',
      },
      {
        'lessonId': 'beginner_001_lesson_013',
        'title': 'Handling Awkward Moments Gracefully',
      },
      {
        'lessonId': 'beginner_001_lesson_014',
        'title': 'When You Don’t Understand Someone',
      },
      {
        'lessonId': 'beginner_001_lesson_015',
        'title': 'Expressing Feelings & Reactions in Conversation',
      },
      {
        'lessonId': 'beginner_001_lesson_016',
        'title': 'Saying Yes, No & Maybe with Confidence',
      },
      {
        'lessonId': 'beginner_001_lesson_017',
        'title': 'English for Festive Wishes & Invitations',
      },
      {
        'lessonId': 'beginner_001_lesson_018',
        'title': 'Your English Journey: Revision & Celebration!',
      },
    ],
  },
  {
    'courseId': 'beginner_002',
    'title': 'English from Zero: Basic Vocabulary & Confidence',
    'icon': Icons.abc,
    'color': Colors.deepPurple,
    'tag': kFreeCourseTag,
    'description':
        'Never learned English before? Start here with basic words, phrases, and confidence boosters.',
    'lessons': <Map<String, dynamic>>[
      {
        'lessonId': 'beginner_002_lesson_001',
        'title': 'Getting Started: No English, No Problem!',
        'activities': [
          {
            'type': 'word_builder',
            'letters': ["H", "E", "L", "P"],
            'correctWord': "HELP",
            'extraLetters': ["A", "S"],
          },
          {
            'type': 'sentence_construction',
            'words': ["Excuse", "me,", "can", "I", "sit?", "please"],
            'correctOrder': ["Excuse", "me,", "can", "I", "sit?", "please"],
            'imagePath': "assets/images/lesson2_drag_drop.png",
          },
        ],
      },
      {'lessonId': 'beginner_002_lesson_002', 'title': 'Basic Words: Things Around You'},
      {'lessonId': 'beginner_002_lesson_003', 'title': 'Useful Everyday Phrases'},
      {'lessonId': 'beginner_002_lesson_004', 'title': 'Making Simple Sentences'},
      {'lessonId': 'beginner_002_lesson_005', 'title': 'Listening & Repeating for Confidence'},
      {'lessonId': 'beginner_002_lesson_006', 'title': 'Role-play: Basic Conversations'},
      {'lessonId': 'beginner_002_lesson_007', 'title': 'Vocabulary Games & Fun Challenges'},
      {'lessonId': 'beginner_002_lesson_008', 'title': 'Speak Up: Daily Speaking Practice'},
      {'lessonId': 'beginner_002_lesson_009', 'title': 'Empathy Checkpoint: Still Hesitant?'},
      {'lessonId': 'beginner_002_lesson_010', 'title': 'Reflection & Confidence Booster'},
      {'lessonId': 'beginner_002_lesson_011', 'title': 'Mini-Project: Vocabulary Journal'},
      {'lessonId': 'beginner_002_lesson_012', 'title': 'Final Showcase: Speak with Confidence'},
      {'lessonId': 'beginner_002_lesson_013', 'title': 'Badge Earned: English from Zero'},
    ],
  },
  {
    'courseId': 'beginner_003',
    'title': 'Family & Home English: Speak Freely at Home',
    'icon': Icons.home_filled,
    'color': Colors.teal,
    'tag': kFreeCourseTag,
    'description':
        'Talk comfortably with family members about daily tasks, feelings, and common home scenarios.',
    'lessons': <Map<String, dynamic>>[
      {
        'lessonId': 'beginner_003_lesson_001',
        'title': 'Course Intro & Family Words',
        'activities': [
          {
            'type': 'mini_stories',
            'scenes': [
              {
                'imagePath': 'assets/images/family_intro_scene.png',
                'text': 'You wake up, greet your family: "Good morning, everyone!"'
              },
              {
                'imagePath': 'assets/images/family_intro_scene2.png',
                'text': 'Your mom asks: "Could you help me with breakfast?"'
              },
            ],
          },
          {
            'type': 'spot_the_error',
            'sentence': "I am make breakfast now.",
            'correctedSentence': "I am making breakfast now.",
            'explanation': "Use the continuous form 'making.'",
            'imagePath': "assets/images/error_scene.png",
          },
        ],
      },
      {'lessonId': 'beginner_003_lesson_002', 'title': 'Talking About Daily Routines'},
      {'lessonId': 'beginner_003_lesson_003', 'title': 'Expressing Feelings at Home'},
      {'lessonId': 'beginner_003_lesson_004', 'title': 'Helping Children with English'},
      {'lessonId': 'beginner_003_lesson_005', 'title': 'Speaking Clearly to Elders'},
      {'lessonId': 'beginner_003_lesson_006', 'title': 'Role-play: Common Home Scenarios'},
      {'lessonId': 'beginner_003_lesson_007', 'title': 'Interactive Speaking Challenges'},
      {'lessonId': 'beginner_003_lesson_008', 'title': 'Empathy Checkpoint: Family Hesitation'},
      {'lessonId': 'beginner_003_lesson_009', 'title': 'Family Vocabulary Games'},
      {'lessonId': 'beginner_003_lesson_010', 'title': 'Reflection & Confidence Building'},
      {'lessonId': 'beginner_003_lesson_011', 'title': 'Mini-Project: Family Conversation Video'},
      {'lessonId': 'beginner_003_lesson_012', 'title': 'Final Showcase: Speak Freely at Home'},
      {'lessonId': 'beginner_003_lesson_013', 'title': 'Badge Earned: Home English Expert'},
    ],
  },
  {
    'courseId': 'beginner_004',
    'title': 'Festivals & Celebrations: Confidently Speak at Any Occasion',
    'icon': Icons.celebration,
    'color': Colors.pinkAccent,
    'tag': kFreeCourseTag,
    'description':
        'Talk confidently during festivals, invite guests, and share rituals clearly in English.',
    'lessons': <Map<String, dynamic>>[
      {
        'lessonId': 'beginner_004_lesson_001',
        'title': 'Welcome to Festival English!',
        'activities': [
          {
            'type': 'dialogue_reconstruction',
            'messages': [
              {'text': "Namaste! Could you come to my Diwali party?", 'isSender': true},
              {'text': "Sure! I'd love to. What time?", 'isSender': false},
              {'text': "7 PM at my home, see you there!", 'isSender': true},
            ],
          },
        ],
      },
      {'lessonId': 'beginner_004_lesson_002', 'title': 'Basic Vocabulary for Celebrations'},
      {'lessonId': 'beginner_004_lesson_003', 'title': 'Inviting Guests & Friends'},
      {'lessonId': 'beginner_004_lesson_004', 'title': 'Explaining Your Traditions Simply'},
      {'lessonId': 'beginner_004_lesson_005', 'title': 'Speaking in Groups & Parties'},
      {'lessonId': 'beginner_004_lesson_006', 'title': 'Interactive Role-play: Family Gatherings'},
      {'lessonId': 'beginner_004_lesson_007', 'title': 'Storytelling: Sharing Festival Memories'},
      {'lessonId': 'beginner_004_lesson_008', 'title': 'Empathy Checkpoint: Overcoming Anxiety'},
      {'lessonId': 'beginner_004_lesson_009', 'title': 'Festival & Celebration Quiz Games'},
      {'lessonId': 'beginner_004_lesson_010', 'title': 'Reflection & Confidence Booster'},
      {'lessonId': 'beginner_004_lesson_011', 'title': 'Mini-Project: Record a Festival Invitation'},
      {'lessonId': 'beginner_004_lesson_012', 'title': 'Final Showcase: Festival Talk'},
      {'lessonId': 'beginner_004_lesson_013', 'title': 'Badge Earned: Festival Speaker'},
    ],
  },
  {
    'courseId': 'beginner_005',
    'title': 'Emergency & Urgent Situations: Get Immediate Help',
    'icon': Icons.emergency,
    'color': Colors.redAccent,
    'tag': kFreeCourseTag,
    'description':
        'Handle urgent situations confidently by clearly communicating emergencies in English.',
    'lessons': <Map<String, dynamic>>[
      {
        'lessonId': 'beginner_005_lesson_001',
        'title': 'Course Introduction & Goals',
        'activities': [
          {
            'type': 'fill_in_the_blanks',
            'sentence': "I need help! My friend is ______ (hurt/safe)?",
            'correctWord': "hurt",
            'imagePath': "assets/images/emergency_scene.png",
          },
        ],
      },
      {'lessonId': 'beginner_005_lesson_002', 'title': 'Key Vocabulary for Emergencies'},
      {'lessonId': 'beginner_005_lesson_003', 'title': 'Calling for Help: Simple & Clear'},
      {'lessonId': 'beginner_005_lesson_004', 'title': 'Explaining Problems Clearly'},
      {'lessonId': 'beginner_005_lesson_005', 'title': 'Listening & Responding Quickly'},
      {'lessonId': 'beginner_005_lesson_006', 'title': 'Role-play: Emergency Scenarios'},
      {'lessonId': 'beginner_005_lesson_007', 'title': 'Interactive Challenge: Urgent Conversations'},
      {'lessonId': 'beginner_005_lesson_008', 'title': 'Empathy Checkpoint: Dealing with Panic'},
      {'lessonId': 'beginner_005_lesson_009', 'title': 'Emergency Vocabulary Games'},
      {'lessonId': 'beginner_005_lesson_010', 'title': 'Reflection & Confidence Check'},
      {'lessonId': 'beginner_005_lesson_011', 'title': 'Mini-Project: Emergency Call Simulation'},
      {'lessonId': 'beginner_005_lesson_012', 'title': 'Final Showcase: Handle Emergencies'},
      {'lessonId': 'beginner_005_lesson_013', 'title': 'Badge Earned: Emergency Ready'},
    ],
  },
  {
    'courseId': 'beginner_006',
    'title': 'School Life Essentials: English for Projects & Friends',
    'icon': Icons.school,
    'color': Colors.green,
    'tag': kFreeCourseTag,
    'description':
        'Communicate clearly with classmates and teachers, and present projects confidently.',
    'lessons': <Map<String, dynamic>>[
      {
        'lessonId': 'beginner_006_lesson_001',
        'title': 'Welcome to School English!',
        'activities': [
          {
            'type': 'today_vocabulary',
            'vocabItems': [
              {
                'word': "Classroom",
                'meaning': "Place where lessons occur",
                'image': "assets/images/classroom.png",
              },
              {
                'word': "Teacher",
                'meaning': "Person who guides students",
                'image': "assets/images/teacher_icon.png",
              },
            ],
          },
        ],
      },
      {'lessonId': 'beginner_006_lesson_002', 'title': 'Basic School Vocabulary'},
      {'lessonId': 'beginner_006_lesson_003', 'title': 'Introducing Yourself at School'},
      {'lessonId': 'beginner_006_lesson_004', 'title': 'Talking with Friends Confidently'},
      {'lessonId': 'beginner_006_lesson_005', 'title': 'Asking Teachers Simple Questions'},
      {'lessonId': 'beginner_006_lesson_006', 'title': 'Presenting Projects Clearly'},
      {'lessonId': 'beginner_006_lesson_007', 'title': 'Role-play: Classroom Scenarios'},
      {'lessonId': 'beginner_006_lesson_008', 'title': 'Interactive Speaking Challenges'},
      {'lessonId': 'beginner_006_lesson_009', 'title': 'Empathy Checkpoint: Overcoming Shyness'},
      {'lessonId': 'beginner_006_lesson_010', 'title': 'School Life Quiz Games'},
      {'lessonId': 'beginner_006_lesson_011', 'title': 'Reflection: Your School English Journey'},
      {'lessonId': 'beginner_006_lesson_012', 'title': 'Mini-Project: Project Presentation'},
      {'lessonId': 'beginner_006_lesson_013', 'title': 'Final Showcase: Speak Confidently at School'},
      {'lessonId': 'beginner_006_lesson_014', 'title': 'Badge Earned: School Star'},
    ],
  },
  {
    'courseId': 'beginner_007',
    'title': 'Travel Basics: Stress-Free Conversations Anywhere',
    'icon': Icons.flight_takeoff,
    'color': kPrimaryBlue,
    'tag': kFreeCourseTag,
    'description':
        'Speak comfortably while travelling—airport, hotel, restaurant—without fear or hesitation.',
    'lessons': <Map<String, dynamic>>[
      {
        'lessonId': 'beginner_007_lesson_001',
        'title': 'Introduction: Travel with Confidence',
        'activities': [
          {
            'type': 'spot_the_error',
            'sentence': "I are looking for the airport gate.",
            'correctedSentence': "I am looking for the airport gate.",
            'explanation': "Use 'am' not 'are' with 'I'.",
            'imagePath': "assets/images/travel_spoterror.png",
          }
        ],
      },
      {'lessonId': 'beginner_007_lesson_002', 'title': 'Key Travel Vocabulary'},
      {'lessonId': 'beginner_007_lesson_003', 'title': 'Basic Conversations at Airport'},
      {'lessonId': 'beginner_007_lesson_004', 'title': 'Checking In: Hotel Dialogues'},
      {'lessonId': 'beginner_007_lesson_005', 'title': 'Ordering Food at Restaurants'},
      {'lessonId': 'beginner_007_lesson_006', 'title': 'Asking for Directions Politely'},
      {'lessonId': 'beginner_007_lesson_007', 'title': 'Interactive Role-play: Tourist & Local'},
      {'lessonId': 'beginner_007_lesson_008', 'title': 'Travel Conversation Games'},
      {'lessonId': 'beginner_007_lesson_009', 'title': 'Empathy Checkpoint: Travel Anxiety'},
      {'lessonId': 'beginner_007_lesson_010', 'title': 'Reflection & Practice: My Travel Diary'},
      {'lessonId': 'beginner_007_lesson_011', 'title': 'Mini-Project: Record a Travel Conversation'},
      {'lessonId': 'beginner_007_lesson_012', 'title': 'Final Showcase: Confident Traveler'},
      {'lessonId': 'beginner_007_lesson_013', 'title': 'Badge Earned: Travel Ready'},
    ],
  },
  {
    'courseId': 'beginner_008',
    'title': 'Phone & Video Call Basics: Talk Without Anxiety',
    'icon': Icons.phone_in_talk,
    'color': Colors.deepPurple,
    'tag': kFreeCourseTag,
    'description':
        'Handle phone and video calls confidently, clearly, and without stress, even if you’re nervous.',
    'lessons': <Map<String, dynamic>>[
      {
        'lessonId': 'beginner_008_lesson_001',
        'title': 'Course Introduction: Calls Made Easy',
        'activities': [
          {
            'type': 'dialogue_reconstruction',
            'messages': [
              {'text': "Hello, can you hear me well?", 'isSender': true},
              {'text': "Yes, loud and clear!", 'isSender': false},
              {'text': "Great, let's start our call!", 'isSender': true},
            ],
          }
        ],
      },
      {'lessonId': 'beginner_008_lesson_002', 'title': 'Essential Call Vocabulary'},
      {'lessonId': 'beginner_008_lesson_003', 'title': 'Answering & Starting Calls'},
      {'lessonId': 'beginner_008_lesson_004', 'title': 'Asking Simple Questions Clearly'},
      {'lessonId': 'beginner_008_lesson_005', 'title': 'Listening & Responding Politely'},
      {'lessonId': 'beginner_008_lesson_006', 'title': 'Ending Conversations Gracefully'},
      {'lessonId': 'beginner_008_lesson_007', 'title': 'Interactive Role-play: Phone Scenarios'},
      {'lessonId': 'beginner_008_lesson_008', 'title': 'Empathy Checkpoint: Overcoming Call Anxiety'},
      {'lessonId': 'beginner_008_lesson_009', 'title': 'Call Conversation Games'},
      {'lessonId': 'beginner_008_lesson_010', 'title': 'Reflection & Confidence Building'},
      {'lessonId': 'beginner_008_lesson_011', 'title': 'Mini-Project: Video Call Simulation'},
      {'lessonId': 'beginner_008_lesson_012', 'title': 'Final Showcase: Confident Caller'},
      {'lessonId': 'beginner_008_lesson_013', 'title': 'Badge Earned: Call Confident'},
    ],
  },
  {
    'courseId': 'beginner_009',
    'title': 'Polite & Respectful Conversations: Master Basic Etiquette',
    'icon': Icons.handshake,
    'color': Colors.orangeAccent,
    'tag': kFreeCourseTag,
    'description':
        'Speak politely and respectfully in everyday scenarios—at home, work, or public places.',
    'lessons': <Map<String, dynamic>>[
      {
        'lessonId': 'beginner_009_lesson_001',
        'title': 'Introduction: Politeness Matters',
        'activities': [
          {
            'type': 'fill_in_the_blanks',
            'sentence': "Could you please ______ me the time?",
            'correctWord': "tell",
            'imagePath': "assets/images/politeness_scene.png",
          }
        ],
      },
      {'lessonId': 'beginner_009_lesson_002', 'title': 'Basic Etiquette Vocabulary'},
      {'lessonId': 'beginner_009_lesson_003', 'title': 'Greeting & Introducing Politely'},
      {'lessonId': 'beginner_009_lesson_004', 'title': 'Saying Please, Thank You & Sorry'},
      {'lessonId': 'beginner_009_lesson_005', 'title': 'Respectful Requests & Replies'},
      {'lessonId': 'beginner_009_lesson_006', 'title': 'Speaking with Elders & Seniors'},
      {'lessonId': 'beginner_009_lesson_007', 'title': 'Role-play: Real-life Polite Conversations'},
      {'lessonId': 'beginner_009_lesson_008', 'title': 'Empathy Checkpoint: Handling Mistakes'},
      {'lessonId': 'beginner_009_lesson_009', 'title': 'Politeness Games & Quizzes'},
      {'lessonId': 'beginner_009_lesson_010', 'title': 'Reflection & Personal Growth'},
      {'lessonId': 'beginner_009_lesson_011', 'title': 'Mini-Project: Polite Conversation Recording'},
      {'lessonId': 'beginner_009_lesson_012', 'title': 'Final Showcase: Polite Talk'},
      {'lessonId': 'beginner_009_lesson_013', 'title': 'Badge Earned: Politeness Pro'},
    ],
  },
  {
    'courseId': 'beginner_010',
    'title': 'Grammar by Usage: Learn Through Speaking',
    'icon': Icons.menu_book,
    'color': Colors.deepOrange,
    'tag': kFreeCourseTag,
    'description':
        'Understand grammar naturally through real-life speaking scenarios, without memorizing rules.',
    'lessons': <Map<String, dynamic>>[
      {
        'lessonId': 'beginner_010_lesson_001',
        'title': 'Introduction: Grammar Naturally',
        'activities': [
          {
            'type': 'spot_the_error',
            'sentence': "She go to market yesterday.",
            'correctedSentence': "She went to market yesterday.",
            'explanation': "Use the past tense 'went' not 'go'.",
            'imagePath': "assets/images/grammar_spoterror.png",
          },
        ],
      },
      {'lessonId': 'beginner_010_lesson_002', 'title': 'Basic Sentence Structures'},
      {'lessonId': 'beginner_010_lesson_003', 'title': 'Everyday Verb Usage'},
      {'lessonId': 'beginner_010_lesson_004', 'title': 'Asking Simple Questions'},
      {'lessonId': 'beginner_010_lesson_005', 'title': 'Using Common Prepositions'},
      {'lessonId': 'beginner_010_lesson_006', 'title': 'Role-play: Grammar in Conversations'},
      {'lessonId': 'beginner_010_lesson_007', 'title': 'Grammar Mistakes & Fixes'},
      {'lessonId': 'beginner_010_lesson_008', 'title': 'Interactive Grammar Games'},
      {'lessonId': 'beginner_010_lesson_009', 'title': 'Empathy Checkpoint: Grammar Anxiety'},
      {'lessonId': 'beginner_010_lesson_010', 'title': 'Reflection: Grammar Confidence'},
      {'lessonId': 'beginner_010_lesson_011', 'title': 'Mini-Project: Record Correct Sentences'},
      {'lessonId': 'beginner_010_lesson_012', 'title': 'Final Showcase: Grammar Mastery'},
      {'lessonId': 'beginner_010_lesson_013', 'title': 'Badge Earned: Grammar Confident'},
    ],
  },
  {
    'courseId': 'beginner_011',
    'title': 'Clear Pronunciation for Beginners: Say It Clearly',
    'icon': Icons.record_voice_over,
    'color': Colors.teal,
    'tag': kFreeCourseTag,
    'description':
        'Improve your pronunciation step-by-step, and speak English words clearly from day one.',
    'lessons': <Map<String, dynamic>>[
      {
        'lessonId': 'beginner_011_lesson_001',
        'title': 'Intro: Pronunciation Basics',
        'activities': [
          {
            'type': 'today_vocabulary',
            'vocabItems': [
              {
                'word': "Pronunciation",
                'meaning': "Way a word is spoken",
                'image': "assets/images/pronunciation_tips.png",
              },
              {
                'word': "Clarity",
                'meaning': "Being understandable",
                'image': "assets/images/clarity_icon.png",
              },
            ],
          },
        ],
      },
      {'lessonId': 'beginner_011_lesson_002', 'title': 'Basic Sounds & Practice'},
      {'lessonId': 'beginner_011_lesson_003', 'title': 'Common Words Pronunciation'},
      {'lessonId': 'beginner_011_lesson_004', 'title': 'Listening & Repeating Exercises'},
      {'lessonId': 'beginner_011_lesson_005', 'title': 'Pronouncing Short Sentences'},
      {'lessonId': 'beginner_011_lesson_006', 'title': 'Role-play: Pronunciation in Daily Life'},
      {'lessonId': 'beginner_011_lesson_007', 'title': 'Common Pronunciation Errors & Fixes'},
      {'lessonId': 'beginner_011_lesson_008', 'title': 'Tongue Twister Fun'},
      {'lessonId': 'beginner_011_lesson_009', 'title': 'Empathy Checkpoint: Overcoming Shyness'},
      {'lessonId': 'beginner_011_lesson_010', 'title': 'Reflection: My Pronunciation Journey'},
      {'lessonId': 'beginner_011_lesson_011', 'title': 'Mini-Project: Record Your Pronunciation'},
      {'lessonId': 'beginner_011_lesson_012', 'title': 'Final Showcase: Confident Pronouncer'},
      {'lessonId': 'beginner_011_lesson_013', 'title': 'Badge Earned: Clear Speaker'},
    ],
  },
  {
    'courseId': 'beginner_012',
    'title': 'Overcoming Stage Fear: Basic Public Speaking',
    'icon': Icons.mic,
    'color': Colors.cyan,
    'tag': kFreeCourseTag,
    'description':
        'Gain basic confidence to speak on stage or in front of small groups, overcoming anxiety step-by-step.',
    'lessons': <Map<String, dynamic>>[
      {
        'lessonId': 'beginner_012_lesson_001',
        'title': 'Introduction: Why Stage Fear?',
        'activities': [
          {
            'type': 'fill_in_the_blanks',
            'sentence':
                "I'm feeling ______ (nervous/brave) about speaking in front of people.",
            'correctWord': "nervous",
            'imagePath': "assets/images/stage_fear_scene.png",
          },
        ],
      },
      {'lessonId': 'beginner_012_lesson_002', 'title': 'Getting Comfortable with Your Voice'},
      {'lessonId': 'beginner_012_lesson_003', 'title': 'Speaking Clearly & Slowly'},
      {'lessonId': 'beginner_012_lesson_004', 'title': 'Short Introduction Speech Practice'},
      {'lessonId': 'beginner_012_lesson_005', 'title': 'Interactive Games: Confidence Boosters'},
      {'lessonId': 'beginner_012_lesson_006', 'title': 'Role-play: My First Speech'},
      {'lessonId': 'beginner_012_lesson_007', 'title': 'Empathy Checkpoint: Handling Fear'},
      {'lessonId': 'beginner_012_lesson_008', 'title': 'Storytelling Basics'},
      {'lessonId': 'beginner_012_lesson_009', 'title': 'Reflection: My Stage Experience'},
      {'lessonId': 'beginner_012_lesson_010', 'title': 'Mini-Project: Record a Short Speech'},
      {'lessonId': 'beginner_012_lesson_011', 'title': 'Final Showcase: First Public Speech'},
      {'lessonId': 'beginner_012_lesson_012', 'title': 'Badge Earned: Stage Fear Overcome'},
    ],
  },
  {
    'courseId': 'beginner_013',
    'title': 'Interview Ready: English for Your First Job',
    'icon': Icons.work_outline,
    'color': Colors.lightGreen,
    'tag': kFreeCourseTag,
    'description':
        'Prepare confidently for your first interview. Learn exactly what to say to get hired.',
    'lessons': <Map<String, dynamic>>[
      {
        'lessonId': 'beginner_013_lesson_001',
        'title': 'Intro: Understanding Interviews',
        'activities': [
          {
            'type': 'sentence_construction',
            'words': ["Tell", "me", "about", "yourself,"],
            'correctOrder': ["Tell", "me", "about", "yourself,"],
          },
        ],
      },
      {'lessonId': 'beginner_013_lesson_002', 'title': 'Common Interview Questions'},
      {'lessonId': 'beginner_013_lesson_003', 'title': 'Giving Clear Answers'},
      {'lessonId': 'beginner_013_lesson_004', 'title': 'Talking About Yourself'},
      {'lessonId': 'beginner_013_lesson_005', 'title': 'Role-play: Interview Practice'},
      {'lessonId': 'beginner_013_lesson_006', 'title': 'Empathy Checkpoint: Interview Anxiety'},
      {'lessonId': 'beginner_013_lesson_007', 'title': 'Confidence-Building Games'},
      {'lessonId': 'beginner_013_lesson_008', 'title': 'Reflection: Preparing Myself'},
      {'lessonId': 'beginner_013_lesson_009', 'title': 'Mini-Project: Record Your Interview'},
      {'lessonId': 'beginner_013_lesson_010', 'title': 'Final Showcase: Mock Interview'},
      {'lessonId': 'beginner_013_lesson_011', 'title': 'Badge Earned: Interview Ready'},
    ],
  },
];
