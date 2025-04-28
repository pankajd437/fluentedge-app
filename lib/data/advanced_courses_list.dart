import 'package:flutter/material.dart';
import 'package:fluentedge_app/constants.dart';

/// Advanced-level courses
final List<Map<String, dynamic>> advancedCourses = [
  {
    'courseId': 'advanced_001',
    'title': 'Advanced Business Communication: Master High-Level English',
    'icon': Icons.business_center,
    'color': Colors.indigo,
    'tag': kPaidCourseTag,
    'description':
        'Master sophisticated English communication for executive roles, strategic meetings, negotiations, and presentations.',
    'lessons': <Map<String, dynamic>>[
      {
        'lessonId': 'advanced_001_lesson_001',
        'title': 'Course Introduction & Goals',
        // NEW: demonstration of "dialogue_reconstruction"
        'lessonActivities': [
          {
            'type': 'dialogue_reconstruction',
            'messages': [
              {'text': "Welcome, let's discuss your executive goals.", 'isSender': true},
              {'text': "Sure, I'm aiming to polish my communication for board meetings.", 'isSender': false},
              {'text': "Great! We'll focus on persuasive language and clarity.", 'isSender': true},
            ],
          }
        ],
      },
      {'lessonId': 'advanced_001_lesson_002', 'title': 'Executive Vocabulary & Phrases'},
      {'lessonId': 'advanced_001_lesson_003', 'title': 'High-level Meeting Communication'},
      {'lessonId': 'advanced_001_lesson_004', 'title': 'Persuasive Presentations'},
      {'lessonId': 'advanced_001_lesson_005', 'title': 'Advanced Negotiation Techniques'},
      {'lessonId': 'advanced_001_lesson_006', 'title': 'Strategic Email & Written Communication'},
      {'lessonId': 'advanced_001_lesson_007', 'title': 'Role-play: Executive Scenarios'},
      {'lessonId': 'advanced_001_lesson_008', 'title': 'Empathy Checkpoint: High-pressure Situations'},
      {'lessonId': 'advanced_001_lesson_009', 'title': 'Handling Difficult Conversations'},
      {'lessonId': 'advanced_001_lesson_010', 'title': 'Reflection: Executive Communication'},
      {'lessonId': 'advanced_001_lesson_011', 'title': 'Mini-Project: Strategic Presentation'},
      {'lessonId': 'advanced_001_lesson_012', 'title': 'Final Showcase: Master Communicator'},
      {'lessonId': 'advanced_001_lesson_013', 'title': 'Badge Earned: Executive Communicator'},
    ],
  },
  {
    'courseId': 'advanced_002',
    'title': 'English for Leadership: Influence & Inspire Clearly',
    'icon': Icons.leaderboard,
    'color': Colors.deepPurple,
    'tag': kPaidCourseTag,
    'description':
        'Enhance leadership communication, persuasive speaking, and influential techniques for managers.',
    'lessons': <Map<String, dynamic>>[
      {
        'lessonId': 'advanced_002_lesson_001',
        'title': "Course Intro: Leader's Voice",
        // NEW: demonstration of "fill_in_the_blanks"
        'lessonActivities': [
          {
            'type': 'fill_in_the_blanks',
            'sentence': "I want to ______ (motivate/demotivate) my team effectively.",
            'correctWord': "motivate",
            'imagePath': "assets/images/leadership_scene.png",
            'correctSound': "assets/sounds/correct.mp3",
            'wrongSound': "assets/sounds/incorrect.mp3",
          }
        ],
      },
      {'lessonId': 'advanced_002_lesson_002', 'title': 'Leadership Vocabulary Mastery'},
      {'lessonId': 'advanced_002_lesson_003', 'title': 'Persuasive Speaking Techniques'},
      {'lessonId': 'advanced_002_lesson_004', 'title': 'Influencing & Inspiring Teams'},
      {'lessonId': 'advanced_002_lesson_005', 'title': 'Clear Communication of Vision'},
      {'lessonId': 'advanced_002_lesson_006', 'title': 'Role-play: Leading Meetings'},
      {'lessonId': 'advanced_002_lesson_007', 'title': 'Handling Leadership Challenges'},
      {'lessonId': 'advanced_002_lesson_008', 'title': 'Empathy Checkpoint: Leadership Pressure'},
      {'lessonId': 'advanced_002_lesson_009', 'title': 'Storytelling for Influence'},
      {'lessonId': 'advanced_002_lesson_010', 'title': 'Reflection: Leadership Growth'},
      {'lessonId': 'advanced_002_lesson_011', 'title': 'Mini-Project: Inspire through Speech'},
      {'lessonId': 'advanced_002_lesson_012', 'title': 'Final Showcase: Inspiring Leader'},
      {'lessonId': 'advanced_002_lesson_013', 'title': 'Badge Earned: Influential Leader'},
    ],
  },
  {
    'courseId': 'advanced_003',
    'title': 'Advanced Grammar & Writing: Refine Professional English',
    'icon': Icons.edit,
    'color': Colors.blueGrey,
    'tag': kPaidCourseTag,
    'description':
        'Perfect your grammar and professional writing skills through practical business scenarios.',
    'lessons': <Map<String, dynamic>>[
      {
        'lessonId': 'advanced_003_lesson_001',
        'title': 'Intro: Grammar for Professionals',
        // NEW: demonstration of "sentence_construction"
        'lessonActivities': [
          {
            'type': 'sentence_construction',
            'words': ["Please", "review", "the", "attached", "document."],
            'correctOrder': ["Please", "review", "the", "attached", "document."],
            'imagePath': "assets/images/business_writing_scene.png",
          }
        ],
      },
      {'lessonId': 'advanced_003_lesson_002', 'title': 'Complex Sentence Structures'},
      {'lessonId': 'advanced_003_lesson_003', 'title': 'Common Advanced Errors & Fixes'},
      {'lessonId': 'advanced_003_lesson_004', 'title': 'Writing Reports & Proposals'},
      {'lessonId': 'advanced_003_lesson_005', 'title': 'Advanced Email Writing Skills'},
      {'lessonId': 'advanced_003_lesson_006', 'title': 'Role-play: Editing & Proofreading'},
      {'lessonId': 'advanced_003_lesson_007', 'title': 'Empathy Checkpoint: Writing Confidence'},
      {'lessonId': 'advanced_003_lesson_008', 'title': 'Practical Grammar Challenges'},
      {'lessonId': 'advanced_003_lesson_009', 'title': 'Formal & Informal Tone Usage'},
      {'lessonId': 'advanced_003_lesson_010', 'title': 'Reflection: Grammar Mastery'},
      {'lessonId': 'advanced_003_lesson_011', 'title': 'Mini-Project: Publish a Professional Article'},
      {'lessonId': 'advanced_003_lesson_012', 'title': 'Final Showcase: Writing Excellence'},
      {'lessonId': 'advanced_003_lesson_013', 'title': 'Badge Earned: Grammar Expert'},
    ],
  },
  {
    'courseId': 'advanced_004',
    'title': 'Accent Reduction & Pronunciation Mastery',
    'icon': Icons.record_voice_over,
    'color': Colors.teal,
    'tag': kPaidCourseTag,
    'description':
        'Achieve clear, natural fluency by mastering advanced accent reduction techniques.',
    'lessons': <Map<String, dynamic>>[
      {
        'lessonId': 'advanced_004_lesson_001',
        'title': 'Course Intro: Accent & Identity',
        // NEW: demonstration of "word_builder"
        'lessonActivities': [
          {
            'type': 'word_builder',
            'letters': ["F", "L", "U", "E", "N", "C", "Y"],
            'correctWord': "FLUENCY",
            'extraLetters': ["X", "Z"],
          }
        ],
      },
      {'lessonId': 'advanced_004_lesson_002', 'title': 'Identifying Pronunciation Habits'},
      {'lessonId': 'advanced_004_lesson_003', 'title': 'Mastering Challenging Sounds'},
      {'lessonId': 'advanced_004_lesson_004', 'title': 'Natural Intonation Patterns'},
      {'lessonId': 'advanced_004_lesson_005', 'title': 'Accent Reduction Exercises'},
      {'lessonId': 'advanced_004_lesson_006', 'title': 'Interactive Pronunciation Drills'},
      {'lessonId': 'advanced_004_lesson_007', 'title': 'Role-play: Real-world Pronunciation'},
      {'lessonId': 'advanced_004_lesson_008', 'title': 'Empathy Checkpoint: Accent Anxiety'},
      {'lessonId': 'advanced_004_lesson_009', 'title': 'Listening & Mimicking Native Speakers'},
      {'lessonId': 'advanced_004_lesson_010', 'title': 'Reflection: Pronunciation Confidence'},
      {'lessonId': 'advanced_004_lesson_011', 'title': 'Mini-Project: Pronunciation Improvement'},
      {'lessonId': 'advanced_004_lesson_012', 'title': 'Final Showcase: Clear Speaker'},
      {'lessonId': 'advanced_004_lesson_013', 'title': 'Badge Earned: Pronunciation Master'},
    ],
  },
  {
    'courseId': 'advanced_005',
    'title': 'Diplomatic & Formal English: Expert Communication',
    'icon': Icons.account_balance,
    'color': Colors.amber,
    'tag': kPaidCourseTag,
    'description':
        'Excel in diplomatic, governmental, and formal international communication with precision.',
    'lessons': <Map<String, dynamic>>[
      {
        'lessonId': 'advanced_005_lesson_001',
        'title': 'Intro: Formal Communication Essentials',
        // NEW: demonstration of "mini_stories"
        'lessonActivities': [
          {
            'type': 'mini_stories',
            'scenes': [
              {
                'imagePath': 'assets/images/diplomatic_scene1.png',
                'text': "A foreign delegate arrives for negotiations. You greet them formally."
              },
              {
                'imagePath': 'assets/images/diplomatic_scene2.png',
                'text': "You present your agenda politely, ensuring respectful tone throughout."
              },
            ],
          }
        ],
      },
      {'lessonId': 'advanced_005_lesson_002', 'title': 'Diplomatic Vocabulary & Expressions'},
      {'lessonId': 'advanced_005_lesson_003', 'title': 'Formal Correspondence Mastery'},
      {'lessonId': 'advanced_005_lesson_004', 'title': 'Handling Diplomatic Conversations'},
      {'lessonId': 'advanced_005_lesson_005', 'title': 'Speech Writing for Diplomats'},
      {'lessonId': 'advanced_005_lesson_006', 'title': 'Role-play: Formal Meetings & Protocols'},
      {'lessonId': 'advanced_005_lesson_007', 'title': 'Crisis Communication Clearly'},
      {'lessonId': 'advanced_005_lesson_008', 'title': 'Empathy Checkpoint: Pressure Situations'},
      {'lessonId': 'advanced_005_lesson_009', 'title': 'Cross-cultural Formality'},
      {'lessonId': 'advanced_005_lesson_010', 'title': 'Reflection: Diplomatic Skills'},
      {'lessonId': 'advanced_005_lesson_011', 'title': 'Mini-Project: Formal Presentation'},
      {'lessonId': 'advanced_005_lesson_012', 'title': 'Final Showcase: Diplomatic Speaker'},
      {'lessonId': 'advanced_005_lesson_013', 'title': 'Badge Earned: Formal Expert'},
    ],
  },
  {
    'courseId': 'advanced_006',
    'title': 'Public Speaking Masterclass: Speak & Present Like a Pro',
    'icon': Icons.mic_external_on,
    'color': Colors.deepOrangeAccent,
    'tag': kPaidCourseTag,
    'description':
        'Master advanced public speaking, storytelling strategies, and impactful presentations for large audiences.',
    'lessons': <Map<String, dynamic>>[
      {
        'lessonId': 'advanced_006_lesson_001',
        'title': 'Course Introduction: Speaking Excellence',
        // NEW: demonstration of "spot_the_error"
        'lessonActivities': [
          {
            'type': 'spot_the_error',
            'sentence': "I has prepared an amazing speech.",
            'correctedSentence': "I have prepared an amazing speech.",
            'explanation': "Use 'have' with 'I' not 'has'.",
            'imagePath': "assets/images/public_speaking_error.png",
          }
        ],
      },
      {'lessonId': 'advanced_006_lesson_002', 'title': 'Crafting Compelling Stories'},
      {'lessonId': 'advanced_006_lesson_003', 'title': 'Advanced Speech Structuring'},
      {'lessonId': 'advanced_006_lesson_004', 'title': 'Audience Engagement Techniques'},
      {'lessonId': 'advanced_006_lesson_005', 'title': 'Handling Q&A Sessions Expertly'},
      {'lessonId': 'advanced_006_lesson_006', 'title': 'Voice & Stage Presence Mastery'},
      {'lessonId': 'advanced_006_lesson_007', 'title': 'Role-play: Large Audience Speeches'},
      {'lessonId': 'advanced_006_lesson_008', 'title': 'Empathy Checkpoint: Overcoming Stage Fear'},
      {'lessonId': 'advanced_006_lesson_009', 'title': 'Advanced Rhetorical Techniques'},
      {'lessonId': 'advanced_006_lesson_010', 'title': 'Reflection: Speaking Journey'},
      {'lessonId': 'advanced_006_lesson_011', 'title': 'Mini-Project: TED-style Presentation'},
      {'lessonId': 'advanced_006_lesson_012', 'title': 'Final Showcase: Professional Speaker'},
      {'lessonId': 'advanced_006_lesson_013', 'title': 'Badge Earned: Master Speaker'},
    ],
  },
  {
    'courseId': 'advanced_007',
    'title': 'Advanced English Fluency Challenge: Native-like Conversations',
    'icon': Icons.forum,
    'color': Colors.greenAccent,
    'tag': kPaidCourseTag,
    'description':
        'Achieve native-like fluency, idiomatic expression, and conversational sophistication through intensive practice.',
    'lessons': <Map<String, dynamic>>[
      {
        'lessonId': 'advanced_007_lesson_001',
        'title': 'Intro: Path to Native Fluency',
        // NEW: demonstration of "today_vocabulary"
        'lessonActivities': [
          {
            'type': 'today_vocabulary',
            'vocabItems': [
              {
                'word': "Idiomatic",
                'meaning': "Using expressions natural to native speakers",
                'image': "assets/images/idiomatic_expressions.png",
              },
              {
                'word': "Sophistication",
                'meaning': "Refined complexity in language",
                'image': "assets/images/sophistication_icon.png",
              },
            ],
          },
        ],
      },
      {'lessonId': 'advanced_007_lesson_002', 'title': 'Idiomatic Expressions & Usage'},
      {'lessonId': 'advanced_007_lesson_003', 'title': 'Complex Conversation Practice'},
      {'lessonId': 'advanced_007_lesson_004', 'title': 'Understanding Cultural References'},
      {'lessonId': 'advanced_007_lesson_005', 'title': 'Interactive Role-play: Advanced Dialogues'},
      {'lessonId': 'advanced_007_lesson_006', 'title': 'Real-time Conversation Challenges'},
      {'lessonId': 'advanced_007_lesson_007', 'title': 'Empathy Checkpoint: Fluency Plateau'},
      {'lessonId': 'advanced_007_lesson_008', 'title': 'Listening & Mimicking Native Speech'},
      {'lessonId': 'advanced_007_lesson_009', 'title': 'Debate & Persuasive Arguments'},
      {'lessonId': 'advanced_007_lesson_010', 'title': 'Reflection: Fluency Achievements'},
      {'lessonId': 'advanced_007_lesson_011', 'title': 'Mini-Project: Podcast Episode Creation'},
      {'lessonId': 'advanced_007_lesson_012', 'title': 'Final Showcase: Native-like Fluency'},
      {'lessonId': 'advanced_007_lesson_013', 'title': 'Badge Earned: Fluent Speaker'},
    ],
  },
  {
    'courseId': 'advanced_008',
    'title': 'Professional Networking & Relationship Building in English',
    'icon': Icons.connect_without_contact,
    'color': Colors.cyan,
    'tag': kPaidCourseTag,
    'description':
        'Master advanced networking and relationship management conversations essential for professional growth.',
    'lessons': <Map<String, dynamic>>[
      {
        'lessonId': 'advanced_008_lesson_001',
        'title': 'Course Intro: Networking Essentials',
        // NEW: demonstration of "dialogue_reconstruction"
        'lessonActivities': [
          {
            'type': 'dialogue_reconstruction',
            'messages': [
              {'text': "Hi, I saw your profile. I'd love to connect about marketing ideas.", 'isSender': true},
              {'text': "Sure, let's chat. I'm open to new collaboration opportunities!", 'isSender': false},
              {'text': "Perfect, let's schedule a quick call soon.", 'isSender': true},
            ],
          }
        ],
      },
      {'lessonId': 'advanced_008_lesson_002', 'title': 'Making Professional Introductions'},
      {'lessonId': 'advanced_008_lesson_003', 'title': 'Effective Follow-up Communication'},
      {'lessonId': 'advanced_008_lesson_004', 'title': 'Maintaining Professional Relationships'},
      {'lessonId': 'advanced_008_lesson_005', 'title': 'Interactive Role-play: Networking Events'},
      {'lessonId': 'advanced_008_lesson_006', 'title': 'Empathy Checkpoint: Networking Anxiety'},
      {'lessonId': 'advanced_008_lesson_007', 'title': 'Leveraging LinkedIn Effectively'},
      {'lessonId': 'advanced_008_lesson_008', 'title': 'Networking across Cultures'},
      {'lessonId': 'advanced_008_lesson_009', 'title': 'Reflection: Networking Impact'},
      {'lessonId': 'advanced_008_lesson_010', 'title': 'Mini-Project: Record Networking Conversations'},
      {'lessonId': 'advanced_008_lesson_011', 'title': 'Final Showcase: Networker Extraordinaire'},
      {'lessonId': 'advanced_008_lesson_012', 'title': 'Badge Earned: Professional Networker'},
    ],
  },
  {
    'courseId': 'advanced_009',
    'title': 'Technical & Industry-specific English: Communicate Like an Expert',
    'icon': Icons.precision_manufacturing,
    'color': Colors.deepPurpleAccent,
    'tag': kPaidCourseTag,
    'description':
        'Master specialized vocabulary and advanced communication skills tailored for tech, finance, healthcare, and law.',
    'lessons': <Map<String, dynamic>>[
      {
        'lessonId': 'advanced_009_lesson_001',
        'title': 'Intro: Industry-specific Language',
        // NEW: demonstration of "fill_in_the_blanks"
        'lessonActivities': [
          {
            'type': 'fill_in_the_blanks',
            'sentence': "We're analyzing ______ (data/music) for this project.",
            'correctWord': "data",
            'imagePath': "assets/images/tech_scene.png",
          }
        ],
      },
      {'lessonId': 'advanced_009_lesson_002', 'title': 'Tech Industry Communication'},
      {'lessonId': 'advanced_009_lesson_003', 'title': 'Financial Terminology & Usage'},
      {'lessonId': 'advanced_009_lesson_004', 'title': 'Healthcare Professional Conversations'},
      {'lessonId': 'advanced_009_lesson_005', 'title': 'Legal English Mastery'},
      {'lessonId': 'advanced_009_lesson_006', 'title': 'Interactive Role-play: Specialized Situations'},
      {'lessonId': 'advanced_009_lesson_007', 'title': 'Empathy Checkpoint: Communication Barriers'},
      {'lessonId': 'advanced_009_lesson_008', 'title': 'Cross-disciplinary Discussions'},
      {'lessonId': 'advanced_009_lesson_009', 'title': 'Reflection: Specialized Fluency'},
      {'lessonId': 'advanced_009_lesson_010', 'title': 'Mini-Project: Technical Presentation'},
      {'lessonId': 'advanced_009_lesson_011', 'title': 'Final Showcase: Industry Expert'},
      {'lessonId': 'advanced_009_lesson_012', 'title': 'Badge Earned: Technical Communicator'},
    ],
  },
  {
    'courseId': 'advanced_010',
    'title': 'Advanced English for Negotiations & Conflict Resolution',
    'icon': Icons.gavel,
    'color': Colors.orange,
    'tag': kPaidCourseTag,
    'description':
        'Master sophisticated language for negotiations, persuasive arguments, and effectively resolving conflicts.',
    'lessons': <Map<String, dynamic>>[
      {
        'lessonId': 'advanced_010_lesson_001',
        'title': 'Introduction: Mastering Negotiations',
        // NEW: demonstration of "sentence_construction"
        'lessonActivities': [
          {
            'type': 'sentence_construction',
            'words': ["We", "need", "to", "reach", "a", "mutual", "agreement."],
            'correctOrder': ["We", "need", "to", "reach", "a", "mutual", "agreement."],
            'imagePath': "assets/images/negotiation_scene.png",
          },
        ],
      },
      {'lessonId': 'advanced_010_lesson_002', 'title': 'Persuasive Language Techniques'},
      {'lessonId': 'advanced_010_lesson_003', 'title': 'Negotiation Strategies & Vocabulary'},
      {'lessonId': 'advanced_010_lesson_004', 'title': 'Conflict Resolution Essentials'},
      {'lessonId': 'advanced_010_lesson_005', 'title': 'Role-play: High-stakes Negotiations'},
      {'lessonId': 'advanced_010_lesson_006', 'title': 'Handling Objections & Counteroffers'},
      {'lessonId': 'advanced_010_lesson_007', 'title': 'Advanced Argumentation Skills'},
      {'lessonId': 'advanced_010_lesson_008', 'title': 'Empathy Checkpoint: Managing Conflicts'},
      {'lessonId': 'advanced_010_lesson_009', 'title': 'Listening & Understanding Perspectives'},
      {'lessonId': 'advanced_010_lesson_010', 'title': 'Mini-Project: Recorded Negotiation Session'},
      {'lessonId': 'advanced_010_lesson_011', 'title': 'Reflection: Negotiation Mastery'},
      {'lessonId': 'advanced_010_lesson_012', 'title': 'Final Showcase: Skilled Negotiator'},
      {'lessonId': 'advanced_010_lesson_013', 'title': 'Badge Earned: Negotiation Expert'},
    ],
  },
  {
    'courseId': 'advanced_011',
    'title': 'Cross-cultural Communication: Global English Fluency',
    'icon': Icons.public,
    'color': Colors.lightBlueAccent,
    'tag': kPaidCourseTag,
    'description':
        'Achieve fluency and confidence navigating global conversations, cultural nuances, and international etiquette.',
    'lessons': <Map<String, dynamic>>[
      {
        'lessonId': 'advanced_011_lesson_001',
        'title': 'Course Introduction: Cultural Fluency',
        // NEW: demonstration of "word_builder"
        'lessonActivities': [
          {
            'type': 'word_builder',
            'letters': ["C", "U", "L", "T", "U", "R", "E"],
            'correctWord': "CULTURE",
            'extraLetters': ["Q", "Y"],
          },
        ],
      },
      {'lessonId': 'advanced_011_lesson_002', 'title': 'Understanding Cultural Differences'},
      {'lessonId': 'advanced_011_lesson_003', 'title': 'Global Etiquette & Manners'},
      {'lessonId': 'advanced_011_lesson_004', 'title': 'Handling Cultural Misunderstandings'},
      {'lessonId': 'advanced_011_lesson_005', 'title': 'Interactive Role-play: Global Meetings'},
      {'lessonId': 'advanced_011_lesson_006', 'title': 'Cross-cultural Negotiations'},
      {'lessonId': 'advanced_011_lesson_007', 'title': 'Effective International Communication'},
      {'lessonId': 'advanced_011_lesson_008', 'title': 'Empathy Checkpoint: Cultural Anxiety'},
      {'lessonId': 'advanced_011_lesson_009', 'title': 'Adapting Speech Across Cultures'},
      {'lessonId': 'advanced_011_lesson_010', 'title': 'Mini-Project: International Dialogue Recording'},
      {'lessonId': 'advanced_011_lesson_011', 'title': 'Reflection: Cross-cultural Skills'},
      {'lessonId': 'advanced_011_lesson_012', 'title': 'Final Showcase: Global Communicator'},
      {'lessonId': 'advanced_011_lesson_013', 'title': 'Badge Earned: Cross-cultural Expert'},
    ],
  },
  {
    'courseId': 'advanced_012',
    'title': 'Media & Public Relations English: Expert-level Clarity',
    'icon': Icons.campaign,
    'color': Colors.pinkAccent,
    'tag': kPaidCourseTag,
    'description':
        'Advanced skills for media interactions, press releases, crisis management, and public relations.',
    'lessons': <Map<String, dynamic>>[
      {
        'lessonId': 'advanced_012_lesson_001',
        'title': 'Intro: Navigating Media Relations',
        // NEW: demonstration of "mini_stories"
        'lessonActivities': [
          {
            'type': 'mini_stories',
            'scenes': [
              {
                'imagePath': 'assets/images/media_briefing1.png',
                'text': "Your company is facing a minor crisis. You prepare a calm press statement."
              },
              {
                'imagePath': 'assets/images/media_briefing2.png',
                'text': "During the Q&A, you handle tough questions confidently, no panic."
              },
            ],
          }
        ],
      },
      {'lessonId': 'advanced_012_lesson_002', 'title': 'Crafting Press Releases'},
      {'lessonId': 'advanced_012_lesson_003', 'title': 'Managing Media Interviews'},
      {'lessonId': 'advanced_012_lesson_004', 'title': 'Handling Crisis Communications'},
      {'lessonId': 'advanced_012_lesson_005', 'title': 'Role-play: Press Conference Scenarios'},
      {'lessonId': 'advanced_012_lesson_006', 'title': 'Advanced Messaging & Clarity'},
      {'lessonId': 'advanced_012_lesson_007', 'title': 'Interactive Exercise: Responding Under Pressure'},
      {'lessonId': 'advanced_012_lesson_008', 'title': 'Empathy Checkpoint: Managing Reputation'},
      {'lessonId': 'advanced_012_lesson_009', 'title': 'Social Media & Online Presence Management'},
      {'lessonId': 'advanced_012_lesson_010', 'title': 'Mini-Project: Mock Media Interview'},
      {'lessonId': 'advanced_012_lesson_011', 'title': 'Reflection: Media Skills Enhancement'},
      {'lessonId': 'advanced_012_lesson_012', 'title': 'Final Showcase: PR & Media Expert'},
      {'lessonId': 'advanced_012_lesson_013', 'title': 'Badge Earned: Media Savvy'},
    ],
  },
  {
    'courseId': 'advanced_013',
    'title': 'Executive English Coaching: Mastering Boardroom Communication',
    'icon': Icons.business_center,
    'color': Colors.grey,
    'tag': kPaidCourseTag,
    'description':
        'High-level coaching to master executive and boardroom communication with stakeholders and strategic partners.',
    'lessons': <Map<String, dynamic>>[
      {
        'lessonId': 'advanced_013_lesson_001',
        'title': 'Course Intro: Executive Communication',
        // NEW: demonstration of "spot_the_error"
        'lessonActivities': [
          {
            'type': 'spot_the_error',
            'sentence': "We was planning the merger details.",
            'correctedSentence': "We were planning the merger details.",
            'explanation': "Use 'were' with 'we' not 'was'.",
            'imagePath': "assets/images/boardroom_error.png",
          }
        ],
      },
      {'lessonId': 'advanced_013_lesson_002', 'title': 'Boardroom Language Essentials'},
      {'lessonId': 'advanced_013_lesson_003', 'title': 'Persuasive Stakeholder Presentations'},
      {'lessonId': 'advanced_013_lesson_004', 'title': 'Strategic Discussion Facilitation'},
      {'lessonId': 'advanced_013_lesson_005', 'title': 'Interactive Role-play: Executive Meetings'},
      {'lessonId': 'advanced_013_lesson_006', 'title': 'Handling High-pressure Situations'},
      {'lessonId': 'advanced_013_lesson_007', 'title': 'Advanced Negotiation Tactics'},
      {'lessonId': 'advanced_013_lesson_008', 'title': 'Empathy Checkpoint: Executive-level Anxiety'},
      {'lessonId': 'advanced_013_lesson_009', 'title': 'Influential Leadership Language'},
      {'lessonId': 'advanced_013_lesson_010', 'title': 'Mini-Project: Boardroom Presentation'},
      {'lessonId': 'advanced_013_lesson_011', 'title': 'Reflection: Executive Communication Growth'},
      {'lessonId': 'advanced_013_lesson_012', 'title': 'Final Showcase: Boardroom Mastery'},
      {'lessonId': 'advanced_013_lesson_013', 'title': 'Badge Earned: Executive Communicator'},
    ],
  },
];
