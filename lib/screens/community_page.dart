import 'package:flutter/material.dart';
import 'package:fluentedge_app/constants.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

class CommunityPage extends StatelessWidget {
  const CommunityPage({super.key});

  final List<Map<String, dynamic>> mockFriends = const [
    {
      "name": "Riya Sharma",
      "avatar": "👩🏼",
      "xp": 820,
      "badges": [
        {
          "title": "Lesson Completion",
          "animation": "assets/animations/badges/lesson_completion_badge.json",
        },
        {
          "title": "Quiz Champion",
          "animation": "assets/animations/badges/quiz_champion_badge.json",
        }
      ]
    },
    {
      "name": "Aman Verma",
      "avatar": "👨🏻",
      "xp": 1050,
      "badges": [
        {
          "title": "Mastery Badge",
          "animation": "assets/animations/badges/course_mastery_badge.json",
        }
      ]
    },
    {
      "name": "Neha Singh",
      "avatar": "👩🏾",
      "xp": 990,
      "badges": []
    },
    {
      "name": "Aditya Mehra",
      "avatar": "👨🏽",
      "xp": 1150,
      "badges": [
        {
          "title": "Daily Learner",
          "animation": "assets/animations/badges/fast_learner_badge.json",
        }
      ]
    },
    {
      "name": "Sanya Das",
      "avatar": "👩🏻",
      "xp": 720,
      "badges": []
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundSoftBlue,
      appBar: AppBar(
        title: const Text("👥 Community"),
        backgroundColor: kPrimaryBlue,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          // ✨ Animated Invite Banner
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFBBDEFB), Color(0xFFE3F2FD)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Row(
              children: [
                Lottie.asset('assets/animations/confetti_success.json', height: 80),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        "Invite your friends",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "Grow together and earn bonus XP!",
                        style: TextStyle(fontSize: 12.5, color: Colors.black54),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("📨 Invite sent!")),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kAccentGreen,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  ),
                  child: const Text("Invite"),
                ),
              ],
            ),
          ),

          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              "🌟 Friends in Your Network",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: kPrimaryIconBlue,
              ),
            ),
          ),

          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: mockFriends.length,
              itemBuilder: (context, index) {
                final friend = mockFriends[index];
                return GestureDetector(
                  onTap: () {
                    GoRouter.of(context).push('/friendDetail', extra: {
                      'friendName': friend['name'],
                      'avatarEmoji': friend['avatar'],
                      'xp': friend['xp'],
                      'badges': friend['badges'],
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.08),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Text(friend['avatar'], style: const TextStyle(fontSize: 24)),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            friend['name'],
                            style: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.w600),
                          ),
                        ),
                        Text(
                          "${friend['xp']} XP",
                          style: const TextStyle(
                            fontSize: 13.5,
                            fontWeight: FontWeight.bold,
                            color: kAccentGreen,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
