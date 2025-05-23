const Map<String, dynamic> beginner001Lesson002 = {
  "lessonId": "beginner_001_lesson_002",
  "title": "Simple Greetings & Goodbyes",
  "level": "beginner",
  "themeColor": "#4A90E2",
  "xpTotal": 500,
  "objectives": [
    "Build confidence in greeting people in English using basic words",
    "Learn polite ways to say Hello and Goodbye",
    "Mix short Hindi for comfort without losing politeness",
    "Enjoy small talk without feeling awkward"
  ],
  "mentorDefaults": {
    "expression": "mentor_tip_upper.png",
    "voiceLangs": ["en", "hi"],
    "typingIndicator": "assets/lottie/typing_indicator_dots.json"
  },
  "badgeAwarded": {
    "id": "greeting_goodbye_champion",
    "title": "Greetings & Goodbyes Champion",
    "animation": "assets/animations/badge_unlocked.json"
  },
  "activities": [
    {
      "type": "mentor_intro",
      "text": "नमस्ते & Welcome to Lesson 2! आज हम सीखेंगे 'Greetings & Goodbyes'—यानी आपका पहला ‘Hello’ और आख़िरी ‘Bye’ कैसे magical हो सकता है!",
      "imagePath": "assets/images/lesson2_course_intro.png"
    },
    {
      "type": "scene_image",
      "caption": "Imagine: आप एक दोस्त या new coworker से मिल रहे हो. पहला impression ही सब कुछ है!",
      "imagePath": "assets/images/lesson2_greetings_scene_01.png"
    },
    {
      "type": "mentor_explain",
      "text": "इस lesson में हम basic greetings सीखेंगे—like 'Hello', 'Hi', 'Goodbye', etc. पर ध्यान रहे कि tone & smile सबसे important है!",
      "imagePath": "assets/images/lesson2_smile_guide.png"
    },
    {
      "type": "today_vocabulary",
      "vocabItems": [
        {
          "word": "Hello",
          "meaning": "A simple universal greeting, ‘नमस्ते’ vibe in English.",
          "image": "assets/images/lesson2_vocab_hello.png"
        },
        {
          "word": "Hi",
          "meaning": "Short, casual greeting—like ‘Hey!’",
          "image": "assets/images/lesson2_vocab_hi.png"
        },
        {
          "word": "Goodbye",
          "meaning": "Polite farewell—like ‘Alvida’ in an English tone.",
          "image": "assets/images/lesson2_vocab_goodbye.png"
        },
        {
          "word": "See you soon",
          "meaning": "Friendly parting phrase, suggests you’ll meet again quickly.",
          "image": "assets/images/lesson2_vocab_seeyousoon.png"
        },
        {
          "word": "Nice to meet you",
          "meaning": "Express happiness in meeting someone new.",
          "image": "assets/images/lesson2_vocab_nicetomeetyou.png"
        }
      ]
    },
    {
      "type": "fill_in_the_blanks",
      "sentence": "______! My name is Priya. How are you?",
      "correctWord": "Hello",
      "imagePath": "assets/images/lesson2_conversation_start.png",
      "hints": [
        "Short greeting, English में सबसे common word!",
        "Hindi: ‘नमस्ते’ की English version"
      ],
      "correctSound": "assets/sounds/correct.mp3",
      "wrongSound": "assets/sounds/incorrect.mp3",
      "correctLottie": "assets/animations/activity_correct.json",
      "wrongLottie": "assets/animations/activity_wrong.json",
      "submitLabel": "Check Answer",
      "feedback": {
        "correctText": "Yes, ‘Hello’ is perfect to start a conversation politely!",
        "wrongText": "Try ‘Hello’—short, universal, easy. ‘Hi’ also works but let’s pick the standard answer."
      }
    },
    {
      "type": "poll",
      "question": "आप greeting करने से पहले सबसे ज़्यादा क्या सोचते हो?",
      "options": [
        "मेरी English ठीक है या नहीं?",
        "शर्मा जाता हूँ (feel shy)!",
        "कुछ ज़्यादा बोलना पड़ेगा?",
        "Nothing—I’m confident!"
      ],
      "dynamicFeedback": {
        "0": "Grammar छोड़ो—short & sweet English enough है greeting के लिए!",
        "1": "Smile + short line breaks shyness!",
        "2": "2-3 lines enough for a greeting—कोई essay नहीं!",
        "3": "Wah, that’s great! Keep it up!"
      },
      "imagePath": "assets/images/lesson2_poll_hesitation.png"
    },
    {
      "type": "fill_in_the_blanks",
      "sentence": "It was ______ (nice/boring) to meet you. See you soon!",
      "correctWord": "nice",
      "imagePath": "assets/images/lesson2_meeting_end.png",
      "hints": [
        "After a greeting, you show positivity with ‘nice’",
        "Hindi: ‘मुझे अच्छा लगा आपसे मिलके!’"
      ],
      "correctSound": "assets/sounds/correct.mp3",
      "wrongSound": "assets/sounds/incorrect.mp3",
      "correctLottie": "assets/animations/activity_correct.json",
      "wrongLottie": "assets/animations/activity_wrong.json",
      "submitLabel": "Check Answer",
      "feedback": {
        "correctText": "Yes! Always be positive. ‘Nice to meet you’ sets a good tone.",
        "wrongText": "‘Boring’ rude या negative लगेगा न? Politeness चाहिए!"
      }
    },
    {
      "type": "quiz",
      "question": "Which greeting is best for a new coworker in an office?",
      "options": [
        "Hi bro, what’s up?",
        "Yo man!",
        "Hello, nice to meet you!",
        "Hey, gimme your name!"
      ],
      "answerIndex": 2,
      "hints": [
        "Formal or semi-formal environment—polite English phrase is ideal."
      ],
      "correctSound": "assets/sounds/correct.mp3",
      "wrongSound": "assets/sounds/incorrect.mp3",
      "allowRetry": true,
      "encouragementOnFail": "No worries, check politeness & positivity!"
    },
    {
      "type": "scene_image",
      "caption": "Office scenario: Meeting your new teammate politely.",
      "imagePath": "assets/images/lesson2_office_meeting.png"
    },
    {
      "type": "mentor_explain",
      "text": "देखो, formal या new person के लिए ‘Hello, nice to meet you’ best है. ‘भाई’/‘यार’ तो close friends के लिए use करो!",
      "imagePath": "assets/images/lesson2_mentor_explain_formal.png"
    },
    {
      "type": "fill_in_the_blanks",
      "sentence": "Hi, I’m Rahul. ______ (Nice to meet/Go away) you!",
      "correctWord": "Nice to meet",
      "imagePath": "assets/images/lesson2_team_intro.png",
      "hints": [
        "When you greet, show positivity!",
        "Hindi idea: ‘आपसे मिलकर अच्छा लगा’"
      ],
      "correctSound": "assets/sounds/correct.mp3",
      "wrongSound": "assets/sounds/incorrect.mp3",
      "correctLottie": "assets/animations/activity_correct.json",
      "wrongLottie": "assets/animations/activity_wrong.json",
      "submitLabel": "Check Answer",
      "feedback": {
        "correctText": "Spot on! ‘Nice to meet you’ is a friendly starter.",
        "wrongText": "‘Go away’?! That’s rude—avoid negativity!"
      }
    },
    {
      "type": "sentence_construction",
      "words": ["Hello,", "my", "name", "is", "Ayesha!"],
      "correctOrder": ["Hello,", "my", "name", "is", "Ayesha!"],
      "imagePath": "assets/images/lesson2_self_intro.png"
    },
    {
      "type": "speaking_prompt",
      "prompt": "बोलकर practice: ‘Hello, my name is ____. Nice to meet you!’ Louder, with a smile!",
      "audioSupport": false,
      "imagePath": "assets/images/lesson2_speaking_prompt.png"
    },
    {
      "type": "fill_in_the_blanks",
      "sentence": "______ (Hi/Bye), how’s your day?",
      "correctWord": "Hi",
      "imagePath": "assets/images/lesson2_small_talk.png",
      "hints": [
        "Short casual greeting before you chat further",
        "Hindi sense: ‘अरे hi!’"
      ],
      "correctSound": "assets/sounds/correct.mp3",
      "wrongSound": "assets/sounds/incorrect.mp3",
      "correctLottie": "assets/animations/activity_correct.json",
      "wrongLottie": "assets/animations/activity_wrong.json",
      "submitLabel": "Check Answer",
      "feedback": {
        "correctText": "Yes! Start with ‘Hi, how’s your day?’— super casual & friendly!",
        "wrongText": "Wrong—If you say ‘Bye’, conversation ends!"
      }
    },
    {
      "type": "spot_the_error",
      "instruction": "Identify the inappropriate word for this situation.",
      "originalSentence": "Yo man! Can you help me with directions, please?",
      "choices": ["Yo", "man!", "directions", "please"],
      "correctChoiceIndex": 0,
      "explanation": "‘Yo’ is too informal for speaking to an older or formally dressed person. A polite greeting like 'Excuse me' would be better.",
      "imagePath": "assets/images/lesson2_spot_error.png"
    },
    {
      "type": "quiz",
      "question": "Which ‘goodbye’ is gentle & polite, not rude?",
      "options": [
        "I’m outta here!",
        "Bye—see you soon!",
        "Ok done, go now.",
        "Stop talking, gotta run!"
      ],
      "answerIndex": 1,
      "hints": [
        "Look for positivity & friendly tone."
      ],
      "correctSound": "assets/sounds/correct.mp3",
      "wrongSound": "assets/sounds/incorrect.mp3",
      "allowRetry": true,
      "encouragementOnFail": "Re-check which option is polite!"
    },
    {
      "type": "scene_image",
      "caption": "At a friend’s house: Time to leave politely with a smile!",
      "imagePath": "assets/images/lesson2_farewell_friendhouse.png"
    },
    {
      "type": "fill_in_the_blanks",
      "sentence": "Okay, I should go now. ______ (Goodbye/Hello), take care!",
      "correctWord": "Goodbye",
      "imagePath": "assets/images/lesson2_leaving_home.png",
      "hints": [
        "Leaving? Say farewell politely!",
        "Hindi: ‘चलता हूँ!’ but in English we use a polite alternative"
      ],
      "correctSound": "assets/sounds/correct.mp3",
      "wrongSound": "assets/sounds/incorrect.mp3",
      "correctLottie": "assets/animations/activity_correct.json",
      "wrongLottie": "assets/animations/activity_wrong.json",
      "submitLabel": "Check Answer",
      "feedback": {
        "correctText": "Yes! ‘Goodbye, take care!’ is perfect to end politely!",
        "wrongText": "Wrong. ‘Hello’ is for starting, not ending!"
      }
    },
    {
      "type": "fill_in_the_blanks",
      "sentence": "It was really ______ (nice/bad) talking with you. Let’s do this again!",
      "correctWord": "nice",
      "imagePath": "assets/images/lesson2_warm_farewell.png",
      "hints": [
        "You want to compliment the meeting, so ‘nice’ is typical",
        "Hindi: ‘बहुत अच्छा लगा!’"
      ],
      "correctSound": "assets/sounds/correct.mp3",
      "wrongSound": "assets/sounds/incorrect.mp3",
      "correctLottie": "assets/animations/activity_correct.json",
      "wrongLottie": "assets/animations/activity_wrong.json",
      "submitLabel": "Check Answer",
      "feedback": {
        "correctText": "Yes! Spreading positivity is key to goodbyes.",
        "wrongText": "No negativity—avoid harsh or random words!"
      }
    },
    {
      "type": "poll",
      "question": "आपके लिए goodbye बोलना सबसे मुश्किल कब होता है?",
      "options": [
        "Office meeting end",
        "Close friend से मिलकर जब अलग होना होता है",
        "Formal events, not sure what to say",
        "मुश्किल नहीं लगता"
      ],
      "dynamicFeedback": {
        "0": "Office में एक short polite line works: ‘Alright, talk soon!’",
        "1": "Emotional? ‘Bye, see you soon, keep in touch!’ helps",
        "2": "Formal event? ‘Thank you for your time, goodbye!’ is safe.",
        "3": "That’s nice—some people are just naturals!"
      },
      "imagePath": "assets/images/lesson2_emotional_goodbye.png"
    },
    {
      "type": "mini_stories",
      "scenes": [
        {
          "imagePath": "assets/images/lesson2_mall_meetup.png",
          "text": "Scenario 1: Bumped into an old friend at a mall—greeting them: “Hey, long time! Nice to see you.”"
        },
        {
          "imagePath": "assets/images/lesson2_small_group.png",
          "text": "Scenario 2: Meeting a group briefly: “Hello everyone, hope you’re doing good!”"
        }
      ]
    },
    {
      "type": "mini_stories",
      "scenes": [
        {
          "imagePath": "assets/images/lesson2_mall_leaving.png",
          "text": "When leaving: 'It was awesome catching up! See you soon!'"
        },
        {
          "imagePath": "assets/images/lesson2_smile_farewell.png",
          "text": "Lesson moral: Use warm lines, a smile, & genuine tone. कोई fancy grammar ज़रूरी नहीं!"
        }
      ]
    },
    {
      "type": "word_builder",
      "letters": ["H", "I"],
      "correctWord": "HI",
      "extraLetters": ["X", "P"],
      "instruction": "Build a super short greeting. 2 letters only!"
    },
    {
      "type": "scene_image",
      "caption": "A short but powerful greeting can open hearts!",
      "imagePath": "assets/images/lesson2_hi_power.png"
    },
    {
      "type": "mentor_explain",
      "text": "‘Hi’ casual है, पर effective. अगर आप formal चाहते हो तो ‘Hello’ use करो. दोनों में smile ज़रूरी है!",
      "imagePath": "assets/images/lesson2_mentor_speaking.png"
    },
    {
      "type": "fill_in_the_blanks",
      "sentence": "______ (Hi/Bye), how have you been?",
      "correctWord": "Hi",
      "imagePath": "assets/images/lesson2_how_have_you_been.png",
      "hints": [
        "Asking about well-being? Start with ‘Hi’ or ‘Hello’, not ‘Bye’"
      ],
      "correctSound": "assets/sounds/correct.mp3",
      "wrongSound": "assets/sounds/incorrect.mp3",
      "correctLottie": "assets/animations/activity_correct.json",
      "wrongLottie": "assets/animations/activity_wrong.json",
      "submitLabel": "Check Answer",
      "feedback": {
        "correctText": "Right! ‘Hi’ is perfect for a friendly check-in.",
        "wrongText": "Wrong—If you say ‘Bye’, conversation ends immediately!"
      }
    },
    {
      "type": "spot_the_error",
      "instruction": "Spot the word that feels rude:",
      "originalSentence": "Hey! Move aside, I want to say hello to my Friend.",
      "choices": ["Hey!", "Move aside,", "hello", "properly."],
      "correctChoiceIndex": 1,
      "explanation": "‘Move aside’ sounds rude. In a friendly greeting, we should not push someone away!",
      "imagePath": "assets/images/lesson2_spot_error_friendly.png"
    },
    {
      "type": "poll",
      "question": "When you say ‘Bye’ to family/friends, do you use English words or Hindi?",
      "options": [
        "Mostly Hindi phrases like ‘चलता हूँ!’",
        "Pure English—‘Goodbye, see you!’",
        "Hinglish mix—‘Bye यार, मिलते हैं!’",
        "Never realized, it’s random!"
      ],
      "dynamicFeedback": {
        "0": "Try short English lines to practice daily!",
        "1": "Wah, keep it up! This lesson will refine your usage.",
        "2": "Hinglish is great—just keep tone positive!",
        "3": "Observing your own habit helps improvement!"
      },
      "imagePath": "assets/images/lesson2_poll_family_farewell.png"
    },
    {
      "type": "fill_in_the_blanks",
      "sentence": "It was ______ (fun/sad) meeting you. Let’s catch up soon!",
      "correctWord": "fun",
      "imagePath": "assets/images/lesson2_fun_meet.png",
      "hints": [
        "Positivity after meeting someone is good courtesy."
      ],
      "correctSound": "assets/sounds/correct.mp3",
      "wrongSound": "assets/sounds/incorrect.mp3",
      "correctLottie": "assets/animations/activity_correct.json",
      "wrongLottie": "assets/animations/activity_wrong.json",
      "submitLabel": "Check Answer",
      "feedback": {
        "correctText": "Yes, ‘fun meeting you’ is a nice vibe.",
        "wrongText": "‘Sad meeting you’? That’s negative vibe!"
      }
    },
    {
      "type": "quiz",
      "question": "Which is a polite goodbye to a coworker?",
      "options": [
        "Ok stop, I must go!",
        "Alright, talk soon—take care!",
        "Go away, time’s up.",
        "None of these"
      ],
      "answerIndex": 1,
      "hints": [
        "Look for friendly parting line!"
      ],
      "correctSound": "assets/sounds/correct.mp3",
      "wrongSound": "assets/sounds/incorrect.mp3",
      "allowRetry": true,
      "encouragementOnFail": "Check positivity again!"
    },
    {
      "type": "sentence_construction",
      "words": ["Hey,", "see", "to", "great", "you!"],
      "correctOrder": ["Hey,", "great", "to", "see", "you!"],
      "imagePath": "assets/images/lesson2_sentence_construct_great.png"
    },
    {
      "type": "speaking_prompt",
      "prompt": "Verbal practice: ‘Hey, great to see you!’ ज़ोर से बोलो, with a smile",
      "audioSupport": false,
      "imagePath": "assets/images/lesson2_speaking_great2seeu.png"
    },
    {
      "type": "fill_in_the_blanks",
      "sentence": "______ (Hello/Goodbye), let’s keep in touch!",
      "correctWord": "Goodbye",
      "imagePath": "assets/images/lesson2_keep_in_touch.png",
      "hints": [
        "Ending statement but still positive!"
      ],
      "correctSound": "assets/sounds/correct.mp3",
      "wrongSound": "assets/sounds/incorrect.mp3",
      "correctLottie": "assets/animations/activity_correct.json",
      "wrongLottie": "assets/animations/activity_wrong.json",
      "submitLabel": "Check Answer",
      "feedback": {
        "correctText": "Yes, ‘Goodbye, let’s keep in touch!’ is a perfect parting line.",
        "wrongText": "‘Hello’ is a greeting, not a goodbye."
      }
    },
    {
      "type": "scene_image",
      "caption": "Imagine you’re leaving a friend’s party—use polite farewell lines!",
      "imagePath": "assets/images/lesson2_friend_party.png"
    },
    {
      "type": "fill_in_the_blanks",
      "sentence": "It was ______ (nice/bad) talking with you. Let’s do this again!",
      "correctWord": "nice",
      "imagePath": "assets/images/lesson2_fun_chat.png",
      "hints": [
        "Positive, friendly tone is everything!"
      ],
      "correctSound": "assets/sounds/correct.mp3",
      "wrongSound": "assets/sounds/incorrect.mp3",
      "correctLottie": "assets/animations/activity_correct.json",
      "wrongLottie": "assets/animations/activity_wrong.json",
      "submitLabel": "Check Answer",
      "feedback": {
        "correctText": "Yes! Keep it uplifting always.",
        "wrongText": "Using ‘bad’ is negative—avoid it."
      }
    },
    {
      "type": "quiz",
      "question": "Best quick greeting for new buddy?",
      "options": [
        "Yo, weird place right?",
        "Hello, good to see you!",
        "So... who are you?",
        "Huh, you again?"
      ],
      "answerIndex": 1,
      "hints": [
        "Look for positivity + politeness."
      ],
      "correctSound": "assets/sounds/correct.mp3",
      "wrongSound": "assets/sounds/incorrect.mp3",
      "allowRetry": true,
      "encouragementOnFail": "Check the friendly factor again!"
    },
    {
      "type": "speaking_prompt",
      "prompt": "Say out loud: ‘Hi, good to see you. How’ve you been?’",
      "audioSupport": false,
      "imagePath": "assets/images/lesson2_speaking_goodtosee.png"
    },
    {
      "type": "poll",
      "question": "What is your biggest challenge in saying goodbyes?",
      "options": [
        "I forget polite phrases",
        "I feel weird or emotional",
        "I’m too abrupt—just say ‘Ok bye’",
        "None, I’m comfortable"
      ],
      "dynamicFeedback": {
        "0": "Keep a short line ready: ‘Nice meeting you, see you soon!’",
        "1": "It’s normal! Try gentle lines: ‘Take care!’",
        "2": "Add a small reason or positive phrase, so not abrupt!",
        "3": "Awesome, keep it up!"
      },
      "imagePath": "assets/images/lesson2_farewell_challenge.png"
    },
    {
      "type": "fill_in_the_blanks",
      "sentence": "Alright, I gotta go. ______ (Bye/Hello) for now!",
      "correctWord": "Bye",
      "imagePath": "assets/images/lesson2_alright_gotta_go.png",
      "hints": [
        "Leaving? ‘Bye’ is the final word!"
      ],
      "correctSound": "assets/sounds/correct.mp3",
      "wrongSound": "assets/sounds/incorrect.mp3",
      "correctLottie": "assets/animations/activity_correct.json",
      "wrongLottie": "assets/animations/activity_wrong.json",
      "submitLabel": "Check Answer",
      "feedback": {
        "correctText": "Yes! ‘Bye for now’ is a friendly short parting line.",
        "wrongText": "Wrong—Hello is for starting, not ending!"
      }
    },
    {
      "type": "sentence_construction",
      "words": ["Bye,", "later!", "talk", "to", "you"],
      "correctOrder": ["Bye,", "talk", "to", "you", "later!"],
      "imagePath": "assets/images/lesson2_bye_ttyl.png"
    },
    {
      "type": "spot_the_error",
      "instruction": "Identify the rude phrase:",
      "originalSentence": "Hey you, bye never mind, I'm ignoring you.",
      "choices": ["Hey you,", "bye", "never mind,", "ignoring"],
      "correctChoiceIndex": 3,
      "explanation": "‘Ignoring’ is negative. We want positivity in greetings/goodbyes!",
      "imagePath": "assets/images/lesson2_spot_error_rude.png"
    },
    {
      "type": "mentor_explain",
      "text": "हमेशा याद रखो: आख़िरी words ही strong impression छोड़ते हैं. ‘Take care, bye!’ हमेशा safe रहता है.",
      "imagePath": "assets/images/lesson2_final_impression.png"
    },
    {
      "type": "fill_in_the_blanks",
      "sentence": "Good ______ (morning/sadness)! Great to see you bright and early.",
      "correctWord": "morning",
      "imagePath": "assets/images/lesson2_good_morning_scene.png",
      "hints": [
        "One common greeting for early day",
        "Hindi: ‘सुबह की नमस्ते’"
      ],
      "correctSound": "assets/sounds/correct.mp3",
      "wrongSound": "assets/sounds/incorrect.mp3",
      "correctLottie": "assets/animations/activity_correct.json",
      "wrongLottie": "assets/animations/activity_wrong.json",
      "submitLabel": "Check Answer",
      "feedback": {
        "correctText": "Yes, ‘Good morning’ is a cheerful start!",
        "wrongText": "‘Good sadness’? That’s not a greeting at all!"
      }
    },
    {
      "type": "word_builder",
      "letters": ["B", "Y", "E"],
      "correctWord": "BYE",
      "extraLetters": ["Q", "R"],
      "instruction": "Build a short farewell. 3 letters!"
    },
    {
      "type": "mini_stories",
      "scenes": [
        {
          "imagePath": "assets/images/lesson2_office_story.png",
          "text": "Story: You see your boss: ‘Good morning, how are you?’ politely. Boss replies ‘Good morning, I'm fine. Thanks!’"
        },
        {
          "imagePath": "assets/images/lesson2_office_bye.png",
          "text": "You leave after short chat: ‘It was nice catching up. Goodbye for now!’"
        }
      ]
    },
    {
      "type": "poll",
      "question": "While greeting boss or seniors, do you get nervous?",
      "options": [
        "Yes, every time!",
        "Sometimes, depends on mood",
        "No, I'm usually confident",
        "I avoid greeting them"
      ],
      "dynamicFeedback": {
        "0": "Short line + calm voice try karo. धीरे-धीरे confidence आएगी!",
        "1": "Keep practicing polite lines from this lesson!",
        "2": "Great, keep sharing your positivity!",
        "3": "Better to greet them politely than ignore!"
      },
      "imagePath": "assets/images/lesson2_boss_greeting.png"
    },
    {
      "type": "quiz",
      "question": "Best short greeting for your boss?",
      "options": [
        "Hi buddy, how’s it going?",
        "Morning sir, how are you?",
        "Yo boss, sup?",
        "I guess hi or something"
      ],
      "answerIndex": 1,
      "hints": [
        "Slight formality helps with seniors."
      ],
      "correctSound": "assets/sounds/correct.mp3",
      "wrongSound": "assets/sounds/incorrect.mp3",
      "allowRetry": true,
      "encouragementOnFail": "Check the polite factor again!"
    },
    {
      "type": "text_card",
      "title": "Lesson 2 Recap",
      "body": "1) Greet with ‘Hello’/‘Hi’ + a warm tone\n2) Use short positive lines to say goodbye\n3) Hindi-English mix is ok—but polite vibe is #1\n4) Smile & eye contact can amplify your greeting!"
    },
    {
      "type": "next_lesson_preview",
      "title": "Next: Self Introductions!",
      "description": "How do you describe who you are, your hobbies, and more—without feeling shy? Let's tackle that next!"
    },
    {
      "type": "badge_award",
      "title": "Greetings & Goodbyes Champion!",
      "description": "Congrats, Lesson 2 complete—अब आप confidently Hello/Bye बोल सकते हो. Keep it up!",
      "animation": "assets/animations/badge_unlocked.json"
    }
  ]
};
