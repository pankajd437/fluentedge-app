const Map<String, dynamic> beginner001Lesson001 = {
  "lessonId": "beginner_001_lesson_001",
  "title": "Welcome & Course Introduction",
  "level": "beginner",
  "themeColor": "#4A90E2",
  "xpTotal": 400,
  "objectives": [
    "Ask strangers for help in English with confidence",
    "Balance politeness and directness without sounding rude",
    "Blend short Hindi touches for comfort",
    "Feel calmer when stuck in unfamiliar places"
  ],
  "mentorDefaults": {
    "expression": "mentor_tip_upper.png",
    "voiceLangs": ["en", "hi"],
    "typingIndicator": "assets/lottie/typing_indicator_dots.json"
  },
  "badgeAwarded": {
    "id": "help_seeker_hero",
    "title": "Help Seeker Hero",
    "animation": "assets/lottie/badge-unlocked.json"
  },
  "activities": [
    {
      "type": "mentor_intro",
      "text": "नमस्ते and Welcome! आज हम सीखेंगे help माँगना, बिना awkward महसूस किए। इस lesson के अंत में, आप confidently बोल पाओगे “Excuse me…” बिना डर, बिना टेंशन के!",
      "imagePath": "assets/images/lesson1_course_intro.png"
    },
    {
      "type": "scene_image",
      "caption": "Imagine: आप एक बड़े station में हो, हर कोई busy दिख रहा है —और आप बाहर जाने का रास्ता ढूँढ रहे हो। चाहे आप थोड़ा lost महसूस करो, पर हम politely strangers से रास्ता पूछ सकते हैं!",
      "imagePath": "assets/images/lesson1_big_station_16x9.png"
    },
    {
      "type": "mentor_explain",
      "text": "हमारा main goal: short, polite phrases use करना, जो लोगों से quick help दिलाए। Fancy grammar छोड़ दो — tone और smile is enough!"
    },
    {
      "type": "today_vocabulary",
      "vocabItems": [
        {
          "word": "Excuse me",
          "meaning": "Polite phrase to get attention, like ‘माफ कीजिए’ but English version.",
          "image": "assets/images/excuse_me.png"
        },
        {
          "word": "Lost",
          "meaning": "When you can’t find your way (e.g., 'मुझे रास्ता नहीं पता').",
          "image": "assets/images/lost_sign.png"
        },
        {
          "word": "Guide",
          "meaning": "To show or direct someone to a place or solution.",
          "image": "assets/images/guide_icon.png"
        }
      ]
    },
    {
      "type": "mentor_explain",
      "text": "ये words याद कर लो: ‘Excuse me’ (attention), ‘lost’ (confusion), और ‘guide’ (show way). Tone is must! अब एक fill-in-the-blank try करें?"
    },
    {
      "type": "fill_in_the_blanks",
      "sentence": "Excuse me, मैं थोड़ा ______ हूँ। Could you guide me, please?",
      "correctWord": "lost",
      "imagePath": "assets/images/help_request_scene_16x9.png",
      "hints": [
        "Hindi clue: 'मुझे रास्ता नहीं पता!'",
        "English clue: Means you can’t find your way"
      ],
      "correctSound": "assets/sounds/correct.mp3",
      "wrongSound": "assets/sounds/incorrect.mp3",
      "correctLottie": "assets/animations/activity_correct.json",
      "wrongLottie": "assets/animations/activity_wrong.json",
      "submitLabel": "Check Answer",
      "feedback": {
        "correctText": "Perfect! ‘Lost’ बोलने से लोग समझ जाएंगे आपको direction चाहिए!",
        "wrongText": "Close! Correct word is ‘lost’—याद रखो, मतलब no idea about the route."
      }
    },
    {
      "type": "mentor_explain",
      "text": "देखा ना, small & polite requests कितने काम आते हैं. अब हम एक और short question try करते हैं!"
    },
    {
      "type": "fill_in_the_blanks",
      "sentence": "Excuse me, can you _____ (help/ignore) me find the ticket counter?",
      "correctWord": "help",
      "imagePath": "assets/images/lesson1_confident_pose_16x9.png",
      "hints": [
        "Polite request के लिए help word best है",
        "Opposite is ignore—वो तो हम चाहते ही नहीं!"
      ],
      "correctSound": "assets/sounds/correct.mp3",
      "wrongSound": "assets/sounds/incorrect.mp3",
      "correctLottie": "assets/animations/activity_correct.json",
      "wrongLottie": "assets/animations/activity_wrong.json",
      "submitLabel": "Check Answer",
      "feedback": {
        "correctText": "Yes! ‘Help’ is correct. Polite तरीके से request करो.",
        "wrongText": "Nope—‘ignore’ क्यों होगा? हमें तो उनकी मदद चाहिए."
      }
    },
    {
      "type": "mentor_explain",
      "text": "देखा ना, small & polite requests कितने काम आते हैं. अब हम dialogue chat पर चलते हैं!"
    },
    {
      "type": "dialogue_reconstruction",
      "contextTitle": "आप अपने दोस्त से help माँग रहे हो station पर",
      "messages": [
        {
          "text": "Hey, मैं station पर हूँ पर exit नहीं मिल रहा. क्या तुम मेरी help कर सकते हो?",
          "isSender": true,
          "avatarPath": "assets/images/chat_user_pink.png"
        },
        {
          "text": "Of course! Just check the station map or politely ask a staff member.",
          "isSender": false,
          "avatarPath": "assets/images/chat_friend_blue.png"
        },
        {
          "text": "Thanks! बिना hesitation के, ‘Excuse me…’ से start करता हूँ!",
          "isSender": true,
          "avatarPath": "assets/images/chat_user_pink.png"
        }
      ],
      "visualDesignHint": "Glowing chat bubble style for an immersive experience",
      "learningTakeaway": "Friendly chat can remind you: politely approach staff with short lines & calm tone."
    },
    {
      "type": "mentor_explain",
      "text": "याद रखो, real life conversation में politeness ही सबसे ज़्यादा matter करती है! Let’s fix a short error next."
    },
    {
      "type": "spot_the_error",
      "instruction": "Spot the rude or inappropriate phrase:",
      "originalSentence": "I need help, come here now!",
      "choices": ["I", "need", "help,", "come", "here", "now!"],
      "correctChoiceIndex": 5,
      "explanation": "Saying 'now!' rudely sounds demanding. Always request politely, like 'Could you please help me?' instead of shouting.",
      "imagePath": "assets/images/lesson1_rude_request_16x9.png"
    },
    {
      "type": "mentor_explain",
      "text": "Awesome. Politeness के साथ थोड़ा correct order of approach से बहुत help मिलती है!"
    },
    {
      "type": "fill_in_the_blanks",
      "sentence": "I feel ______ (nervous/confident) asking for help from strangers.",
      "correctWord": "nervous",
      "imagePath": "assets/images/lesson1_nervous_thoughts_16x9.png",
      "hints": [
        "Beginner stage पर आप confident कम, nervous ज़्यादा होते हो",
        "English में 'anxious' or 'nervous' is typical"
      ],
      "correctSound": "assets/sounds/correct.mp3",
      "wrongSound": "assets/sounds/incorrect.mp3",
      "correctLottie": "assets/animations/activity_correct.json",
      "wrongLottie": "assets/animations/activity_wrong.json",
      "submitLabel": "Check Answer",
      "feedback": {
        "correctText": "Yes, 'nervous' is normal. लेकिन polite approach से confidence आएगा!",
        "wrongText": "Hmm, 'confident' beginners के लिए typical नहीं. सही जवाब: nervous."
      }
    },
    {
      "type": "mentor_explain",
      "text": "कोई problem नहीं, nervous feel करना normal है. Practice से सब ठीक होगा!"
    },
    {
      "type": "poll",
      "question": "What is your current biggest hesitation in public help-seeking?",
      "options": [
        "Still shy",
        "Language barrier—Hindi से English में पहले translate करना और फिर बोलना",
        "Unsure which phrase is correct",
        "All of these"
      ],
      "dynamicFeedback": {
        "0": "Shy? Smile + short line helps break ice.",
        "1": "Switch is okay—थोड़ा Hinglish चलती है!",
        "2": "Keep phrases from this lesson as cheat sheet!",
        "3": "We’ll keep practicing with more examples!"
      }
    },
    {
      "type": "mentor_explain",
      "text": "चलो! Let’s do a short reorder. Keep it super polite!"
    },
    {
      "type": "sentence_construction",
      "words": ["Could", "guide", "please", "me?", "you"],
      "correctOrder": ["Could", "you", "please", "guide", "me?"],
      "imagePath": "assets/images/lesson1_calm_official_16x9.png"
    },
    {
      "type": "mentor_explain",
      "text": "देखो, पहले 'Could you', फिर 'please guide me?'— This flow is easy, polite. Let’s see a mini story now!"
    },
    {
      "type": "mini_stories",
      "scenes": [
        {
          "imagePath": "assets/images/lesson1_wedding_chaos_16x9.png",
          "text": "Scenario: आप एक huge Indian wedding में हो, सब dance कर रहे हैं और You want to ask someone to find the food counter politely!"
        },
        {
          "imagePath": "assets/images/lesson1_confident_pose_16x9.png",
          "text": "Instead of ‘भाई, buffet कहाँ है?!’ say: ‘Excuse me, मैं थोड़ा lost हूँ. Could you please guide me to the food area?’"
        },
        {
          "imagePath": "assets/images/lesson1_big_station_16x9.png",
          "text": "Lesson moral: Station हो या wedding, polite approach + short request = help guaranteed!"
        }
      ]
    },
    {
      "type": "mentor_explain",
      "text": "देखा—consistent polite formula हर जगह काम आता है. Next, एक word-builder try करें?"
    },
    {
      "type": "word_builder",
      "letters": ["H", "E", "L", "P"],
      "correctWord": "HELP",
      "extraLetters": ["R", "A"],
      "instruction": "Drag letters to form the word ‘HELP’. Basic but crucial word for seeking assistance!"
    },
    {
      "type": "mentor_explain",
      "text": "बस याद रखो: Tone + 'HELP' request = you’ll do fine in tricky spots. One final quiz!"
    },
    {
      "type": "quiz",
      "question": "Which line sounds politely direct, बिना over-apology?",
      "options": [
        "Hey, quickly tell me where to go now!",
        "I’m sorry, sorry, sorry…help me?",
        "Excuse me, I’m a bit lost—could you show me the exit?",
        "भाई, exit का रास्ता बता दो, यार."
      ],
      "answerIndex": 2,
      "hints": [
        "Look for short apology + direct request + polite tone."
      ],
      "correctSound": "assets/sounds/correct.mp3",
      "wrongSound": "assets/sounds/incorrect.mp3",
      "allowRetry": true,
      "encouragementOnFail": "No big deal, re-check polite vs. rude lines!"
    },
    {
      "type": "speaking_prompt",
      "prompt": "Verbal practice: ‘Excuse me, could you help me find [Your Name]? Thanks!’ अब loud बोलके देख लो!",
      "audioSupport": false
    },
    {
      "type": "text_card",
      "title": "Lesson Recap",
      "body": "1) ‘Excuse me…’ से शुरू करो\n2) बोल दो ‘I’m a bit lost’ या ‘Need help’\n3) Tone & courtesy सबसे ज़रूरी\n4) थोड़ा Hindi mix is okay—but remain polite"
    },
    {
      "type": "mentor_explain",
      "text": "Congratulations! अब आप हर situation में help माँग सकते हो politely बिना awkward हुए. Keep going!"
    },
    {
      "type": "next_lesson_preview",
      "title": "Next: Greetings & Goodbyes",
      "description": "आपका पहला ‘Hello’ और आख़िरी ‘Bye’ ही लोगों के दिमाग़ में आपकी image बनाता है. Ready to master that next?"
    },
    {
      "type": "badge_award",
      "title": "Help Seeker Hero!",
      "description": "Lesson 1 done—अब आप politely help माँग सकते हो, टेंशन-फ़्री. Keep practicing और मिलते हैं next lesson में!",
      "animation": "assets/animations/badge_unlocked.json"
    }
  ]
};
